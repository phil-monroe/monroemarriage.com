ActiveAdmin.register Person do
  permit_params :first_name, :last_name, :attending
  config.sort_order = 'last_name_asc,first_name_asc'
  index do
    selectable_column
    column :name do |person|
      link_to person.name, admin_person_path(person)
    end
    column(:household) do |p|
      link_to p.household.name, admin_household_path(p.household)
    end
    column :attending


    actions
  end


  member_action :toggle_boolean do
    field = params[:field].to_sym

    resource.update_attribute field, !resource.send(field)

    redirect_to :back
  end
end
