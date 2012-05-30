module BigTuna
  class Hooks::Geckoboard < Hooks::Base
    NAME = 'geckoboard'

    def build_fixed(build, config)
      enqueue(config, "77AB13")
    end

    def build_still_fails(build, config)
      enqueue(config, "AE432E")
    end

    def build_failed(build, config)
      enqueue(config, "AE432E")
    end

    class Job
      def initialize(config, color)
        @config = config
        @color = color
      end

      def perform
        if @config['token'] and @config['url']
          payload = {:item => [{:value => 100, :colour => @color, :label => ""}]}
          response = RestClient.post @config['url'], {:api_key => @config['token'], :data => payload}.to_json, :content_type => :json, :accept => :json
        end
      end
    end

  private
    def enqueue(config, color)
      Delayed::Job.enqueue(Job.new(config, color))
    end
  end
end
