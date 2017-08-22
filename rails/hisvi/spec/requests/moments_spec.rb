require "rails_helper"

RSpec.describe "moments API", type: :request do
  # initialize test data
  let!(:users) {create_list(:user, 10)}
  let!(:categories) {create_list(:category, 5)}
  let!(:story) {create(:story, category_id: 1)}
  let!(:moments) {create_list(:moment, 10, story_id: 1, is_completed: true)}
  let(:moment_id) {moments.first.id}
  let(:authentication_token) {User.first.authentication_token}

  # Test suite for GET /moments
  describe "GET /api/stories/1/moments" do
    # make HTTP get request before each example
    before { get "/api/stories/1/moments" }

    it "returns moments" do
      # Note `json` is a custom helper to parse JSON responses
      expect(json["data"]["moment"]).not_to be_empty
      expect(json["data"]["moment"].size).to eq(10)
    end

    it "returns status code ok" do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for GET /moments/:id
  describe "GET /api/moments/:id" do
    before { get "/api/moments/#{moment_id}" }

    context "when the record exists" do
      it "returns the moment" do
        expect(json["data"]["moment"]).not_to be_empty
        expect(json["data"]["moment"]["id"]).to eq(moment_id)
      end

      it "returns status code ok" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record does not exist" do
      let(:moment_id) {11}

      it "returns status failure" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found message" do
        expect(json["messages"]).to match("Moment not found")
      end
    end
  end

  # Test suite for POST /api/stories/1/moments
  describe "POST /api/stories/1/moments" do
    # valid payload
    let(:valid_attributes) {{ moment: {story_id: 1,
      content: "this is a very long text"} }}

    context "when the request is valid" do
      before {post "/api/stories/1/moments", params: valid_attributes,
        headers: {"MS-AUTH-TOKEN" => authentication_token}}

      it "creates a moment" do
        expect(json["data"]["moment"]["content"]).to eq(
          "this is a very long text")
      end

      it "returns status :created" do
        expect(response).to have_http_status(:created)
      end
    end

    context "when the request lacks authen token" do
      before {post "/api/stories/1/moments", params: valid_attributes}

      it "returns status code :unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns a validation failure message" do
        expect(json["messages"]).to match(
          "You need to sign in or sign up before continuing.")
      end
    end
  end

  # Test suite for PUT /api/moments/1
  describe "PUT /api/moments/:id" do
    let(:valid_attributes) {{ moment: {content: "a new content"} }}
    let(:valid_attributes2) {{ moment: {email: " a new content 2"} }}

    context "when the record exists, valid token" do
      it "returns a successfully update message" do
        put "/api/moments/#{moment_id}", params: valid_attributes,
          headers: {"MS-AUTH-TOKEN" => authentication_token}

        expect(json["messages"]).to match("Update successfully")
      end

      it "returns status :ok" do
        put "/api/moments/#{moment_id}", params: valid_attributes2,
          headers: {"MS-AUTH-TOKEN" => authentication_token}

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record exists, unvalid auth token" do
      before { put "/api/moments/#{moment_id}" }

      it "invalid permission" do
        expect(json["messages"]).to match(
          "Invalid permission")
      end

      it "returns status :unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Test suite for DELETE /moments/:id
  describe "DELETE /api/moments/:id" do
    context "when the moment exits, unvalid auth token" do
      before { delete "/api/moments/#{moment_id}" }

      it "returns status :unauthorized " do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the moment exist, valid auth token" do
      it "return successfully deleted status :ok" do
        delete "/api/moments/#{moment_id}",
          headers: {"MS-AUTH-TOKEN" => authentication_token}
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
