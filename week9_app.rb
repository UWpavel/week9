require 'rubygems'
require 'sinatra'
require 'haml'

# http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html

### CONFIG
configure do
  enable :sessions, :logging, :dump_errors
  
  @@users = { "me" => "da", "you" => "too" }
  @@convert = {
    "$ to Rubles" => 30, 
    "Miles to kilometers" => 1.61,
    "Liters to Galons" =>  0.264 }
  
  log = File.new("sinatra.log", 'a')
	STDOUT.reopen(log)
	STDERR.reopen(log)
end

### HELPERS

helpers do
  
  # checking if the user is authorized
  def authorized?
    return session.has_key?(:user)
  end
  
  # Authentication
  def authenticate?( username, password )
    return @@users[username] == password
  end
  
  # Returns an array of routes, ignoring exceptions
  def my_routes
    my_routes = []
    exceptions = %w(Login Signin)
    self.class.routes['GET'].each do |r|
      route = r.first.to_s.gsub(/\W+|mix/,'').capitalize
      my_routes << route unless exceptions.include?(route)
    end
    return my_routes
  end
  
  # Sanitize text input before evaluating
  def sanitize( str )
    return str.scan(/\d|\(|\)|\*|\+|\-|\/|\.|\%/).to_s
  end
  
  # we can welcome new and known users, need a helper
  def welcome( user )
    session[:user] = user
    session[:last_login] = Time.now.strftime("%m-%d-%Y %H:%M:%S") 
    redirect "/"
  end
end

# putting routes into a separate file.
load "routes.rb"
