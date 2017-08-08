require "rails_helper"

RSpec.describe "users API", type: :request do
  # initialize test data
  let!(:users) {create_list(:user, 10)}
  let(:user_id) {users.first.id}
  let(:authentication_token) {users.first.authentication_token}

  # Test suite for GET /users
  describe "GET /api/users" do
    # make HTTP get request before each example
    before { get "/api/users" }

    it "returns users" do
      # Note `json` is a custom helper to parse JSON responses
      expect(json["data"]["user"]).not_to be_empty
      expect(json["data"]["user"].size).to eq(10)
    end

    it "returns status code ok" do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for GET /users/:id
  describe "GET /api/users/:id" do
    before { get "/api/users/#{user_id}" }

    context "when the record exists" do
      it "returns the user" do
        expect(json["data"]["user"]).not_to be_empty
        expect(json["data"]["user"]["id"]).to eq(user_id)
      end

      it "returns status code ok" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record does not exist" do
      let(:user_id) {11}

      it "returns status failure" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found message" do
        expect(json["messages"]).to match("User not found")
      end
    end
  end

  # Test suite for POST /api/sign_up
  describe "POST /api/sign_up" do
    # valid payload
    let(:valid_attributes) {{ user: {email: "a@a.com",
      password: "123123",
      password_confirmation: "123123"} }}

    context "when the request is valid" do
      before {post "/api/sign_up", params: valid_attributes}

      it "creates a user" do
        expect(json["data"]["user"]["email"]).to eq("a@a.com")
      end

      it "returns status :created" do
        expect(response).to have_http_status(:created)
      end
    end

    context "when the request is invalid" do
      before { post "/api/sign_up" }

      it "returns status code :bad_request" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns a validation failure message" do
        expect(json["messages"]).to match("Missing parameter")
      end
    end
  end

  # Test suite for PUT /users/:id
  describe "PUT /api/users/:id" do
    let(:valid_attributes) {{ user: {email: "b@b.com"} }}
    let(:valid_attributes2) {{ user: {email: "a@a.com"} }}

    context "when the record exists, valid token" do
      it "returns a successfully update message" do
        put "/api/users/#{user_id}", params: valid_attributes,
          headers: {"MS-AUTH-TOKEN" => authentication_token}

        expect(json["messages"]).to match("Update successfully")
      end

      it "returns status :ok" do
        put "/api/users/#{user_id}", params: valid_attributes2,
          headers: {"MS-AUTH-TOKEN" => authentication_token}

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record exists, unvalid auth token" do
      before { put "/api/users/#{user_id}" }

      it "invalid permission" do
        expect(json["messages"]).to match("Invalid permission")
      end

      it "returns status :unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Test suite for DELETE /users/:id
  describe "DELETE /api/users/:id" do
    context "when the user exits, unvalid auth token" do
      before { delete "/api/users/#{user_id}" }

      it "returns status :unauthorized " do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the user exist, valid auth token" do
      it "return successfully deleted status :ok" do
        delete "/api/users/#{user_id}",
          headers: {"MS-AUTH-TOKEN" => authentication_token}
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
