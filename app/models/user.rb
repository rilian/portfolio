class User < ActiveRecord::Base
  # disable registrations on PROD
  devise :database_authenticatable, :recoverable, :rememberable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates_presence_of :password, :password_confirmation
  validates_length_of :password, :minimum => 6

  validates :email, :presence   => true,
                    :format     => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    :uniqueness => { :case_sensitive => false }

  validate :passwords_match

private
  def passwords_match
    if self.password != self.password_confirmation
      self.errors.add(:base, 'password confirmation should match password') and return false
    end
    true
  end
end
