require 'spec_helper'

describe ProjectsController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates CRUD' do
      expect(get: '/projects').to route_to(controller: 'projects', action: 'index')
      expect(get: '/projects/1').to route_to(controller: 'projects', action: 'show', id: '1')
      expect(get: '/projects/new').to route_to(controller: 'projects', action: 'new')
      expect(get: '/projects/1/edit').to route_to(controller: 'projects', action: 'edit', id: '1')
      expect(put: '/projects/1').to route_to(controller: 'projects', action: 'update', id: '1')
      expect(post: '/projects').to route_to(controller: 'projects', action: 'create')
      expect(delete: '/projects/1').to route_to(controller: 'projects', action: 'destroy', id: '1')
    end
  end
end
