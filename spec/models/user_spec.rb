require 'spec_helper'

describe User do
  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:encrypted_password).of_type(:string) }
  it { should have_db_column(:username).of_type(:string) }

  it { should have_db_index(:email).unique(true) }
  it { should have_db_index(:username).unique(true) }

  describe "generators" do
    before :each do
      @user = Factory(:user)
    end

    it "should be valid" do
      @user.should be_valid
    end
  end
end
