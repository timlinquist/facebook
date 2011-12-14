module FacebookHelper
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :scope => 'user_likes, friends_likes',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end
end
