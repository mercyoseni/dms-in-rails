require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Admin - Users" do
  header "Accept", "application/vnd.api+json"

  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  # make user an admin and authenticate
  before do
    user.update(role: "admin")
    header "Authorization", authenticated_header(user)
  end

  get "/api/v1/admin/users" do
    context "403" do
      example "Accessible for only an admin" do
        header "Authorization", authenticated_header(user1)

        do_request

        expect(status).to eq(403)
      end
    end
  end

  post "/api/v1/admin/users" do
    explanation "An admin can create a user"

    context "201" do
      example "Creating a user" do
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

        expect(status).to eq(201)
      end
    end

    context "422" do
      example "Creating a user - errors" do
        request = {
          "data": {
            "type": "users",
            "attributes": {
              "firstname": "Foo",
              "lastname": "Bar",
              "email": "foo@bar.test",
              "password": "password",
              "password_confirmation": ""
            }
          }
        }

        do_request(request)

        expect(status).to eq(422)
      end
    end
  end

  get "/api/v1/admin/users" do
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

  get "api/v1/admin/users/:id" do
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

  put "api/v1/admin/users/:id" do
    context "200" do
      let(:id) { user1.id } # admin can perform CRUD operations on a user

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

    context "404" do
      let(:id) { 0 }

      example "Updating a user - not found" do
        request = {
          "data": {
            "type": "users",
            "attributes": {
              "firstname": "Change name"
            }
          }
        }

        do_request(request)

        expect(status).to eq(404)
      end
    end
  end

  delete "api/v1/admin/users/:id" do
    context "204" do
      let(:id) { user1.id }

      example "Deleting a user" do
        do_request

        expect(status).to eq(204)
      end
    end

    context "404" do
      let(:id) { 0 }

      example "Deleting a user - not found" do
        do_request

        expect(status).to eq(404)
      end
    end
  end

  get "/api/v1/admin/documents/:document_id/user" do
    context "200" do
      let!(:document1) { create(:document, access: "public", user: user1) }
      let(:document_id) { document1.id }

      example "Getting related resource" do
        do_request

        expect(status).to eq(200)
      end
    end
  end
end
