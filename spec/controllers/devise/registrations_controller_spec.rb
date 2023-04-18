require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: [:controller, :devise_controller] do

  describe 'GET #new' do
    before { get :new }

    it 'returns success status' do
      is_expected.to respond_with(:success)
      is_expected.to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        username: 'example',
        email: 'example@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    context 'when parameters is valid' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_params }
        end.to change { User.count }.by(1)
      end

      it 'redirect to complete_user_registration_path' do
        post :create, params: { user: valid_params }
        is_expected.to respond_with(:redirect)
        is_expected.to redirect_to(root_path)
      end
    end

    context 'when username is invalid' do
      let(:invalid_params) do
        {
          username: '',
          email: 'example@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_params }
        end.not_to change { User.count }
      end

      it 'returns unprocessable_entity status' do
        post :create, params: { user: invalid_params }
        is_expected.to respond_with(:unprocessable_entity)
        is_expected.to render_template(:new)
      end

      it 'returns username error messages' do
        post :create, params: { user: invalid_params }
        expect(assigns(:user).errors.messages[:username]).to be 
      end
    end

    context 'when password is not match' do
      let(:invalid_params) do
        {
          username: 'example',
          email: 'example@example.com',
          password: 'password',
          password_confirmation: 'password111'
        }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_params }
        end.not_to change { User.count }
      end

      it 'returns unprocessable_entity status' do
        post :create, params: { user: invalid_params }
        is_expected.to respond_with(:unprocessable_entity)
        is_expected.to render_template(:new)
      end

      it 'returns password error messages' do
        post :create, params: { user: invalid_params }
        expect(assigns(:user).errors.messages[:password]).to be
      end
    end
  end
end
