require 'concurrent'
require 'concurrent-edge'
require 'consul_bridge/bootstrap_consul'

module ConsulBridge
  class BootstrapConsulActor < Concurrent::Actor::RestartingContext
    def initialize(bucket:)
      @bucket = bucket
    end

    def on_message(message)
      if message == :bootstrap
        begin
          BootstrapConsul.call(bucket: @bucket)
        rescue => e
          puts "Warning: #{e.message}; retrying in 5 seconds"
          Concurrent::ScheduledTask.execute(5){ tell :bootstrap }
        end
      else
        pass
      end
    end
  end
end
