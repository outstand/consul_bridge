require 'consul_bridge/base'
require 'excon'

module ConsulBridge
  class GetPrivateIP < Base
    URL = 'http://169.254.169.254/latest/meta-data/local-ipv4'.freeze

    def call
      response = Excon.get(URL, expects: [200], connect_timeout: 10, read_timeout: 10, write_timeout: 10, tcp_nodelay: true)
      OpenStruct.new(
        private_ip: response.body
      )
    end
  end
end
