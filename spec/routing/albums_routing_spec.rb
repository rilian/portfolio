require 'spec_helper'

describe AlbumsController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates CRUD' do
      expect(get: '/albums').to route_to(controller: 'albums', action: 'index')
      expect(get: '/albums/1').to route_to(controller: 'albums', action: 'show', id: '1')
      expect(get: '/albums/new').to route_to(controller: 'albums', action: 'new')
      expect(get: '/albums/1/edit').to route_to(controller: 'albums', action: 'edit', id: '1')
      expect(put: '/albums/1').to route_to(controller: 'albums', action: 'update', id: '1')
      expect(post: '/albums').to route_to(controller: 'albums', action: 'create')
      expect(delete: '/albums/1').to route_to(controller: 'albums', action: 'destroy', id: '1')
    end
  end
end
