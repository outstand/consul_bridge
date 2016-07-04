require 'metaractor'
require 'consul_bridge/bootstrap_consul_actor'
require 'consul_bridge/monitor_docker_events_actor'
require 'concurrent'

module ConsulBridge
  class RunBridge
    include Metaractor

    required :bucket, :container_name, :join_all, :verbose

    before do
      context.join_all ||= false
      context.verbose ||= false
    end

    def call
      Concurrent.use_stdlib_logger(Logger::DEBUG) if verbose

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
          bucket: bucket,
          join_all: join_all
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

    private
    def handle_signal(sig)
      case sig
      when 'INT'
        raise Interrupt
      when 'TERM'
        raise Interrupt
      end
    end

    def bucket
      context.bucket
    end

    def container_name
      context.container_name
    end

    def join_all
      context.join_all
    end

    def verbose
      context.verbose
    end
  end
end
