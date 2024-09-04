ActiveAdmin.register Course do
  permit_params :title, :description, :start_date, :end_date, :teacher_id

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :start_date
    column :end_date
    column :teacher
    actions
  end

  filter :title
  filter :teacher

  form do |f|
    f.inputs "Course Details" do
      f.input :title
      f.input :description
      f.input :teacher, as: :select, collection: Teacher.all
    end
    f.actions
  end
end
