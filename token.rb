class Token < ActiveRecord::Base

  def self.get_tel_access_token()
    token = Token.where({ owner: "<Domain_name>", service: "Google", token_type: "Access Token" }).first
    access_token = JSON.parse(token["data"])["access_token"]
    return access_token
  end

end