module UserHelper
  def system_log_in(user)
    visit login_path

    within('form') do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_on 'Log In'
    end
  end

  def log_in(user)
    post_params = {
      params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
    }

    post login_path, post_params
  end
end
