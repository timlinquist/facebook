require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end

  describe "retrieving posts" do
    before do
      @posts = facebook_api.posts
      @graph.stub(:get_connections => @posts)
    end

    describe 'A user\'s posts' do
      it 'can be retrieved via the graph api' do
        @graph.should_receive(:get_connections) do |uid, connection, query_params|
          uid.should == @uid
          connection.should == 'feed'
          @posts
        end

        @user.posts.should have(2).entries
      end

      it "uses the query params passed in when retrieving" do
        @graph.should_receive(:get_connections) do |uid, connection, query_params|
          uid.should == @uid
          connection.should == 'feed'
          query_params[:limit].should == 50
        end

        @user.posts({:limit => 50})
      end

      it 'are memoized after the first call' do
        @graph.should_receive(:get_connections).exactly(1).times.and_return(@posts)

        user = User.new(@graph, @uid)
        user.posts.should == user.posts
      end
    end
  end

  describe 'retrieving friends' do
    before do
      @friends = [
        {
          "name" => "Joe Montana",
          "id" => "6092929747",
        },
        {
          "name" => "Joe DiMaggio",
          "id" => "7585969235",
        }
      ]
      @graph.stub(:get_connections => @friends)
    end

    describe 'A user\'s friends' do
      it 'can be retrieved via the graph api' do
        @graph.should_receive(:get_connections).with(@uid, 'friends').and_return(@friends)
        @user.friends.should have(2).entries
      end

      it 'are memoized after the first call' do
        @graph.should_receive(:get_connections).exactly(1).times.and_return(@friends)

        user = User.new(@graph, @uid)
        user.friends.should == user.friends
      end
    end
  end
end
