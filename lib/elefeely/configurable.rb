module Elefeely
  module Configurable
    attr_accessor :source_key,
                  :source_secret,
                  :api_host

    def configure(params)
      self.source_key = params[:source_key]
      self.source_secret = params[:source_secret]
      self.api_host = params[:api_host]

      validate_credentials!
    end

  private

    def validate_credentials!
      [source_key, source_secret].each do |credential|
        if credential.nil? || !credential.is_a?(String)
          raise InvalidCredentials
        end
      end
    end

  end
end

class InvalidCredentials < RuntimeError; end
