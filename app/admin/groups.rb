ActiveAdmin.register Group do
  permit_params :name, :course_id, :start_date, :end_date, :creator_id

  index do
    selectable_column
    id_column
    column :name
    column :course
    column :start_date
    column :end_date
    column :creator
    actions
  end

  filter :name
  filter :course

  form do |f|
    f.inputs "Group Details" do
      f.input :name
      f.input :course, as: :select, collection: Course.all
      f.input :start_date, as: :datepicker
      f.input :end_date, as: :datepicker
    end
    f.actions
  end
end
