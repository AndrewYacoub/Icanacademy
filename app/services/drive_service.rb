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

  def upload_image(file_path)
    file_metadata = {
      name: File.basename(file_path)
    }
    file = @service.create_file(file_metadata, upload_source: file_path, content_type: 'image/jpeg')
    
    # Make the file publicly accessible
    create_permission(file.id, { role: 'reader', type: 'anyone' })
    
    file.id
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
