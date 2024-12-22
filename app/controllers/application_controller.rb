class ApplicationController < ActionController::API
  include ActionController::Helpers

  attr_reader :current_user

  rescue_from StandardError, with: :json_error_response

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

  def json_error_response(err)
    payload = {
      message: err.message,
      backtrace: err.backtrace
    } unless Rails.env.production?

    render_internal_server_error(payload)
  end

  def render_success(payload)
    render json: payload
  end

  def render_bad_request(payload)
    render json: payload, status: :bad_request
  end

  def render_internal_server_error(payload)
    render json: payload, status: :internal_server_error
  end
end
