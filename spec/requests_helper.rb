# stackoverflow.com/questions/5787409/stubbing-authentication-in-request-spec
def login(user)
  post_via_redirect user_session_path, 'user[email]' => user.email,
                                       'user[password]' => user.password
end
