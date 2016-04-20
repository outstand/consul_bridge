require 'consul_bridge/base'
require 'consul_bridge/bootstrap_consul_actor'
require 'consul_bridge/monitor_docker_events_actor'
require 'concurrent'

module ConsulBridge
  class RunBridge < Base
    attr_accessor :bucket, :container_name, :join_all

    def initialize(bucket:, container_name:, join_all: false)
      self.bucket = bucket
      self.container_name = container_name
      self.join_all = join_all
    end

    def call
      # Enable for actor debugging
      # Concurrent.use_stdlib_logger(Logger::DEBUG)
      self_read, self_write = IO.pipe
      %w(INT TERM).each do |sig|
        begin
          trap sig do
            self_write.puts(sig)
          end
        rescue ArgumentError
          puts "Signal #{sig} not supported"
        end
      end

      begin
        bootstrap_actor = BootstrapConsulActor.spawn(
          :bootstrap_consul,
          bucket: self.bucket,
          join_all: self.join_all
        )
        bootstrap_actor << :bootstrap

        MonitorDockerEventsActor.spawn(
          :monitor_docker_events,
          bootstrap_actor: bootstrap_actor,
          container_name: container_name
        )

        while readable_io = IO.select([self_read])
          signal = readable_io.first[0].gets.strip
          handle_signal(signal)
        end

      rescue Interrupt
        puts 'Exiting'
        # actors are cleaned up in at_exit handler
        exit 0
      end
    end

    def handle_signal(sig)
      case sig
      when 'INT'
        raise Interrupt
      when 'TERM'
        raise Interrupt
      end
    end
  end
end
