require_relative 'models/user'
require_relative 'models/post'
require_relative '../lib/templating_engine'
require_relative '../lib/enc'

class App
  include Enc
  include TemplatingEngine

  def get_homepage(_request)
    redirect '/posts'
  end

  def get_users_new(request)
    error_msg = request.get_cookie('error-msg')
    if error_msg
      herb('public/sign-up.html', { error_msg: error_msg })
    else
      herb('public/sign-up.html', {})
    end
  end

  def get_users_signin(_request)
    File.read('public/sign-in.html')
  end

  def post_users_signin(request)
    request = process_request request
    user = User.find_first('username' => request.get_param('username'))
    if user && user.authorize(request.get_param('password'))
      return login user, redirect('/posts')
    end
    redirect('/users/signin')
  end

  def get_posts(request)
    unless request.has_cookie? && request.get_cookie('user-id')
      return redirect('/users/signin')
    end
    username = current_user(request).username if current_user(request)
    posts = Post.all.reverse
    herb('public/posts.html', username: username, posts: posts)
  end

  def get_allposts(_request)
    Post.all.map { |post| { content: post.content,
                            user: User.find_first('id' => post.user_id).username } }
            .to_json
  end

  def post_posts(request)
    # p request.get_param("post-content")
    request = process_request request
    Post.create('content' => request.get_param('post-content'),
                'user_id' => current_user(request).id)
    redirect('/posts')
  end

  def post_users(request)
    request = process_request request
    if validate_password request
      user = User.create('username' => request.get_param('username'),
                         'password' => request.get_param('password'))
      return login user, redirect('/posts') if user
    end
    redirect('/users/new', 'error-msg=Username already exists; path=/')
  end

  def get_users_signout(_request)
    redirect('/users/signin',
             'user-id=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT')
  end

  private

  def process_request(request)
    request.params.each { |k, v| request.params[k] = sanitize_user_input(v) } # Comment me to allow injections
    request
  end

  def sanitize_user_input(input)
    input.gsub(/['";<>]/, "'" => '&#39;',
                          '"' => '&#34;',
                          ';' => '&#59;',
                          '<' => '&#60;',
                          '>' => '&#62;') if input
  end

  def validate_password(request)
    (request.get_param('password') == request.get_param('password_conf')) && (request.get_param('password').length > 6)
  end

  def redirect(path, cookie = nil)
    params = { location: path, code: '303 See Other' }
    params[:cookie] = cookie if cookie
    params
  end

  def login(user, params)
    authtoken = generate_auth_token
    user.authhash = enc(authtoken)
    user.save
    params[:cookie] = "user-id=#{user.id}-#{authtoken}; path=/" #comment me out to allow logging in without auth tokens
    # params[:cookie] = "user-id=#{user.id}" #and comment me in
    params
  end

  def current_user(request)
    authenticate_token request # comment me out to allow logging in without auth tokens
    # User.find_first({"id" => request.get_cookie("user-id")}) if request.has_cookie? #and comment me in
  end

  def authenticate_token(request)
    if request.has_cookie?
      id, authtoken = request.get_cookie('user-id').split('-', 2)
      user = User.find_first('id' => id)
      user.authhash == enc(authtoken) ? user : nil
    end
  end
end
