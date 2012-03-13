require 'spec_helper'

describe ImagesController do
  it "should use ImagesController" do
    controller.should be_an_instance_of(ImagesController)
  end

  describe "user" do
    let(:image) { mock_model(Image) }

    describe "DELETE destroy" do
      before :each do
        @post = mock_model(Post)
        Post.stub!(:find).and_return(@post)
        @post.stub(:id).and_return(0)

        Image.stub!(:find) { image }
        image.stub_chain(:post) { @post }
      end

      it "should be success" do
        image.stub!(:delete) { true }
        delete :destroy, :id => 0
        response.should redirect_to post_path(@post)
      end
    end

    describe 'POST cache_uploader' do
      before :each do
        post :cache_uploader, :file => File.new("#{Rails.root}/spec/support/file.jpg")#, :auth_token => @user.authentication_token
      end

      it "should be success" do
        response.should be_success
        hash = ActiveSupport::JSON.decode(response.body)
        hash.is_a?(Hash).should be_true
        hash.keys.should =~ %w(filename name size url thumbnail_url type)
      end
    end
  end
end
