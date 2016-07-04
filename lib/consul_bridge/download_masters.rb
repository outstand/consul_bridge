require 'metaractor'
require 'fog/aws'
require 'fog/local' if ENV['FOG_LOCAL']

module ConsulBridge
  class DownloadMasters
    include Metaractor

    required :bucket

    def call
      puts "Downloading master ips from bucket #{bucket_name}"

      master_ips = []

      bucket = nil
      if ENV['FOG_LOCAL']
        puts 'Using fog local storage'
        storage = Fog::Storage.new provider: 'Local', local_root: '/fog'
        bucket = storage.directories.create(key: bucket_name)
      else
        storage = Fog::Storage.new provider: 'AWS', use_iam_profile: true
        bucket = storage.directories.get(bucket_name)
      end

      bucket.files.each do |file|
        master_ips << [file.last_modified, file.key]
      end
      master_ips = master_ips.sort.reverse.collect { |file| file[1] }

      context.master_ips = master_ips
    end

    private
    def bucket_name
      context.bucket
    end
  end
end
