# Gets user token
def authenticated_header(user)
  token = AuthenticateUser.new(user.email, user.password).call
end
