module FacebookAuth

  module Filters
    def self.included(base)
      base.class_eval do
        before_filter :facebook_auth
        before_filter :require_login, :except => :login
        helper_method :logged_in?, :current_user
      end
    end
  end

  module Methods
    protected

    def require_login
      unless logged_in?
        redirect_to :controller => :facebook, :action => :login
      end
    end

    def facebook_auth
      @oauth = Koala::Facebook::OAuth.new(Settings.facebook.app_id, Settings.facebook.app_secret)

      if fb_user_info = @oauth.get_user_info_from_cookie(request.cookies)
        @graph = Koala::Facebook::GraphAPI.new(fb_user_info['access_token'])

        @user = User.new(@graph, fb_user_info['user_id'])
      end
    end

    def logged_in?
      !!current_user
    end

    def current_user
      @user
    end

    def graph
      @graph
    end
  end

end
