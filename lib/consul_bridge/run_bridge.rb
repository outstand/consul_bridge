require 'consul_bridge/base'

module ConsulBridge
  class RunBridge < Base
    attr_accessor :bucket

    def initialize(bucket:)
      self.bucket = bucket
    end

    def call
      puts 'run bridge'
    end
  end
end
