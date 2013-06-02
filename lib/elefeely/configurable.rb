module Elefeely
  module Configurable
    attr_accessor :source_key,
                  :source_secret

    def configure(params)
      self.source_key = params[:source_key]
      self.source_secret = params[:source_secret]

      validate_credentials!
    end

  private

    def validate_credentials!
      [source_key, source_secret].each do |credential|
        if credential.nil? || !credential.is_a?(String)
          raise ArgumentError, "Invalid: must have a valid key and secret."
        end
      end
    end
  end
end
