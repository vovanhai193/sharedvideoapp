require 'rails_helper'

RSpec.describe Devise::SessionsController, type: [:controller, :devise_controller] do
  let(:user) { create(:user) }

  describe 'GET #new' do
    context 'when user is already authenticated' do
      before do
        sign_in user
        get :new
      end

      it 'redirect to root path' do
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(root_path)
      end

      it 'set already_authenticated flash' do
        is_expected.to set_flash[:alert].to(I18n.t('devise.failure.already_authenticated'))
      end
    end

    context 'when user is not authenticated' do
      before do
        get :new
      end

      it 'redirect to login page' do
        is_expected.to respond_with(:success)
        is_expected.to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is already authenticated' do
      before do
        sign_in user
        post :create, params: { user: { username: user.username, password: user.password } }
      end

      it 'redirect to root path' do
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(root_path)
      end

      it 'set already_authenticated flash' do
        is_expected.to set_flash[:alert].to(I18n.t('devise.failure.already_authenticated'))
      end
    end

    context 'when user is not authenticated.' do
      context 'when Correct username and password' do
        before do
          post :create, params: { user: { username: user.username, password: user.password } }
        end

        it 'redirect to root path' do
          is_expected.to respond_with(:redirect)
          is_expected.to redirect_to(root_path)
        end

        it "current_user be present" do
          expect(controller.send(:current_user)).to eq(user)
        end
       
        it 'set signed_in flash' do
          is_expected.to set_flash[:notice].to(I18n.t('devise.sessions.signed_in'))
        end
      end

      context 'when Incorrect username or password' do
        before do
          post :create, params: { user: { username: user.username, password: 'incorrect' } }
        end

        it 'returns unprocessable entity status' do
          is_expected.to respond_with(:unprocessable_entity)
          is_expected.to render_template(:new)
        end

        it 'set invalid flash' do
          is_expected.to set_flash.now[:alert].to('Invalid Username or password.')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user already signed in' do
      before do
        sign_in user
        delete :destroy
      end

      it 'redirect to root path' do
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(root_path)
      end

      it "current_user be nil" do
        expect(controller.send(:current_user)).to be_nil
      end
      
      it 'set signed out flash' do
        is_expected.to set_flash[:notice].to(I18n.t('devise.sessions.signed_out'))
      end
    end

    context 'when user is not authenticated' do
      before do
        delete :destroy
      end

      it 'redirect to root path' do
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(root_path)
      end

      it 'set already_signed_out flash' do
        is_expected.to set_flash[:notice].to(I18n.t('devise.sessions.already_signed_out'))
      end
    end
  end
end
