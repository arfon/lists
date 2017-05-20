class UsersController < ApplicationController
  def show
    @user = User.find_by_sha(params[:id])
    @lists = assign_lists

    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end

  private

  def assign_lists
    # If there's no logged in user or there is a User but they're looking at
    # someone else's profile then just show the visible lists for this User
    if current_user.nil? || current_user != @user
      return List.visible.where(:user => @user).paginate(:page => params[:page])
    elsif current_user == @user # Viewing their own profile
      return List.where(:user => @user).paginate(:page => params[:page])
    end
  end
end
