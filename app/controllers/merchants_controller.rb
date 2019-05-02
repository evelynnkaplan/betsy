class MerchantsController < ApplicationController
  # before_action :find_merchant, only: [:edit]

  def index
    @merchants = Merchant.all
  end

  def edit
    # determines whether merchant is loggied in
    if session[:merchant_id]

      # tries to find merchant
      if params[:id].to_i != session[:merchant_id]
        flash[:status] = :error
        flash[:message] = "You ain't got permission to look at other's business"
        redirect_to root_path
        return
      else
        find_merchant
      end
    else
      flash[:status] = :error
      flash[:message] = "You must login to do that"
      redirect_to github_login_path
      # flash success message
      # flash error message
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:status] = :success
      flash[:message] = "Logged in as returning merchant #{merchant.name}"
    else
      merchant = Merchant.build_from_github(auth_hash)
      success = merchant.save

      if success
        flash[:status] = :success
        flash[:message] = "Logged in as new merchant #{merchant.name}"
      else
        flash[:status] = :error
        flash[:message] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to github_login_path
      end
    end

    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def update
    if session[:merchant_id]

      # tries to find merchant
      if params[:id].to_i != session[:merchant_id]
        flash[:status] = :error
        flash[:message] = "You ain't got permission to look at other's business"
        redirect_to root_path
        return
      else
        find_merchant
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
    end
  end

  def destroy
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:message] = "Successfully logged out!"

    redirect_to root_path
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
