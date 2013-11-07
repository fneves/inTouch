class IntouchController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
    respond_to do |format|
      format.html  # index.html.haml
      format.json  { render :json => @users }
    end
  end

end
