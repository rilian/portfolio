require 'spec_helper'

describe PostsController do
  it "should use PostsController" do
    controller.should be_an_instance_of(PostsController)
  end

  describe "anonymous user" do
    it "should redirect to the login page" do
      #
    end
  end

  describe "authenticated user" do
    before(:each) do
      authenticate_user
    end

    context "post" do
      let(:post) { mock_model(Post)}

      describe "GET index" do
        before do
          Post.should_receive(:includes).and_return(post)
          post.should_receive(:search).and_return(post)
          post.should_receive(:result).and_return(post)
          post.should_receive(:page).and_return(post)
          get :index
        end
        it { response.should be_success }
        it { response.should render_template("index") }
        it { assigns[:posts].should == post }
      end

      describe "GET index with search" do
        before do
          @post_1 = Factory(:post, :title => '12')
          @post_2 = Factory(:post, :title => '23')
        end

        after :each do
          response.should be_success
          response.should render_template("index")
        end

        context "by all params at once" do
          it "should find 1 posts" do
            get :index, :q => {:title_or_body_or_category_title_cont => '1'}
            assigns[:posts].should =~ [@post_1]
          end

          it "should find 2 posts" do
            get :index, :q => {:title_or_body_or_category_title_cont => '2'}
            assigns[:posts].should =~ [@post_1, @post_2]
          end
        end
      end

      describe "GET show" do
        before do
          Post.stub!(:find) { post }
          get :show, :id => 0
        end
        it { response.should be_success }
        it { response.should render_template("show") }
        it { assigns[:post].should == post }
      end

      describe "GET new" do
        before do
          get :new
        end
        it { response.should be_success }
        it { response.should render_template("new") }
        it { assigns[:post].should be_a_new(Post) }
      end

      describe "GET edit" do
        before do
          Post.stub!(:find) { post }
          get :edit, :id => 1
        end
        it { response.should be_success }
        it { response.should render_template("edit") }
        it { assigns[:post].should == post }
      end

      describe "PUT update" do
        before do
          Post.stub!(:find) { post }
        end

        it "success" do
          post.stub!(:update_attributes) { true }
          put :update, :id => 1, :post => {}
          response.should redirect_to post_path(post)
        end

        it "failure" do
          post.stub!(:update_attributes) { false }
          put :update, :id => 1, :post => {}
          response.should render_template("edit")
        end
      end

      describe "DELETE destroy" do
        before do
          Post.stub!(:find) { post }
        end

        it "success" do
          post.stub!(:delete) { true }
          delete :destroy, :id => 0
          response.status.should == 302
        end
      end
    end

    context "post_obj due to POST method" do
      let(:post_obj) { mock_model(Post)}

      describe "POST create" do
        before do
          Post.stub!(:new) { post_obj }
        end

        it "success" do
          post_obj.stub!(:save) { true }
          post :create, :post => {}
          response.should redirect_to post_path(post_obj)
        end

        it "failure" do
          post_obj.should_receive(:save).and_return(false)
          post_obj.stub!(:valid?) { false }
          post :create, :post => {}
          response.should render_template("new")
        end
      end
    end
  end
end
