require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'

get '/' do
  "<h1>Hoptoad &#10084; Heroku</h1><p>Hoptoad deploy tracking using Heroku's HTTP Post deploy hook</p><h2>Usage</h2><pre><code><strong>$</strong> heroku addons:add deployhooks:http url=http://hoptoad-loves.heroku.com/YOUR_HOPTOAD_API_KEY/YOUR_RACK_ENV</code></pre><p>Change <code>YOUR_HOPTOAD_API_KEY</code> and <code>YOUR_RACK_ENV</code> to your settings.</p>"
end

post '/:api_key/:rack_env' do
  if params[:api_key] != "" && params[:rack_env] != ""
    opts = { 'api_key' => params[:api_key] }
    opts['deploy[rails_env]'] = params[:rack_env].downcase
    opts['deploy[scm_revision]'] = params[:head_long]
    opts['deploy[scm_repository]'] = "git@heroku.com:#{params[:app]}.git"
    opts['deploy[local_username]'] = params[:user]

    response = Net::HTTP.post_form(URI.parse("http://hoptoadapp.com/deploys.txt"), opts)
    [response.code.to_i, response.body]
  else
    [400, "Error: No Hoptoad API key provided"]
  end
end
