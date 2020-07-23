module UsersHelper
  def equal_with_current_user?(other_user)
    current_user == other_user
  end
end
