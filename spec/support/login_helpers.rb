module LoginHelpers
  # Override Devise's sign_in to track current user
  def sign_in(resource, scope: nil)
    super
    @current_user = resource
  end

  # Override Devise's sign_out to clear current user
  def sign_out(resource_or_scope)
    super
    @current_user = nil
  end

  # Form-based login helper
  def gisia_sign_in(user, password: nil, visit: true)
    visit new_user_session_path if visit
    fill_in 'user[username]', with: user.username
    fill_in 'user[password]', with: (password || user.password)
    click_button 'Log in'
  end

  # Logout helper
  def gisia_sign_out(user = @current_user)
    if @current_user
      visit root_path
      click_link 'Sign out' if has_link?('Sign out')
      @current_user = nil
    end
  end

  # Alias method for compatibility
  alias_method :login_as, :gisia_sign_in
end
