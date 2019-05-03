require "pry"

class ApplicationController < ActionController::Base
  def current_merchant
   return Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to github_login_path
    end
  end

  def merchant_authorization
    if current_merchant && (current_merchant.id != params[:id].to_i)
      flash[:status] = :error
      flash[:message] = "You ain't got permission to look at other's business"
      return redirect_to merchant_path(current_merchant)
    end
  end
end
