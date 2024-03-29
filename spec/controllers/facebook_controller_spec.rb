require 'spec_helper'

describe FacebookController do
  describe "Handling expired/invalid facebook sessions" do
    before( :each ) do
      @user = User.new(mock('graph'), 42)
      @oauth = mock('oauth')
      @graph = mock('graph')
    end

    it "reraises when the error is not due to a stale session" do
      Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
      exception = Koala::Facebook::APIError.new('message' => 'Not a stale session')
      @oauth.should_receive(:get_user_info_from_cookie).and_raise(exception)

      lambda { get :login }.should raise_error(Koala::Facebook::APIError)
    end

    it "notifies the user of what happened" do
      Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
      exception = Koala::Facebook::APIError.new('message' => 'OAuthException: Code or session expired.')
      @oauth.should_receive(:get_user_info_from_cookie).and_raise(exception)
      get :login

      @controller.flash[:error].should_not be_blank
    end
  end

  describe 'index with GET' do
    before do
      @user = User.new(mock('graph'), 42)
      @oauth = mock('oauth')
      @graph = mock('graph')
      Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
    end

    context 'when logged into facebook' do
      before do
        user_info = {'access_token' => '1234567890', 'user_id' => 42}
        @oauth.should_receive(:get_user_info_from_cookie).and_return(user_info)
        Koala::Facebook::GraphAPI.should_receive(:new).with('1234567890').and_return(@graph)
        User.should_receive(:new).and_return(@user)
        @alphabetized_friends = mock('friends')
        @friends = mock('friends', :alphabetized => @alphabetized_friends)
        @user.should_receive(:friends).and_return(@friends)

        get :index
      end

      it do
        response.should be_success
      end

      it 'should assign friends in alphabetical order' do
        assigns[:friends].should == @alphabetized_friends
      end
    end

    context 'when not logged into facebook' do
      before do
        @oauth.should_receive(:get_user_info_from_cookie).and_return(nil)

        get :index
      end

      it 'should redirect to the login page' do
        response.should redirect_to(:action => :login)
      end
    end
  end

  describe 'login with GET' do
    before do
      get :login
    end

    it do
      response.should be_success
    end
  end
end
