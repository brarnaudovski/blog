class UsersController < Clearance::UsersController
  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params[:user].permit(:email, :password, :name)
  end
end
