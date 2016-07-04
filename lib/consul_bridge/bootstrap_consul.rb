require 'metaractor'
require 'consul_bridge/detect_consul'
require 'consul_bridge/download_masters'
require 'consul_bridge/join_consul'

module ConsulBridge
  class BootstrapConsul
    include Metaractor

    required :bucket, :join_all

    def call
      while !DetectConsul.call!.running
        puts 'Local consul agent not detected, sleeping for 5 seconds'
        sleep 5
      end

      puts '==> Bootstrapping consul'
      master_ips = DownloadMasters.call!(bucket: bucket).master_ips
      JoinConsul.call!(master_ips: master_ips, join_all: join_all)
      puts '==> Done.'
    end

    private
    def bucket
      context.bucket
    end

    def join_all
      context.join_all
    end
  end
end
