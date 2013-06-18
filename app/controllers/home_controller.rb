class HomeController < ApplicationController
  # If the user is signed in, we'd like to greet
  # them on the Home page
  def index
    @user = current_user
  end
end
