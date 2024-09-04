ActiveAdmin.register Message do
  permit_params :content, :user_id, :room_id

  index do
    selectable_column
    id_column
    column :content
    column :user
    column :room
    column :created_at
    actions
  end

  filter :user
  filter :room

  form do |f|
    f.inputs "Message Details" do
      f.input :content
      f.input :user, as: :select, collection: User.all
      f.input :room, as: :select, collection: Room.all
    end
    f.actions
  end
end
