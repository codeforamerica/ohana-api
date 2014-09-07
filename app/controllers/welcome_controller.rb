class WelcomeController < ApplicationController
  def home
    # check if this is the first time the page is visited and generate a token if it is.
    if WelcomeToken.count == 0
      token = WelcomeToken.create
      redirect_to welcome_path(code: token.code)
    else
      token = WelcomeToken.first
      if params[:code].present? and params[:code] == token.code
        # Start configuration
      else
        # Redirect to root path if the token is invalid or if there is no token
        redirect_to root_path
      end
    end
  end
end
