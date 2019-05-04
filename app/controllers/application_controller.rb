require "pry"

class ApplicationController < ActionController::Base
  def current_merchant
    @current_merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_back(fallback_location: root_path)
    end
  end

  def merchant_authorization
    if current_merchant && (current_merchant.id != params[:id].to_i)
      flash[:status] = :error
      flash[:message] = "You ain't got permission to look at other's business"
      redirect_to root_path
    end
  end
end
