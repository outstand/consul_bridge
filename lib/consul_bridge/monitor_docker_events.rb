require 'metaractor'
require 'docker-api'

module ConsulBridge
  class MonitorDockerEvents
    include Metaractor

    required :container_name, :handler

    def call
      begin
        filters = {type: [:container], event: [:start], container: [container_name]}.to_json
        Docker::Event.stream(filters: filters) do |event|
          handler.call(event)
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

    private
    def container_name
      context.container_name
    end

    def handler
      context.handler
    end
  end
end
