ActiveAdmin.register Household do
  permit_params :name, :email, :phone, :address_1, :address_2, :city, :state, :zipcode, :has_responded, :reception_only, :rsvp_code, people_attributes: [:id, :first_name, :last_name, :position, :_destroy]

  config.sort_order = 'id_asc'

  scope :all
  scope :reception_only
  scope :with_attendees

  index do
    selectable_column
    column :name do |household|
      link_to household.name, admin_household_path(household)
    end
    column 'Members' do |household|
      household.people.count
    end
    column 'Attending Members' do |household|
      household.people.where(attending: true).count
    end

    column :email
    column :phone
    column :rsvp_code

    actions
    # column "My Custom Title", :title
  end



  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Contact" do
      f.input :name
      f.input :email
      f.input :phone
    end

    f.inputs "Wedding Details" do
      f.input :rsvp_code
      f.input :reception_only
    end

    f.inputs "Address" do
      f.input :address_1
      f.input :address_2
      f.input :city
      f.input :state
      f.input :zipcode
    end

    f.inputs "Members" do
      f.has_many :people, sortable: :position, allow_destroy: true  do |t|
        t.input :first_name
        t.input :last_name
      end
    end

    f.submit
  end

  show do
    columns do
      column do
        panel "Contact" do
          attributes_table_for household do
            row :name
            row :email
            row :phone
          end
        end
        panel "Address" do
          attributes_table_for household do
            row :address_1
            row :address_2
            row :city
            row :state
            row :zipcode
          end
        end
      end
      column do
        panel "Wedding Details" do
          attributes_table_for household do
            row :rsvp_code
            row :reception_only
          end
        end

        panel "Members" do
          table_for household.people do
            column :name
            column :attending
          end
        end
      end
    end


    active_admin_comments
  end
end