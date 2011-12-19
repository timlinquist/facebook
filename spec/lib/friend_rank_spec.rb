require 'spec_helper'

describe FriendRank do
  before( :each ) do
    @rank = FriendRank.new facebook_api.posts
  end

  describe "ranking friends from a collection of posts" do
    it "gets all the comments from each post (hashy)" do
      @rank.comments.each{|comment| comment.should respond_to(:has_key?) }
    end

    it "gets all the comments from each post even when there are posts with none" do
      @rank.stub :posts => [{
        'message' => 'We rock',
        'comments' => {
          'data' => { 'from' => { 'name' => 'Joy Namath'} }
          }
      },
      {
        'message' => 'Awesome message'
      }]

      lambda{ @rank.comments }.should_not raise_error
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
