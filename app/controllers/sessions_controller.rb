class SessionsController < Clearance::SessionsController
  def create
    user = User.find_by(email: params[:session][:email])

    if user && user.encrypted_password.blank?
      redirect_to edit_user_password_path(user) and return
    end

    super
  end
end
