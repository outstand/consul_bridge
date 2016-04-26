require 'consul_bridge/base'
require 'docker-api'

module ConsulBridge
  class MonitorDockerEvents < Base
    attr_accessor :container_name, :handler

    def initialize(container_name:, handler:)
      self.container_name = container_name
      self.handler = handler
    end

    def call
      begin
        filters = {type: [:container], event: [:start], container: [self.container_name]}.to_json
        Docker::Event.stream(filters: filters) do |event|
          self.handler.call(event)
        end
      rescue Docker::Error::TimeoutError
        retry
      rescue Excon::Errors::SocketError => e
        if Errno::ENOENT === e.cause
          raise
        else
          puts "Warning: #{e.message}; retrying"
          retry
        end
      end
    end
  end
end
