module Config
  module ApiCreds

    class << self

      def dropbox
        config[:dropbox]
      end

      def config
        @config ||= YAML.load_file('config/api_creds.yml')
      end

    end

  end
end
