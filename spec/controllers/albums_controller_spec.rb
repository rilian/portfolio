require 'spec_helper'

describe AlbumsController, type: :controller do
  describe 'unauthorized request' do
    context 'accessible pages' do
      it 'should be success' do
        @album = FactoryGirl.create(:album, images: [FactoryGirl.create(:image)])
        get :show, id: @album.id
        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
      end
    end

    context 'inaccessible pages' do
      context 'albums' do
        after :each do
          expect(response).to redirect_to root_path
          expect(response.status).to eq(302)
        end

        it 'should redirect to homepage' do
          get :index
        end
        it 'should redirect to homepage' do
          get :new
        end
        it 'should redirect to homepage' do
          post :create, { album: { title: '' } }
        end
      end

      context 'members' do
        before do
          @album = FactoryGirl.create(:album)
        end

        after :each do
          expect(response).to redirect_to root_path
          expect(response.status).to eq(302)
        end

        it 'should redirect to homepage' do
          get :edit, id: @album.id
        end
        it 'should redirect to homepage' do
          put :update, id: @album.id
        end
        it 'should redirect to homepage' do
          delete :destroy, id: @album.id
        end
      end
    end
  end

  context 'authorized request' do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET 'new'" do
      before do
        get :new
      end

      it 'should be successful' do
        expect(response).to be_success
        expect(response).to render_template(:new)
      end
    end

    describe "POST 'create'" do
      before do
        post :create, album: { title: 'aa AA Aa aA', description: 'Bb' }
      end

      it 'should be successful' do
        expect(response.status).to eq 302
        album = Album.last
        expect(album.title).to eq 'aa AA Aa aA'
        expect(album.description).to eq 'Bb'
      end
    end

    describe "GET 'edit'" do
      before do
        @album = FactoryGirl.create(:album)
        get :edit, id: @album.id
      end

      it 'should be successful' do
        expect(response.status).to eq 200
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT 'update'" do
      before do
        @album = FactoryGirl.create(:album)
        put :update, id: @album.id, album: { title: 'BB bb Bb bB!', description: 'Bb' }
      end

      it 'should be successful' do
        expect(response.status).to eq 302
        @album.reload
        expect(@album.title).to eq('BB bb Bb bB!')
        expect(@album.description).to eq('Bb')
      end
    end

    describe "DELETE 'destroy'" do
      before do
        @album = FactoryGirl.create(:album)
        delete :destroy, id: @album.id
      end

      it 'should be successful' do
        expect(response.status).to eq 302
        expect(Album.find_by_id(@album.id)).to eq nil
      end
    end
  end
end
