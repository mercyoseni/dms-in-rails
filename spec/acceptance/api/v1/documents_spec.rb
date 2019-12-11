require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Documents" do
  header "Accept", "application/vnd.api+json"

  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let!(:document) { create(:document, access: "public", user: user) }
  let!(:document1) { create(:document, access: "public", user: user1) }

  before { header "Authorization", authenticated_header(user) }

  post "/api/v1/documents" do
    explanation "Creating a document for current user"

    context "201" do
      example "Creating a document" do
        request = {
          "data": {
            "type": "documents",
            "attributes": {
              "title": "Lorem",
              "body": "Ipsum dolor",
              "access": "private"
            }
          }
        }

        do_request(request)

        expect(status).to eq(201)
      end
    end

    context "422" do
      example "Creating a document - errors" do
        request = {
          "data": {
            "type": "documents",
            "attributes": {
              "title": "Lorem",
              "body": "Ipsum dolor",
              "access": ""
            }
          }
        }

        do_request(request)

        expect(status).to eq(422)
      end
    end
  end

  get "/api/v1/documents" do
    header "Content-Type", "application/vnd.api+json"

    context "422" do
      example "Geting all documents - errors" do
        header "Authorization", ""

        do_request

        expect(status).to eq(422)
      end
    end

    context "200" do
      example "Geting all documents" do
        do_request

        expect(status).to eq(200)
      end
    end
  end

  get "api/v1/documents/:id" do
    header "Content-Type", "application/vnd.api+json"

    context "200" do
      let(:id) { document.id }

      example "Getting a document" do
        do_request

        expect(status).to eq(200)
      end
    end

    context "404" do
      let(:id) { 0 }

      example "Getting a document - not found" do
        do_request

        expect(status).to eq(404)
      end
    end
  end

  put "api/v1/documents/:id" do
    context "200" do
      let(:id) { document.id }

      example "Updating a document" do
        request = {
          "data": {
            "type": "documents",
            "attributes": {
              "title": "Updated"
            }
          }
        }

        do_request(request)

        expect(status).to eq(200)
      end
    end

    context "403" do
      let(:id) { document1.id }

      example "Updating a document - unauthorized" do
        request = {
          "data": {
            "type": "documents",
            "attributes": {
              "title": "Change title"
            }
          }
        }

        do_request(request)

        expect(status).to eq(403)
      end
    end
  end

  delete "api/v1/documents/:id" do
    context "204" do
      let(:id) { document.id }

      example "Deleting a document" do
        do_request

        expect(status).to eq(204)
      end
    end

    context "403" do
      let(:id) { document1.id }

      example "Deleting a document - unauthorized" do
        do_request

        expect(status).to eq(403)
      end
    end
  end

  get "/api/v1/users/:user_id/documents" do
    context "200" do
      let(:user_id) { user.id }

      example "Getting related resources" do
        do_request

        expect(status).to eq(200)
      end
    end
  end
end
