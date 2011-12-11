require 'spec_helper'

describe FriendList do
  before( :each ) do
    @friends = [
      {'id' => '123', 'name' => 'Troy Aikman'},
      {'id' => '231', 'name' => 'Barry Bonds'},
      {'id' => '321', 'name' => 'Fran Tarkenton'}
    ]

    @friend_list = FriendList.new(@friends)
  end

  it "initializes with an array of friends" do
    @friend_list.friends.should == @friends
  end

  it "return the friends sorted by their names" do
    @friend_list.alphabetized.should == [
      {'id' => '231', 'name' => 'Barry Bonds'},
      {'id' => '321', 'name' => 'Fran Tarkenton'},
      {'id' => '123', 'name' => 'Troy Aikman'}
    ]
  end
end
