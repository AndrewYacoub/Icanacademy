module GoogleCalendarHelper
  require 'google/apis/calendar_v3'
  require 'google/apis/calendar_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'

  OOB_URI = 'http://localhost:3000/oauth2callback'.freeze
  APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze
  CREDENTIALS_PATH = 'config/credentials/google_calendar.json'.freeze
  TOKEN_PATH = 'token.yaml'.freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

  def authorize
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and authorize the application:'
      puts url
      puts 'Enter the resulting code here:'
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end

  def calendar_service

    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize
    service.key = 'AIzaSyCs1WEtOVZ755fDSnXYKyVhFAE-Q3Vchc8'  # Replace with your API Key
    return service

  end

  def create_google_meet_link(group, session)

    event = Google::Apis::CalendarV3::Event.new(
      summary: "Group Session: #{group.name}",
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: session.start_time.to_datetime.rfc3339,
        time_zone: 'Africa/Cairo'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: session.end_time.to_datetime.rfc3339,
        time_zone: 'Africa/Cairo'
      ),
      conference_data: Google::Apis::CalendarV3::ConferenceData.new(
        create_request: Google::Apis::CalendarV3::CreateConferenceRequest.new(
          request_id: SecureRandom.uuid,
          conference_solution_key: Google::Apis::CalendarV3::ConferenceSolutionKey.new(
            type: 'hangoutsMeet'
          )
        )
      )
    )

    service = calendar_service
    result = service.insert_event('primary', event, conference_data_version: 1)
    result.hangout_link
  end
end
