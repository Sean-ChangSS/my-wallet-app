class ApiV1::UserController < ApiV1::BaseController
  <<-APIDOC
    =begin
      @apiGroup User
      @api {post}/v1/user/sign_up user/sign_up
      @apiParam {String} username username
      @apiSuccessExample {json} success
        HTTP/1.1 200
        {
          "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE3Mz..."
        }
      @apiFailureExample {json} failure
        HTTP/1.1 4xx
        {
          "error": "username should not be empty"
        }
    =end
  APIDOC
  def sign_up
    username = params[:username]

    if username.nil? || username.empty?
      return render_bad_request({ error: 'username should not be empty' })
    end

    if User.where(username: username).exists?
      return render_bad_request({ error: 'username already registered' })
    end

    user = User.create!(username: username)

    render_success({ token: JwtUtils.encode({user_id: user.id}) })
  end
end
