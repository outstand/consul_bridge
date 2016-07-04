require 'concurrent'
require 'concurrent-edge'
require 'consul_bridge/bootstrap_consul'

module ConsulBridge
  class BootstrapConsulActor < Concurrent::Actor::RestartingContext
    def initialize(bucket:, join_all: false)
      @bucket = bucket
      @join_all = join_all
    end

    def on_message(message)
      if message == :bootstrap
        begin
          BootstrapConsul.call!(bucket: @bucket, join_all: @join_all)
        rescue => e
          puts "Warning: #{e.message}; retrying in 5 seconds"
          Concurrent::ScheduledTask.execute(5){ tell :bootstrap }
        end

        nil
      else
        pass
      end
    end
  end
end
