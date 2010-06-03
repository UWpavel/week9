### ROUTES
# Making sure users are loged in to use the app.
before do
  unless authorized? or request.path_info.match(/^\/login$|^\/signin$/)
    redirect "/login"
  end
end

# After each page we increment page_views
after do
  session[:page_views] ||= 0 
  session[:page_views] += 1
end

# Welcome page
get "/" do
  haml :welcome
end

# Handles logins
get "/login" do
  session[:login_page_visits] ||= 0
  session[:login_page_visits] += 1
  haml :login, :layout => false
end

post "/login" do
  if authenticate?( params[:username], params[:password] )
    welcome(params[:username])
  else
    session[:last_msg] = "Authentication Failed."
    redirect "/login"
  end
end

post "/logout" do
	session.clear
  redirect "/login"
end

# reporting user statistics
get "/stats" do
  haml :stats
end

# Evaluates math problems
get "/math" do
  haml :math
end

post "/math" do
  problem = sanitize(params[:problem])
  begin
    result = eval(problem)
  rescue SyntaxError
    result = "Failed"
  end
  session[:solved_problems] ||= 0
  session[:solved_problems] += 1
  session[:last_msg] = result
  redirect "/math"
end

# Handles new users
get "/signin" do
  haml :signin, :layout => false
end

post "/signin" do
  redirect "/signin" if @@users.has_key?(params[:username])
  @@users[params[:username]] = params[:password]
  welcome(params[:username])
end

# reports time Now
get "/time" do
  haml :time
end

#get "/convert" do
  #haml :convert
#end