class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def friends
    @friends ||= FriendList.new(graph.get_connections(uid, 'friends'))
  end

  def posts(query_params = {})
    query_params.reverse_merge!({:limit => 100})
    @posts ||= graph.get_connections(uid, 'feed', query_params)
  end
end
