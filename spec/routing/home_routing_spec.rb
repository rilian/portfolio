require 'spec_helper'

describe HomeController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates actions' do
      expect(get: '/rss').to route_to(controller: 'home', action: 'rss', format: 'rss')
    end
  end
end
