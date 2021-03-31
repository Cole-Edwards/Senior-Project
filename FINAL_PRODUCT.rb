#!/usr/bin/env ruby

require_relative '../../lib/helpers/_helpers'
require_relative '../../lib/models/_models'

temp_file = "#{ARGV[0]}"
payload = JSON.parse(File.read(temp_file))

HTTParty.post(
  "https://hooks.slack.com/services/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",
 {
    headers: { "Content-Type" => "application/json" },
    body: {
      text: "```onboarding executed!\npayload:\n#{payload}```"
    }.to_json
  }
)

first_name = payload["real_name"].split.first rescue nil
last_name = payload["real_name"].split.last rescue nil

if first_name && last_name

  email = (first_name + last_name + "@Emailhere.com").downcase
  temp_password = "twin1234"

  response = HTTParty.post(
    "https://www.googleapis.com/admin/directory/v1/users",
    headers: {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{Token.get_tel_access_token}"
    },
    body: {
      "name" => {
        "familyName" => "#{last_name}",
        "givenName" => "#{first_name}"
      },
      "password" => "#{temp_password}",
      "primaryEmail" => "#{email}",
      "changePasswordAtNextLogin" => true
    }.to_json
  )
  
  response_code = response.code.to_s rescue nil
  response_body = JSON.parse(response.body) rescue nil
  
  if response_code =~ /2../
    HTTParty.post(
     "https://hooks.slack.com/services/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",
     {
       headers: { "Content-Type" => "application/json" },
       body: {
         text: "```Email: #{email}\nTemporary password: #{temp_password}```"
       }.to_json
     }
    )
  else
    HTTParty.post(
     "https://hooks.slack.com/services/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",
     {
       headers: { "Content-Type" => "application/json" },
       body: {
         text: "```Failed to provision account for: #{email}```"
       }.to_json
     }
    )
  end

end