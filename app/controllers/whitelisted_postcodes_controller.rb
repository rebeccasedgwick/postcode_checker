# frozen_string_literal: true

class WhitelistedPostcodesController < ApplicationController
  before_action :find_whitelisted_postcode, only: [:edit, :update, :destroy]

  def index
    @whitelisted_postcodes = WhitelistedPostcode.all.order(:postcode)
  end

  def new
  end

  def create
    @whitelisted_postcode = WhitelistedPostcode.new(whitelisted_postcode_params)
    if @whitelisted_postcode.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @whitelisted_postcode.update(whitelisted_postcode_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @whitelisted_postcode.destroy
    redirect_to whitelisted_postcodes_path
  end

  private
  def whitelisted_postcode_params
    params.require(:whitelisted_postcode).permit(:postcode)
  end

  def find_whitelisted_postcode
    @whitelisted_postcode = WhitelistedPostcode.find(params[:id])
  end
end
