require_relative './lib/user'

class App

  def get_homepage request
    "Welcome"
  end

  def get_users request
    "Hello World!"
  end

  def get_users_new request
    File.read("public/sign-in.html")
  end

  def post_users request
    p User.create("username" => request.get_param("username"))
    get_users(request)
  end

end
