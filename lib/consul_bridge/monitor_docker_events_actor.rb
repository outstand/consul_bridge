require 'concurrent'
require 'concurrent-edge'
require 'consul_bridge/monitor_docker_events'

module ConsulBridge
  class MonitorDockerEventsActor < Concurrent::Actor::RestartingContext
    def initialize(bootstrap_actor:, container_name:)
      @bootstrap_actor = bootstrap_actor
      @container_name = container_name

      tell :monitor
    end

    def on_message(message)
      if message == :monitor
        begin
          MonitorDockerEvents.call!(
            container_name: @container_name,
            handler: ->(event){ @bootstrap_actor << :bootstrap }
          )
        rescue Excon::Errors::SocketError => e
          if Errno::ENOENT === e.cause
            puts "Warning: #{e.cause.message}; retrying in 30 seconds"
            Concurrent::ScheduledTask.execute(30){ tell :monitor }
          end
        end

        nil
      else
        pass
      end
    end
  end
end
