require 'spec_helper'

describe HomeController, type: :controller do
  describe "GET 'index'" do
    it 'should be successful' do
      get :index
      response.should be_success
      response.should render_template(:index)
      response.content_type.should eq('text/html')
    end
  end

  describe "GET 'rss'" do
    it 'should be successful' do
      get :rss, format: :rss
      response.should be_success
      response.should render_template('home/rss')
      response.content_type.should eq('application/rss+xml')
    end
  end
end
