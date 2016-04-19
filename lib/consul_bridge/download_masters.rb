require 'consul_bridge/base'
require 'fog/aws'

module ConsulBridge
  class DownloadMasters < Base
    attr_accessor :bucket

    def initialize(bucket:)
      self.bucket = bucket
    end

    def call
      puts "Downloading master ips from bucket #{self.bucket}"

      master_ips = []

      storage = Fog::Storage.new provider: 'AWS', use_iam_profile: true
      bucket = storage.directories.get(self.bucket)
      bucket.files.each do |file|
        master_ips << file.key
      end

      OpenStruct.new(
        master_ips: master_ips
      )
    end

  end
end
