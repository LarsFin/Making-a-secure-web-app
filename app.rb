require_relative './lib/user'

class App

  def get_homepage request
    username = current_user(request).username if current_user(request)
    "Welcome #{username}"
  end

  def get_users request
    "Hello World!"
  end

  def get_users_new request
    File.read("public/sign-up.html")
  end

  def post_users request
    user = User.create("username" => request.get_param("username"))
    login user, redirect('/')
  end

  private
  def redirect path
    {location: path, code: "303 See Other"}
  end

  def login user, params
    params[:cookie] = "user-id=#{user.id}"
    params
  end

  def current_user request
    user = User.find({"id" => request.get_cookie("user-id")}) if request.has_cookie?
  end
end
