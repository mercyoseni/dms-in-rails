require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users" do
  header "Accept", "application/vnd.api+json"

  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  before { header "Authorization", authenticated_header(user) }

  post "/api/v1/signup" do
    explanation "A user needs to signup to get started"

    context "201" do
      example "Creating an account" do
        header "Authorization", ""

        request = {
          "data": {
            "type": "users",
            "attributes": {
              "firstname": "Foo",
              "lastname": "Bar",
              "email": "foo@bar.test",
              "password": "password",
              "password_confirmation": "password"
            }
          }
        }

        do_request(request)

        # User signup successful
        expect(status).to eq(201)
      end
    end

    context "422" do
      example "Creating an account - errors" do
        header "Authorization", ""

        request = {
          "data": {
            "type": "users",
            "attributes": {
              "firstname": "Foo",
              "lastname": "Bar",
              "email": "hhh",
              "password": "password",
              "password_confirmation": "password"
            }
          }
        }

        do_request(request)

        expect(status).to eq(422)
      end
    end
  end

  get "/api/v1/users" do
    header "Content-Type", "application/vnd.api+json"

    context "422" do
      example "Geting all users - errors" do
        header "Authorization", ""

        do_request

        expect(status).to eq(422)
      end
    end

    context "200" do
      example "Geting all users" do
        do_request

        expect(status).to eq(200)
      end
    end
  end

  get "api/v1/users/:id" do
    header "Content-Type", "application/vnd.api+json"

    context "200" do
      let(:id) { user.id }

      example "Getting a user" do
        do_request

        expect(status).to eq(200)
      end
    end

    context "404" do
      let(:id) { 0 }

      example "Getting a user - not found" do
        do_request

        expect(status).to eq(404)
      end
    end
  end

  put "api/v1/users/:id" do
    context "200" do
      let(:id) { user.id }

      example "Updating a user" do
        request = {
          "data": {
            "type": "users",
            "attributes": {
              "firstname": "Updated"
            }
          }
        }

        do_request(request)

        expect(status).to eq(200)
      end
    end

    context "403" do
      let(:id) { user1.id }

      example "Updating a user - unauthorized" do
        request = {
          "data": {
            "type": "users",
            "attributes": {
              "firstname": "Change name"
            }
          }
        }

        do_request(request)

        expect(status).to eq(403)
      end
    end
  end

  delete "api/v1/users/:id" do
    context "204" do
      let(:id) { user.id }

      example "Deleting a user" do
        do_request

        expect(status).to eq(204)
      end
    end

    context "403" do
      let(:id) { user1.id }

      example "Deleting a user - unauthorized" do
        do_request

        expect(status).to eq(403)
      end
    end
  end

  get "/api/v1/documents/:document_id/user" do
    context "200" do
      let(:document) { create(:document, access: "public", user: user) }
      let(:document_id) { document.id }

      example "Getting related resource" do
        do_request

        expect(status).to eq(200)
      end
    end
  end
end
