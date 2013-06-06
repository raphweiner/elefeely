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
    request(:post, phone_number_uri(phone_number), body: {verified: true})
  end

  def self.unsubscribe_number(phone_number)
    request(:post, phone_number_uri(phone_number), body: {verified: false})
  end

private

  def self.api_directory
    request(:get, api_host)
  end

  def self.phone_numbers_uri
    signed_url(api_directory['phones_url'])
  end

  def self.feelings_uri
    signed_url(api_directory['feelings_url'])
  end

  def self.phone_number_uri(phone_number)
    signed_url(api_directory['phone_url'].gsub('{number}', phone_number))
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

  def self.signed_url(url)
    signed_url = url
    signed_url << "?source_key=#{source_key}&timestamp=#{Time.now.to_i}"
    signed_url << "&signature=#{signature(signed_url)}"
  end

  def self.signature(url)
    validate_credentials!

    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha512'), source_secret, url)
  end
end
