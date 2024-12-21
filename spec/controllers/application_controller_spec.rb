# spec/controllers/application_controller_spec.rb

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '.authenticate_request' do
    controller do
      before_action :authenticate_request
  
      def index
        render json: { user: current_user }
      end
    end
  
    let(:user) { create(:user) }
    let(:valid_token) { JwtUtils.encode(user_id: user.id) }
    let(:invalid_token) { 'invalid.token.here' }
    
    context 'with valid token' do
      before do
        request.headers['Authorization'] = "Bearer #{valid_token}"
        get :index
      end

      it 'returns the current user' do
        expect(JSON.parse(response.body)['user']['id']).to eq(user.id)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid token' do
      before do
        request.headers['Authorization'] = "Bearer #{invalid_token}"
        get :index
      end

      it 'returns unauthorized error' do
        expect(JSON.parse(response.body)['error']).to eq('Invalid token')
      end

      it 'returns status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      let(:expired_token) { JwtUtils.encode({ user_id: user.id }, 1.hour.ago) }

      before do
        request.headers['Authorization'] = "Bearer #{expired_token}"
        get :index
      end

      it 'returns token expired error' do
        expect(JSON.parse(response.body)['error']).to eq('Token has expired')
      end

      it 'returns status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without token' do
      before do
        get :index
      end

      it 'returns missing token error' do
        expect(JSON.parse(response.body)['error']).to eq('Missing token')
      end

      it 'returns status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
