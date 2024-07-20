class GoogleAuthController < ApplicationController
  def oauth2callback
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'

    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: params[:code], base_url: OOB_URI
    )

    # Redirect or render something to indicate successful authorization
    redirect_to root_path, notice: 'Authorization successful'
  end
end