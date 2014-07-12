require 'spec_helper'

describe HomeController, type: :controller do
  describe "GET 'index'" do
    it 'should be successful' do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
      expect(response.content_type).to eq('text/html')
    end
  end

  describe "GET 'rss'" do
    it 'should be successful' do
      get :rss, format: :rss
      expect(response).to be_success
      expect(response).to render_template('home/rss')
      expect(response.content_type).to eq('application/rss+xml')
    end
  end
end
