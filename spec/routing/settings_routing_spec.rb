require 'spec_helper'

describe SettingsController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates CRUD' do
      expect(get: '/settings').to route_to(controller: 'settings', action: 'index')
      expect(get: '/settings/1').to route_to(controller: 'settings', action: 'show', id: '1')
      expect(get: '/settings/new').to route_to(controller: 'settings', action: 'new')
      expect(get: '/settings/1/edit').to route_to(controller: 'settings', action: 'edit', id: '1')
      expect(put: '/settings/1').to route_to(controller: 'settings', action: 'update', id: '1')
      expect(post: '/settings').to route_to(controller: 'settings', action: 'create')
      expect(delete: '/settings/1').to route_to(controller: 'settings', action: 'destroy', id: '1')
    end
  end
end
