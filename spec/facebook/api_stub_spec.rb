require 'spec_helper'

describe API::Stubs::Facebook do
  before( :each ) do
    # Files are not extended via normal config because they don't
    # match the :type metadata set by rspec-rails eg. (:type => some_type)
    # Get singleton manually as a result.
    @facebook_api = API::Stubs::Facebook.instance
  end

  describe "reading the .yml fixture" do
    it "should populate the fixtures hash" do
      @facebook_api.posts.should have_at_least(1).posts
    end
  end
end
