class ApplicationController < ActionController::API
  include ActionController::Helpers

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.sub(/Bearer /, '') if header

    if token.present?
      begin
        decoded_token = JwtUtils.decode(token)
        user_id = decoded_token['user_id']
        @current_user = User.find(user_id)
      rescue => e
        render json: { error: e.message }, status: :unauthorized
      end
    else
      render json: { error: 'Missing token' }, status: :unauthorized
    end
  end
end
