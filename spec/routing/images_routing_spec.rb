require 'spec_helper'

describe ImagesController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates CRUD' do
      expect(get: '/images').to route_to(controller: 'images', action: 'index')
      expect(get: '/images/1').to route_to(controller: 'images', action: 'show', id: '1')
      expect(get: '/images/new').to route_to(controller: 'images', action: 'new')
      expect(get: '/images/1/edit').to route_to(controller: 'images', action: 'edit', id: '1')
      expect(put: '/images/1').to route_to(controller: 'images', action: 'update', id: '1')
      expect(post: '/images').to route_to(controller: 'images', action: 'create')
      expect(delete: '/images/1').to route_to(controller: 'images', action: 'destroy', id: '1')
    end
  end
end
