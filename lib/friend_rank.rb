class FriendRank
  attr_reader :posts

  def initialize(posts=[])
    @posts = posts
  end

  def rank
    commenters = comments.collect{|comment| comment['from'] }
    ranked = {}

    commenters.each do |commenter|
      previously_seen = ranked.fetch(commenter['id'], {})

      if previously_seen.empty?
        previously_seen['count'] = 1
        previously_seen['name'] = commenter['name']
      else
        previously_seen['count'] += 1
      end

      ranked[commenter['id']] = previously_seen
    end

    ranked.sort{|rank1, rank2| rank2.last['count'] <=> rank1.last['count'] }
  end

  def comments
    posts.collect{|post|
      post.fetch('comments', {}).fetch('data', {})
    }.flatten.reject{|comment| comment.nil? || comment.empty? }
  end

end
