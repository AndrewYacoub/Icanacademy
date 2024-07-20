class AddGoogleFormIdToHomeworks < ActiveRecord::Migration[7.1]
  def change
    add_column :homeworks, :google_form_id, :string
    add_column :homeworks, :google_form_link, :string
  end
end
