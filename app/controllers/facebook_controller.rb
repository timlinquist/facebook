class FacebookController < ApplicationController
  include FacebookAuth::Filters
  include FacebookAuth::Methods

  def index
    @friends = current_user.friends
  end

  def login
  end

end
