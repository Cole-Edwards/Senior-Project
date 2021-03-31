require 'google/apis/admin_directory_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'pry'

binding.pry
OOB_URI = 
APPLICATION_NAME = 'Ruby Quickstart'
CLIENT_SECRETS_PATH = 
CREDENTIALS_PATH = 
SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER

def authorize()
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

service = Google::Apis::AdminDirectoryV1::DirectoryService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize
response = service.list_users(customer: 'my_customer', max_results: 10, order_by: 'email')
puts "Users:"
puts "No users found" if response.users.empty?
response.users.each { |user| puts "- #{user.primary_email} (#{user.name.full_name})" }
