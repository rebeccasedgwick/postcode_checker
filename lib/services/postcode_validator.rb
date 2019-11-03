# frozen_string_literal: true

class PostcodeValidator
  POSTCODE_WHITELIST = %w[sh241aa sh241ab].freeze
  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode.gsub(' ', '').downcase
  end

  def valid?
    POSTCODE_WHITELIST.include?(@postcode)
  end
end
