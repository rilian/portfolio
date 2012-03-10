def authenticate_user
  @user = Factory(:user)
  @user.stub!(:sign_in_count).and_return(0)
  @user.stub!(:sign_in_count=)
  @user.stub!(:disabled?).and_return(false)
  @user.stub!(:authentication_token).and_return('123qwe')
  #sign_in(@user)
end