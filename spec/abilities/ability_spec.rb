require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'User' do
    before do
      @user = FactoryGirl.create(:user)
      @ability = Ability.new(@user)
    end
    it 'should have user abilities' do
      @ability.should be_able_to(:manage, :all)
    end
  end

  context 'Guest' do
    before do
      @ability = Ability.new(nil)
    end
    it 'should not have user abilities' do
      @ability.should_not be_able_to(:manage, :all)

      @ability.should be_able_to(:read, Album.new)
      @ability.should be_able_to(:read, Project.new)
    end
  end
end
