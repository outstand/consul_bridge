require 'consul_bridge/base'
require 'consul_bridge/get_private_ip'
require 'excon'

module ConsulBridge
  class JoinConsul < Base
    attr_accessor :master_ips

    JOIN_URL = 'http://127.0.0.1:8500/v1/agent/join'.freeze

    def initialize(master_ips:)
      self.master_ips = master_ips
    end

    def call
      private_ip = GetPrivateIP.call.private_ip
      puts "Detected private ip: #{private_ip}"

      joined = false
      master_ips.each do |ip|
        next if ip == private_ip
        begin
          puts "Trying to join #{ip}"
          Excon.get(
            JOIN_URL + "/#{ip}",
            expects: [200],
            connect_timeout: 5,
            read_timeout: 11,
            write_timeout: 5,
            tcp_nodelay: true
          )
          joined = true
          break
        rescue Excon::Errors::HTTPStatusError
          next
        end
      end

      raise "Unable to join with any of: [#{master_ips.join(', ')}]"
    end

  end
end
