require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'http://localhost:3000/oauth2callback'.freeze 
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze 
CREDENTIALS_PATH = 'config/credentials/google_calendar.json'.freeze 
TOKEN_PATH = 'token.yaml'.freeze 
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR 

# def authorize
#   client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
#   token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
#   authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
#   user_id = 'default'
#   credentials = authorizer.get_credentials(user_id)
#   if credentials.nil?
#     url = authorizer.get_authorization_url(base_url: OOB_URI)
#     puts 'Open the following URL in the browser and authorize the application:'
#     puts url
#     puts 'Enter the resulting code here:'
#     code = gets
#     credentials = authorizer.get_and_store_credentials_from_code(
#       user_id: user_id, code: code, base_url: OOB_URI
#     )
#   end
#   credentials
# end

# service = Google::Apis::CalendarV3::CalendarService.new
# service.client_options.application_name = APPLICATION_NAME
# service.authorization = authorize
# service.key = 'AIzaSyCs1WEtOVZ755fDSnXYKyVhFAE-Q3Vchc8'  # Replace with your API Key

# calendar_id = 'primary'
# response = service.list_events(calendar_id,
#                                max_results: 10,
#                                single_events: true,
#                                order_by: 'startTime',
#                                time_min: Time.now.iso8601)
# puts 'Upcoming events:'
# puts 'No upcoming events found' if response.items.empty?
# response.items.each { |event| puts "- #{event.summary} (#{event.start.date || event.start.date_time})" }
# OOB_URI = 'http://localhost:3000/oauth2callback'
# APPLICATION_NAME = 'EnlightenED'
# CREDENTIALS_PATH = 'config/credentials/google_calendar.json'.freeze
# TOKEN_PATH = 'token.yaml'
# SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
user_id = 'default'
credentials = authorizer.get_credentials(user_id)

if credentials.nil?
  url = authorizer.get_authorization_url(base_url: OOB_URI)
  puts "Open the following URL in the browser and enter the resulting code after authorization"
  puts url
  code = gets.chomp
  credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
end

$calendar_service = Google::Apis::CalendarV3::CalendarService.new
$calendar_service.client_options.application_name = APPLICATION_NAME
$calendar_service.authorization = credentials