require 'spec_helper'

describe FriendRank do
  before( :each ) do
    @rank = FriendRank.new facebook_api.posts
  end

  describe "ranking friends from a collection of posts" do
    it "gets all the comments from each post (hashy)" do
      @rank.comments.each{|comment| comment.should respond_to(:has_key?) }
    end

    it "returns a set of friends sorted by their # of comments" do
      ranked_friends = @rank.rank
      ranked_friends.should == [
        [1585128, { 'count' => 2, 'name' => 'Lance Armstrong' }],
        [100313, { 'count' => 1, 'name' => 'Alex Rodriguez' }]
      ]
    end
  end
end
