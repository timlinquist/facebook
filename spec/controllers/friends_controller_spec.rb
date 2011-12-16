require 'spec_helper'

describe FriendsController do
  #TODO : Move facebook auth to shared example; mixin here and in facebook controller spec
  before( :each ) do
    login_to_facebook
    @friend = {:id => '123', :name => 'Lebron James'}
    User.stub :new => @friend
    @friend.stub :posts => []
  end

  describe "A friend's posts are successfully retrieved" do
    it 'renders the show action' do
      @friend.should_receive(:posts).and_return(@posts)
      post :create, {:friend => {:id => '123'}}

      response.should be_success
    end

    it "assigns the posts" do
      @friend.should_receive(:posts).and_return(@posts)
      post :create, {:friend => {:id => '123'}}

      assigns(:posts).should == @posts
    end

    describe "Ranking friends from a collection of posts" do
      it "assigns the friends in ranking order" do
        friend_rank = mock('FriendRank')
        FriendRank.should_receive(:new).with(@friend.posts).and_return(friend_rank)
        ranked_friends = {
          'name' => 'Tim',
          'id' => '321',
          'count' => '5'
        }
        friend_rank.should_receive(:rank).and_return(ranked_friends)

        post :create, {:friend => {:id => '123'}}
        assigns(:ranked_friends).should == ranked_friends
      end
    end
  end

  describe "A friend's posts are not successfully retrieved" do
    it "redirects to facebook#index to reselect a friend" do
      @friend.should_receive(:posts).and_raise(Koala::Facebook::APIError.new)
      post :create, {:friend => {:id => '123'}}

      response.should redirect_to('/facebook/index')
    end

    it "sets the flash message accordingly" do
      error = Koala::Facebook::APIError.new "Invalid token"
      @friend.should_receive(:posts).and_raise(error)
      post :create, {:friend => {:id => '123'}}

      controller.flash[:error].should =~ /\(error:\s#{error.message}\)$/
    end
  end
end
