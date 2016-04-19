require 'consul_bridge/base'
require 'consul_bridge/detect_consul'
require 'consul_bridge/detect_consul_bootstrap'
require 'consul_bridge/download_masters'
require 'consul_bridge/join_consul'

module ConsulBridge
  class BootstrapConsul < Base
    attr_accessor :bucket

    def initialize(bucket:)
      self.bucket = bucket
    end

    def call
      while !DetectConsul.call.running
        puts 'Local consul agent not detected, sleeping for 5 seconds'
        sleep 5
      end

      master_ips = DownloadMasters.call(bucket: self.bucket).master_ips
      JoinConsul.call(master_ips: master_ips)
    end
  end
end
