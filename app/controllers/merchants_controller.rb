class MerchantsController < ApplicationController
  # before_action :find_merchant, only: [:edit]
  
  def index
    @merchants = Merchant.all
  end

  def edit 
    if session[:user_id]
      @merchant = Merchant.find_by(id: params[:id])

      unless @merchant
        head :not_found
        return
      end
    else 
      flash[:error] = "You must login to do that"
      redirect_to github_login_path 
    # flash success message
    # flash error message 
    end 
  end 
  
  def create
    auth_hash = request.env["omniauth.auth"]

    user = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:success] = "Logged in as returning user #{user.name}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      user = Merchant.build_from_github(auth_hash)

      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    return redirect_to root_path
  end

  private 
  def merchant_params
    return params.require(:merchant).permit(:name, :email, product_ids: [])
  end

  def find_merchant
    # @merchant = Merchant.find_by(id: params[:id])

    # unless @merchant
    #   head :not_found
    #   return
    # end
  end
end
