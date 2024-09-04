ActiveAdmin.register Session do
  permit_params :start_time, :end_time, :group_id, :google_meet_link

  index do
    selectable_column
    id_column
    column :group
    column :start_time
    column :end_time
    column :google_meet_link
    actions
  end

  filter :group
  filter :start_time

  form do |f|
    f.inputs "Session Details" do
      f.input :group, as: :select, collection: Group.all
      f.input :start_time, as: :datetime_picker
      f.input :end_time, as: :datetime_picker
      f.input :google_meet_link
    end
    f.actions
  end
end
