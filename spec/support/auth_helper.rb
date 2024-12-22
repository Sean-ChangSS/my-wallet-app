module AuthHelper
  def token_generator(user_id)
    "Bearer #{JwtUtils.encode(user_id: user_id)}"
  end

  def auth_header(user_id)
    {
      "Authorization" => token_generator(user_id),
      "Content-Type" => "application/json",
    }
  end
end
