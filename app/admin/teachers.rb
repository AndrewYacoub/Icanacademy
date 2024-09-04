ActiveAdmin.register Teacher do
  permit_params :first_name, :last_name, :email, :phone_number, :education_level, :country, :address, :teaching, :profile_picture_url

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :phone_number
    actions
  end

  filter :first_name
  filter :last_name
  filter :email

  form do |f|
    f.inputs "Teacher Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone_number
      f.input :education_level
      f.input :address
      f.input :teaching
      f.input :profile_picture_url, as: :file
    end
    f.actions
  end
end
