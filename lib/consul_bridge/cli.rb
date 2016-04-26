require 'thor'

module ConsulBridge
  class CLI < Thor
    desc 'version', 'Print out the version string'
    def version
      require 'consul_bridge/version'
      say ConsulBridge::VERSION.to_s
    end

    desc 'start', 'Start the bridge'
    option :bucket, aliases: '-b', required: true, type: :string, banner: '<s3_bucket>'
    option :container_name, aliases: '-n', required: true, type: :string, banner: '<container_name>'
    option :join_all, aliases: '-a', type: :boolean, default: false
    option :verbose, aliases: '-v', type: :boolean, default: false
    def start
      $stdout.sync = true
      require 'consul_bridge/run_bridge'
      RunBridge.call(
        bucket: options[:bucket],
        container_name: options[:container_name],
        join_all: options[:join_all],
        verbose: options[:verbose]
      )
    end
  end
end
