require 'spec_helper'

describe PhotosController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates CRUD' do
      expect(delete: '/photos/1').to route_to(controller: 'photos', action: 'destroy', id: '1')
    end
  end
end
