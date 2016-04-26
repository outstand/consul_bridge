require 'consul_bridge/base'
require 'consul_bridge/detect_consul'
require 'consul_bridge/download_masters'
require 'consul_bridge/join_consul'

module ConsulBridge
  class BootstrapConsul < Base
    attr_accessor :bucket, :join_all

    def initialize(bucket:, join_all: false)
      self.bucket = bucket
      self.join_all = join_all
    end

    def call
      while !DetectConsul.call.running
        puts 'Local consul agent not detected, sleeping for 5 seconds'
        sleep 5
      end

      puts '==> Bootstrapping consul'
      master_ips = DownloadMasters.call(bucket: self.bucket).master_ips
      JoinConsul.call(master_ips: master_ips, join_all: self.join_all)
      puts '==> Done.'
    end
  end
end
