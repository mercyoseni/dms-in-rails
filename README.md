## Document Management System (API)

Document Management System provides a restful API for users to create and manage documents giving different privileges based on user roles and managing authentication using JWT.

## API Documentation
The API has routes, each dedicated to a single task that uses HTTP response codes to indicate API status and errors.

#### API Features

The following features make up the Document Management System API:

##### Authentication

- It uses JSON Web Token (JWT) for authentication
- It generates a token on successful login or account creation and returns it to the user
- It verifies the token to ensure a user is authenticated to access every endpoints

##### Users

- It allows users to be created
- It allows users to login and obtain a unique token which expires every 24hours
- It allows authenticated users to retrieve and update their information
- It allows users to retrieve and manage their documents
- It allows the admin to manage users

##### Documents

- It allows new documents to be created by authenticated users
- It ensures all documents are accessible based on the permission/priviledges
- It allows admin users to create, retrieve, modify, and delete documents
- It ensures users can retrieve, edit and delete documents that they own
- It allows users to retrieve all documents they own as well as public documents
- It allows users on the same role to retrieve role-based documents

## Hosted App on Heroku
[dms-api-in-rails-api](https://dms-api-in-rails.herokuapp.com/)

## API Documentation
- *View API endpoints and their functions (still in progress)*

## Technologies Used
- **[Ruby-on-Rails](https://rubyonrails.org/)**
- **[PostgreSQL](https://www.postgresql.org/)**

### **Installation Steps**
* Ensure you have `ruby` and `rails` installed or install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) and [Rails](https://rubygems.org/gems/rails)
* Clone the project repository from your terminal `git clone https://github.com/andela-moseni/dms-in-rails.git`
* Change directory into the `dms-in-rails` directory
* Run `bundle install` to install the dependencies in the `Gemfile`
* Run `rails db:setup` to create database, run migrations and seed data
* Run `rails s` to start the project
* Use [Postman](https://www.getpostman.com/) or any API testing tool of your choice to access the endpoints

### **Endpoints**
**N/B:** For all endpoints that require authentication, use `Authorization: <token>`

### Limitations:
The limitations to the **Document Management System API** are as follows:
* Users can only create plain textual documents and retrieve same when needed
* Users cannot share documents with people, but can make document `public` to make it available to other users
* Users login and obtain a token which is verified on every request, but users cannot logout (nullify the token), however tokens become invalid when it expires (after 24 hours)

### How to Contribute
Contributors are welcome to further enhance the features of this API by contributing to its development. The following guidelines should guide you in contributing to this project:

1. Fork the repository.
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request describing the feature(s) you have added
6. Include a `feature.md` readme file with a detailed description of the feature(s) you have added, along with clear instructions of how to use the features(s) you have added. This readme file will be reviewed and included in the original readme if feature is approved.

Ensure your codes follow the [Ruby coding style guide](https://github.com/rubocop-hq/ruby-style-guide)
