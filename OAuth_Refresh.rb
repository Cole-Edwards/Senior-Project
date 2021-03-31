#!/usr/bin/env ruby

require_relative '../../lib/helpers/_helpers'
require_relative '../../lib/models/_models'
binding.pry if ENV["TESTING"] == "true"
Token.where({service: "Google"}).each do |token|
    deserialized_data = JSON.parse(token[:data]) rescue nil
    refresh_token = deserialized_data["refresh_token"] rescue nil
    
    if refresh_token 
            uri = URI("https://www.googleapis.com/oauth2/v4/token")

            form = {
              "client_id" => ENV["GOOGLE_CLIENT_ID"],
              "client_secret" => ENV["GOOGLE_CLIENT_SECRET"],
              "refresh_token" => refresh_token,
              "grant_type" => "refresh_token"
            }

            response = Net::HTTP.post_form(uri, form)
            response_code = response.code.to_s rescue nil
            response_body = JSON.parse(response.body) rescue nil
        
        if response_code =~ /2../
            deserialized_data["access_token"] = response_body["access_token"]
            token[:data] = deserialized_data.to_json
            token.save!
            puts "new token is #{response_body['access_token']}"
        else
            puts "help"
        end
    end
end
