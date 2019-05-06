require "pry"

class ApplicationController < ActionController::Base
  helper_method :current_order, :current_merchant

  def current_merchant
   @current_merchant = Merchant.find(session[:merchant_id]) if session[:merchant_id]
   return @current_merchant
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_back(fallback_location: root_path)
      return false
    end
    return true 
  end

  def merchant_authorization
    if params[:id] && current_merchant && (current_merchant.id != params[:id].to_i)
      flash[:status] = :error
      flash[:message] = "You ain't got permission to look at other's business"
      redirect_to dashboard_path 
      false 
    end
    return true 
  end

  # helper method for shopping cart functionality
  def current_order
    if session[:order_id]
      Order.find(session[:order_id])
    else
      Order.new
    end
  end
end
