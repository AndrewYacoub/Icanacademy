ActiveAdmin.register Enrollment do
  permit_params :student_id, :group_id, :status

  index do
    selectable_column
    id_column
    column :student
    column :group
    column :status do |enrollment|
      status_tag enrollment.status
    end
    actions defaults: false do |enrollment|
      link_to 'Approve', approve_admin_enrollment_path(enrollment), method: :put if enrollment.status == 'pending_admin_approval'
    end       
    actions defaults: false do |enrollment|
      link_to 'Decline', decline_admin_enrollment_path(enrollment), method: :put if enrollment.status == 'pending_admin_approval'
    end
    
  end
  filter :student_id, as: :select, collection: -> { Student.all.pluck(:email, :id) }
  filter :group_id, as: :select, collection: -> { Group.all.pluck(:name, :id) }  
  filter :student
  filter :group
  filter :status, as: :select, collection: -> { Enrollment.distinct.pluck(:status) }

  form do |f|
    f.inputs "Enrollment Details" do
      f.input :student
      f.input :group
      f.input :status, as: :select, collection: Enrollment.distinct.pluck(:status)
    end
    f.actions
  end

  member_action :approve, method: :put do
    enrollment = Enrollment.find(params[:id])
    enrollment.update(status: 'pending_teacher_approval')
    redirect_to admin_enrollments_path, notice: "Enrollment approved."
  end

  member_action :decline, method: :put do
    enrollment = Enrollment.find(params[:id])
    enrollment.update(status: 'declined_by_admin') 
    redirect_to admin_enrollments_path, notice: "Enrollment declined."
  end

  action_item :approve, only: :show do
    link_to 'Approve', approve_admin_enrollment_path(resource), method: :put if resource.status == 'pending_admin_approval'
  end

  action_item :decline, only: :show do
    link_to 'Decline', decline_admin_enrollment_path(resource), method: :put if resource.status == 'pending_admin_approval'
  end

end
