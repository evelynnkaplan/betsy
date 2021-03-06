class MerchantsController < ApplicationController
  # before_action :find_merchant, only: [:edit]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = current_merchant

    require_login
    merchant_authorization

    if @merchant
      @products = Product.where(merchant_id: @merchant.id)
    
      if params[:order_filter]
        @orders = @merchant.orders.select { |o| o.status == params[:order_filter] }
      else
        @orders = @merchant.orders
      end
  
      @orders = @orders.sort_by { |order| order.id }
    end
  end

  def edit
    return unless require_login
    return unless merchant_authorization
    return unless find_merchant
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:status] = :success
      flash[:message] = "Logged in as returning merchant #{merchant.name}"
    else
      merchant = Merchant.build_from_github(auth_hash)
      merchant[:name] = merchant.username if !merchant.name

      success = merchant.save

      if success
        flash[:status] = :success
        flash[:message] = "Logged in as new merchant #{merchant.name}"
      else
        flash[:status] = :error
        flash[:message] = "Could not create new merchant account: #{merchant.errors.messages}"
        redirect_to root_path
        return merchant
      end
    end

    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    redirect_to root_path
    return merchant
  end

  def update
    return unless find_merchant
    return unless require_login

    return unless merchant_authorization
    @merchant = find_merchant

    if @merchant.update(merchant_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated merchant #{@merchant.id}"
      return redirect_to merchant_path(@merchant)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save merchant #{@merchant.id}"
      render :edit, status: :bad_request
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
      return false
    end
    return @merchant
  end
end
