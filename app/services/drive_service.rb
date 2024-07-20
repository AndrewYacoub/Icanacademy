# app/services/drive_service.rb
require 'google/apis/drive_v3'
require 'googleauth'

class DriveService
  DRIVE = Google::Apis::DriveV3

  def initialize
    @service = DRIVE::DriveService.new
    @service.authorization = authorize
  end

  def create_permission(file_id, permission)
    @service.create_permission(file_id, permission, fields: 'id')
  end

  private

  def authorize
    scope = 'https://www.googleapis.com/auth/drive'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('config/credentials/google_forms.json'),
      scope: scope
    )
    authorizer.fetch_access_token!
    authorizer
  end
end
