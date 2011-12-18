module API
  module Stubs

    module Helpers
      def facebook_api
        API::Stubs::Facebook.instance
      end
    end

  end
end
