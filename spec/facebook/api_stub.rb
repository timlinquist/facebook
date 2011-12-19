require 'singleton'

module API
  module Stubs

    # A super simple disconnected fixture implementation.
    # Assumes fixtures are in spec/facebook/fixtures/filename.yml (one level deep.)
    # Also assumes collection or object matches filename (see example below.)
    #
    # Purpose:
    #   Provide api responses via YAML files for use in testing similar to
    #   http mocking tools without the http part.
    #
    # Ex:
    #   describe Friend
    #     it "has many posts" do
    #       @friend.stub :posts => facebook_api.posts
    #       ...
    #     end
    #
    #     it "has a post" do
    #       @friend.stub :post => facebook_api.posts.first
    #       @friend.stub :post => facebook_api.post
    #       ...
    #     end
    #   end

    class Facebook
      include Singleton

      def fixtures
        @fixtures ||= {}.with_indifferent_access
      end

      def fixture_dir
        Dir.new(File.join(Rails.root,'spec/facebook/fixtures'))
      end

      def fixture_file(name)
        File.join fixture_dir.path, name
      end

      def reload!
        @fixtures = nil
        fixtures
      end

      def method_missing(method, *args, &block)
        return fixtures[method] if fixtures.has_key? method

        fixture = fixture_dir.entries.detect{|fixture| fixture =~ /^#{method}\./ }
        if fixture
          fixtures[method] = YAML::load File.new(fixture_file(fixture))
          return fixtures[method]
        end

        super(method, *args, &block)
      end
    end

  end
end

