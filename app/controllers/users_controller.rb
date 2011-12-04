class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    #TODO: first user must have Admin abilities
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => 'Signed Up!'
    else
      render "new"
    end
  end

end
