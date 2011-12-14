class FriendsController < ApplicationController
  include FacebookAuth::Filters
  include FacebookAuth::Methods

  def create
    @friend = User.new(graph, params[:friend][:id])

    begin
      @posts = @friend.posts
    rescue Koala::Facebook::APIError => e
      flash[:error] = <<-FLASH
        Unable to retrieve friend's posts.
        Please notify support (error: #{e.message})
      FLASH

      redirect_to('/facebook/index') and return
    end

    render :action => :show
  end

  def show; end

end
