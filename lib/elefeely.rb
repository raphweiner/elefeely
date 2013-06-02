require 'elefeely/configurable'

require 'json'
require 'typhoeus'
require 'openssl'


module Elefeely
  extend Elefeely::Configurable

  def self.phone_numbers
    request(:get, phone_numbers_uri)
  end

  def self.send_feeling(params)
    request(:post, feelings_uri, body: params)
  end

  def self.verify_number(phone_number)
    request(:put, update_phone_number_uri(phone_number))
  end

private

  def self.phone_numbers_uri
    uri '/phones'
  end

  def self.feelings_uri
    uri '/feelings'
  end

  def self.update_phone_number_uri(phone_number)
    uri "/phones/#{phone_number}"
  end

  def self.request(verb, *params)
    response = connection.send(verb, *params)
    parse_response(response)
  end

  def self.connection
    ::Typhoeus::Request
  end

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
    validate_credentials!

    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha512'), source_secret, uri)
  end
end
