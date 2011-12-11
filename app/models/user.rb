class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def friends
    @friends ||= graph.get_connections(uid, 'friends')
  end
end
