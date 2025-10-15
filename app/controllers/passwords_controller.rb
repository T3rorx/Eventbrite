class PasswordsController < ApplicationController
  before_action :authenticate_user!
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update_with_password(password_params)
      bypass_sign_in(@user)
      redirect_to user_path(@user), notice: 'Votre mot de passe a été modifié avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
