require 'singleton'

module API
  module Stubs

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

        fixture = fixture_dir.entries.detect{|fixture| fixture =~ /^#{method.to_s}\./ }
        if fixture
          fixtures[fixture] = YAML::load File.new(fixture_file(fixture))
          return fixtures[fixture]
        end

        super(method, *args, &block)
      end
    end

  end
end

