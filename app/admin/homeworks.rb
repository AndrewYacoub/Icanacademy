ActiveAdmin.register Homework do
  permit_params :title, :description, :group_id, :google_form_id

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :group
    column :google_form_id
    actions
  end

  filter :title
  filter :group

  form do |f|
    f.inputs "Homework Details" do
      f.input :title
      f.input :description
      f.input :group, as: :select, collection: Group.all
      f.input :google_form_id
    end
    f.actions
  end
end
