# spec/requests/user_controller_spec.rb

require 'rails_helper'

RSpec.describe "ApiV1::UserController", type: :request do
  describe "POST /v1/user/sign_up" do
    let(:valid_username) { "testuser" }
    let(:headers) { { "Content-Type" => "application/json" } }

    context "when the request is valid" do
      it "creates a new user and returns a token" do
        expect {
          post "/v1/user/sign_up", params: { username: valid_username }.to_json, headers: headers
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("token")
        expect(json_response["token"]).to be_a(String)
      end
    end

    context "when the username is missing" do
      it "returns a bad request with an error message" do
        post "/v1/user/sign_up", params: {}.to_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to eq({ "error" => "username should not be empty" })
      end
    end

    context "when the username is empty" do
      it "returns a bad request with an error message" do
        post "/v1/user/sign_up", params: { username: "" }.to_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to eq({ "error" => "username should not be empty" })
      end
    end

    context "when the username already exists" do
      before do
        User.create!(username: valid_username)
      end

      it "returns a bad request with an error message" do
        post "/v1/user/sign_up", params: { username: valid_username }.to_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to eq({ "error" => "username already registered" })
      end
    end
  end
end
