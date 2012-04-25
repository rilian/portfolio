class User < ActiveRecord::Base
  # disable registrations on PROD
  devise :database_authenticatable, :recoverable, :rememberable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
end
