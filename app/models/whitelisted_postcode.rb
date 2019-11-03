# frozen_string_literal: true

class WhitelistedPostcode < ApplicationRecord
  before_validation :normalise_postcode
  validates :postcode, presence: true, uniqueness: true

  def normalise_postcode
    self.postcode = postcode.gsub(' ', '').downcase
  end
end
