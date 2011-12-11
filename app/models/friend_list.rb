class FriendList
  include Enumerable

  attr_accessor :friends

  def initialize(friends={})
    @friends = friends
  end

  def each &block
    @friends.each{|friend| yield(friend) }
  end

  def alphabetized
    @friends.sort{|friend1, friend2| friend1['name'] <=> friend2['name'] }
  end

end
