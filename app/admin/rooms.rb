ActiveAdmin.register Room do
  permit_params :name, :group_id, :private

  index do
    selectable_column
    id_column
    column :name
    column :group
    column :private
    actions
  end

  filter :name
  filter :group

  form do |f|
    f.inputs "Room Details" do
      f.input :name
      f.input :group, as: :select, collection: Group.all
      f.input :private
    end
    f.actions
  end
end
