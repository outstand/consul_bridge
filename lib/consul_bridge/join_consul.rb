require 'metaractor'
require 'consul_bridge/get_private_ip'
require 'excon'

module ConsulBridge
  class JoinConsul
    include Metaractor

    required :master_ips, :join_all

    JOIN_URL = 'http://127.0.0.1:8500/v1/agent/join'.freeze

    def call
      private_ip = GetPrivateIP.call!.private_ip
      puts "Detected private ip: #{private_ip}"
      puts "Starting join with [#{master_ips.join(', ')}]"

      joined = 0
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
          puts "Joined #{ip}"
          joined += 1
          break unless join_all
        rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError
          next
        end
      end

      if join_all && joined < 2
        raise 'Unable to join at least 2 masters with join_all'
      elsif !join_all && joined < 1
        raise 'Unable to join any master'
      end
    end

    private
    def master_ips
      context.master_ips
    end

    def join_all
      context.join_all
    end

  end
end
