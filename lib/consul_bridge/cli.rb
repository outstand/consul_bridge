require 'thor'

module ConsulBridge
  class CLI < Thor
    desc 'version', 'Print out the version string'
    def version
      say ConsulBridge::VERSION.to_s
    end

    desc 'start', 'Start the bridge'
    option :bucket, aliases: '-b', required: true, type: :string, banner: '<s3_bucket>'
    def start
      $stdout.sync = true
      require 'consul_bridge/run_bridge'
      RunBridge.call(bucket: options[:bucket])
    end
  end
end
