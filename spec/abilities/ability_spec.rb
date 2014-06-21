require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'User' do
    before do
      @user = FactoryGirl.create(:user)
      @ability = Ability.new(@user)
    end
    it 'should have user abilities' do
      expect(@ability.can?(:manage, :all)).to eq true
    end
  end

  context 'Guest' do
    before do
      @ability = Ability.new(nil)
    end

    it 'cannot manage all' do
      @ability.should_not be_able_to(:manage, :all)
    end

    it 'can :read published Album' do
      @ability.should be_able_to(:read, Album.new(is_published: true))
    end

    it 'cannot :read non-published Album' do
      @ability.should_not be_able_to(:read, Album.new(is_published: false))
    end

    it 'can :read published Project' do
      @ability.should be_able_to(:read, Project.new(is_published: true))
    end

    it 'cannot :read non-published Project' do
      @ability.should_not be_able_to(:read, Project.new(is_published: false))
    end
  end
end
