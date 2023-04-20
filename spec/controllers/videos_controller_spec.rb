require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  let(:user) { create(:user) }
  let(:video) { create :video }
  let(:videos) { create_list :video, 3 }
  
  describe 'GET #index' do
    before do
      videos
      get	:index
    end

    it "responds successfully" do
      is_expected.to respond_with(:success)
      is_expected.to render_template(:index)

      # order by id desc
      expect(assigns[:videos].first).to eq videos.last
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      before do
        get :new
      end

      it 'redirect to sign in path' do
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(new_user_session_path)
      end

      it 'set unauthenticated flash' do
        is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'when user is authenticated' do
      before do
        sign_in user
        get :new
      end

      it 'redirect to new video page' do
        is_expected.to respond_with(:success)
        is_expected.to render_template(:new)
      end
    end
  end
  
  describe 'POST #create' do
    context 'call create Video Service Successfully' do
      let(:video) { create(:video, user: user) }
      before do
        sign_in user
        allow_any_instance_of(VideoService::CreateVideo).to receive(:perform).and_return(video)
      end

      it 'redirect to root path with sucess message flash' do
        post :create, params: { video: { youtube_url: video.youtube_url } }
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(root_path)

        is_expected.to set_flash[:notice].to('Shared movie successfully!')
      end
    end

    context 'youtube url is invalid' do
      let(:video) { create(:video, user: user, youtube_url: 'invalid') }
      before do
        sign_in user
      end

      it 'returns unprocessable_entity status' do
        post :create, params: { video: { youtube_url: video.youtube_url } }
        is_expected.to respond_with(:unprocessable_entity)
        is_expected.to render_template(:new)

        is_expected.to set_flash.now[:alert].to('Youtube Url is invalid')
      end
    end

    context 'youtube url is not found' do
      let(:video) { create(:video, user: user, youtube_url: 'http://www.youtube.com/watch?v=not___found') }
      before do
        sign_in user
      end

      it 'returns unprocessable_entity status' do
        post :create, params: { video: { youtube_url: video.youtube_url } }
        is_expected.to respond_with(:unprocessable_entity)
        is_expected.to render_template(:new)

        is_expected.to set_flash.now[:alert].to('Youtube Video is not found')
      end
    end

    context 'unauthenticated' do
      it 'redirect to login page' do
        post :create, params: { video: { youtube_url: 'http://www.youtube.com/watch?v=Ab25nviakcw' } }
        
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(new_user_session_path)
        is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe 'POST #like' do
    context 'when user is not like/dislike yet' do
      before do
        sign_in user
      end

      it 'create a Like record' do
        expect do
          post :like, params: { id: video.id }
        end.to change { Like.where(is_like: true).count }.by(1)
      end

      it 'update video like counter' do
        expect do 
          post :like, params: { id: video.id }
        end.to change { video.reload.like_count }.from(0).to(1)
      end
    end

    context 'when user is disliked already' do
      let!(:like) { create(:like, user: user, video: video, is_like: false) }
      
      before do
        sign_in user
      end

      it 'update exist like record' do
        post :like, params: { id: video.id }
        expect(like.reload.is_like).to eq(true)
      end

      it 'update video like counter' do
        expect do 
          post :like, params: { id: video.id }
        end.to change { video.reload.like_count }.from(0).to(1)
      end
    end

    context 'when user is liked already' do
      before do
        create(:like, user: user, video: video)
        sign_in user
      end

      it 'does not create a Like record' do
        expect do
          post :like, params: { id: video.id }
        end.to change { Like.where(is_like: true).count }.by(0)
      end

      it 'does not update video like_counter' do
        expect do 
          post :like, params: { id: video.id }
        end.not_to change { video.reload.like_count }
      end
    end

    context 'unauthenticated' do
      it 'redirect to login page' do
        post :like, params: { id: video.id }
        
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(new_user_session_path)
        is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end


  describe 'POST #dislike' do
    context 'when user is not like/dislike yet' do
      before do
        sign_in user
      end

      it 'create a DisLike record' do
        expect do
          post :dislike, params: { id: video.id }
        end.to change { Like.where(is_like: false).count }.by(1)
      end

      it 'update video unlike counter' do
        expect do 
          post :dislike, params: { id: video.id }
        end.to change { video.reload.unlike_count }.from(0).to(1)
      end
    end

    context 'when user is liked already' do
      let!(:like) { create(:like, user: user, video: video) }
      before do
        sign_in user
      end

      it 'update exist like record' do
        post :dislike, params: { id: video.id }
        expect(like.reload.is_like).to eq(false)
      end

      it 'update video unlike counter' do
        expect do 
          post :dislike, params: { id: video.id }
        end.to change { video.reload.unlike_count }.from(0).to(1)
      end
    end

    context 'when user is disliked already' do
      before do
        create(:like, user: user, video: video, is_like: false)
        sign_in user
      end

      it 'does not create a DisLike record' do
        expect do
          post :dislike, params: { id: video.id }
        end.to change { Like.where(is_like: false).count }.by(0)
      end

      it 'does not update video unlike_counter' do
        expect do 
          post :dislike, params: { id: video.id }
        end.not_to change { video.reload.unlike_count }
      end
    end

    context 'unauthenticated' do
      it 'redirect to login page' do
        post :dislike, params: { id: video.id }
        
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(new_user_session_path)
        is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end
end
