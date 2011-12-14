module FacebookAuthHelpers
  def user(options={})
    options.reverse_merge!(:uid => '123', :graph => graph)
    return mock('User', options)
  end

  def graph(options={})
    return mock('Graph')
  end

  # Sets up necessary 'authenticated' state in example group
  # To use different mocks simply define the current_user,graph
  # methods in the example group where method is called
  #
  # Ex:
  #  describe 'User clicks go'
  #   let(:current_user){ mock('MyUser') }
  #   before(:each){ login_to_facebook }
  #  end
  #
  def login_to_facebook
    @controller.stub :current_user => user
    @controller.stub :graph => graph
  end
end
