# frozen_string_literal: true

require 'net/http'

class PostcodeValidator
  POSTCODES_IO_BASE_URL = 'https://api.postcodes.io'
  LSOA_WHITELIST = %w[Southwark Lambeth].freeze

  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode.gsub(' ', '').downcase
  end

  def valid?
    return true if whitelisted_postcode?

    json_res = fetch_postcode_details
    return false if json_res.nil?

    lsoa = json_res['result']['lsoa']
    whitelisted_lsoa?(lsoa)
  end

  def whitelisted_postcode?
    WhitelistedPostcode.where(postcode: @postcode).exists?
  end

  def fetch_postcode_details
    Rails.logger.info('Querying API')
    uri = URI(POSTCODES_IO_BASE_URL)
    uri.path = "/postcodes/#{@postcode}"
    response = Net::HTTP.get_response(uri)
    return unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def whitelisted_lsoa?(lsoa)
    return false if lsoa.nil?

    LSOA_WHITELIST.any? { |whitelisted_lsoa| lsoa.include?(whitelisted_lsoa) }
  end
end
