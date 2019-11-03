# frozen_string_literal: true

class PostcodeCheckerController < ApplicationController
  def index
  end

  def validate
    if PostcodeValidator.new(params[:postcode]).valid?
      flash[:notice] = 'Great news, this postcode is in our service area'
    else
      flash[:notice] = "Unfortunately we couldn't find this postcode in our service area"
    end
    render :index
  end
end
