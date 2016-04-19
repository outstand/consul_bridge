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
        MonitorDockerEvents.call(
          container_name: @container_name,
          handler: ->(event){ @bootstrap_actor << :bootstrap }
        )
      else
        pass
      end
    end
  end
end
