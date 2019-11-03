# frozen_string_literal: true

class PostcodeCheckerController < ApplicationController
  def validate
    flash[:notice] = if PostcodeValidator.new(params[:postcode]).valid?
                       'Great news, this postcode is in our service area'
                     else
                       "Unfortunately we couldn't find this postcode in our service area"
                     end
    render :index
  end
end
