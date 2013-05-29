require 'elefeely/configurable'

require 'json'
require 'typhoeus'
require 'openssl'


module Elefeely
  extend Elefeely::Configurable

  def self.phone_numbers
    validate_credentials!

    response = ::Typhoeus::Request.get(uri('/phones'))
    parse_response(response)
  end

  def self.send_feeling(params)
    validate_credentials!

    response = ::Typhoeus::Request.post(uri('/feelings'), body: params.to_json)
    parse_response(response)
  end

private

  def self.parse_response(response)
    if response.code == 200
      JSON.parse(response.body)
    elsif response.code == 404
      nil
    else
      raise response.body
    end
  end

  def self.uri(path)
    uri = "http://elefeely-api.herokuapp.com"
    uri << "#{path}?source_key=#{source_key}&timestamp=#{Time.now.to_i}"
    uri << "&signature=#{signature(uri)}"
  end

  def self.signature(uri)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), source_secret, uri)
  end
end
