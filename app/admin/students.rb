ActiveAdmin.register Student do
  permit_params :first_name, :last_name, :email, :phone_number, :education_level, :country, :address, :parent_phone_number, :profile_picture_url

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
    f.inputs "Student Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone_number
      f.input :education_level
      f.input :address
      f.input :parent_phone_number
      f.input :profile_picture_url, as: :file
    end
    f.actions
  end

  def destroy
    student = Student.find(params[:id])
    # Delete all associated participants
    student.participants.destroy_all
    student.destroy
    redirect_to admin_students_path, notice: 'Student was successfully deleted.'
  end
  
end
