#!/usr/bin/env ruby
require "thor"
require 'launchy'
require 'httparty'
require 'json'

class GSMetrics < Thor
  desc "setup", "Helps in Setting up a google Oauth Token"
  def setup
    say "Google Code API Console will open shortly."
    say "Please create a new API Project and then go to API Access and create a new \"Installed Application\" Client ID"
    sleep 5
    Launchy.open("https://code.google.com/apis/console")
    sleep 2
    client_id = ask "Paste your new Client ID:"
    client_secret = ask "Paste your new Client Secret:"
    auth_query = {
      :response_type => "code",
      :client_id => client_id,
      :redirect_uri => "urn:ietf:wg:oauth:2.0:oob",
      :scope => "https://spreadsheets.google.com/feeds/"
    }
    Launchy.open("https://accounts.google.com/o/oauth2/auth?" + auth_query.map{|e| e.join("=")}.join("&"))

    sleep 2

    code = ask "Paste your new Code:"

    token_query = {
      :code => code,
      :client_id => client_id,
      :client_secret => client_secret,
      :redirect_uri => "urn:ietf:wg:oauth:2.0:oob",
      :grant_type => "authorization_code"
    }

    response = HTTParty.post("https://accounts.google.com/o/oauth2/token", :body => token_query)

    tokens = JSON.parse(response.body)

    refresh_token = tokens["refresh_token"]

    say "Following is the code to create your GSMetrics Session. The last parameter is your Refresh Token"

    say "GSMetrics::Session.new("
    say "  \"#{client_id}\","
    say "  \"#{client_secret}\","
    say "  \"#{refresh_token}\""
    say ")"
  end
end

GSMetrics.start