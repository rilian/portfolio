require 'spec_helper'

describe AlbumsController do
  describe 'routing' do
    it 'recognizes and generates CRUD' do
      { get: '/albums'}.should route_to(controller: 'albums', action: 'index')
      { get: '/albums/1'}.should route_to(controller: 'albums', action: 'show', id: '1')
      { get: '/albums/new'}.should route_to(controller: 'albums', action: 'new')
      { get: '/albums/1/edit'}.should route_to(controller: 'albums', action: 'edit', id: '1')
      { put: '/albums/1'}.should route_to(controller: 'albums', action: 'update', id: '1')
      { post: '/albums'}.should route_to(controller: 'albums', action: 'create')
      { delete: '/albums/1'}.should route_to(controller: 'albums', action: 'destroy', id: '1')
    end
  end
end
