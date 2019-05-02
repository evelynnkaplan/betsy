require "pry"

require 'pry'

class MerchantsController < ApplicationController
  # before_action :find_merchant, only: [:edit]

  def index
    @merchants = Merchant.all
  end

  def show 
    find_merchant
  end 

  def edit
    require_login
    merchant_authorization
    
    # binding.pry 
    find_merchant 
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # merchant was found in the database
      flash[:status] = :success
      flash[:message] = "Logged in as returning merchant #{merchant.name}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:status] = :success
        flash[:message] = "Logged in as new merchant #{merchant.name}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def update
    find_merchant 
    require_login
    merchant_authorization

    # binding.pry

    if @merchant.update(merchant_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated merchant #{@merchant.id}"
      redirect_to merchant_path(@merchant)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save merchant #{@merchant.id}"
      render :edit, status: :bad_request
    end
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:name, :email, product_ids: [])
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])

    unless @merchant
      head :not_found
      return
    end
  end
end
