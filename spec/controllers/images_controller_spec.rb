require 'spec_helper'

describe ImagesController do
  it 'should use ImagesController' do
    controller.should be_an_instance_of(ImagesController)
  end

  describe 'unauthorized request' do
    context 'inaccessible pages' do
      context 'album' do
        after do
          response.should redirect_to root_path
          response.status.should eq(302)
        end

        it 'should redirect to homepage' do
          get :index
        end
        it 'should redirect to homepage' do
          @image = FactoryGirl.create(:image, published_at: false)
          get :show, id: @image.id
        end
        it 'should redirect to homepage' do
          get :new
        end
        it 'should redirect to homepage' do
          post :create
        end
      end

      context 'member' do
        before do
          @image = FactoryGirl.create(:image)
        end

        after do
          response.should redirect_to root_path
          response.status.should eq(302)
        end

        it 'should redirect to homepage' do
          get :edit, id: @image.id
        end
        it 'should redirect to homepage' do
          put :update, id: @image.id
        end
        it 'should redirect to homepage' do
          delete :destroy, id: @image.id
        end
      end
    end

    context 'accessible pages' do
      before do
        @image = FactoryGirl.create(:image, published_at: Time.now)
        get :show, id: @image.id
      end

      it 'should be successful' do
        response.should be_success
        response.should render_template(:show)
        assigns[:image].should == @image
      end
    end
  end

  context 'authorized request' do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'show'" do
      before do
        @image = FactoryGirl.create(:image, published_at: false)
        get :show, id: @image.id
      end

      it 'should be successful' do
        response.should be_success
        response.should render_template(:show)
        assigns[:image].should == @image
      end
    end

    describe "GET 'new'" do
      before do
        get :new
      end

      it 'should be successful' do
        response.should be_success
        response.should render_template(:new)
      end
    end

    describe "POST 'create'" do
      before do
        @album = FactoryGirl.create(:album)
        @file = fixture_file_upload('/file.jpg', 'image/jpg')

        post :create, image: {
          album_id: @album.id,
          asset: @file,
          title: 'aa AA aA Aa',
          desc: 'bb BB bB Bb',
          place: 'cc CC Cc cC',
          published_at_checkbox: '0'
        }
      end

      it 'should be successful' do
        response.status.should eq(302)
        image = Image.last
        image.present?.should be_true
        image.title.should eq('aa AA aA Aa')
        image.desc.should eq('bb BB bB Bb')
        image.place.should eq('cc CC Cc cC')
        image.album_id.should eq(@album.id)
        image.published_at.should == nil
      end
    end

    describe "GET 'edit'" do
      before do
        @image = FactoryGirl.create(:image)
        get :edit, id: @image.id
      end

      it 'should be successful' do
        response.should be_success
        response.should render_template(:edit)
      end
    end

    describe "PUT 'update'" do
      before do
        @image = FactoryGirl.create(:image)
        put :update, id: @image.id, image: {title: 'BB bb Bb bB!'}
      end

      it 'should be successful' do
        response.status.should eq(302)
        @image.reload
        @image.title.should eq('BB bb Bb bB!')
      end
    end

    describe "DELETE 'destroy'" do
      before do
        @image = FactoryGirl.create(:image)
        delete :destroy, id: @image.id
      end

      it 'should be successful' do
        response.status.should eq(302)
        Image.find_by_id(@image.id).nil?.should be_true
      end
    end

  end
end

