ActiveAdmin.register Household do
  permit_params :name, :email, :phone, :address_1, :address_2, :city, :state, :zipcode, :has_responded, :reception_only, :rsvp_code, people_attributes: [:id, :first_name, :last_name, :position, :_destroy]

  config.sort_order = 'id_asc'

  scope :all
  scope :wedding
  scope :reception_only
  scope :with_attendees
  scope :have_responded
  scope :have_not_responded
  scope :need_to_contact
  scope :physical_invite
  scope :attending_wedding

  index do
    selectable_column
    column :name do |household|
      link_to household.name, admin_household_path(household)
    end
    column "People" do |household|
      household.people.map(&:first_name).to_sentence
    end
    column 'Attending Members' do |household|
      household.people.where(attending: true).count
    end
    column(:wedding) { |household| status_tag(!household.reception_only) }
    column(:physical_invite)
    column "Responded" do |household|
      if household.logged_in_at.present?
        status_tag "Yes"
      else
        status_tag "No"
      end
    end

    column "Address" do |household|
      present = [household.address_1, household.address_2, household.city, household.state, household.zipcode].any?(&:present?)
      tag = present ? "Yes" : "No"
      status_tag tag
    end


    column :email
    column :phone
    column :rsvp_code

    actions
  end

  csv do
    column "tmp" do |house|
      house.people.map(&:first_name).join(", ")
    end

    column "Name" do |house|
      people = house.people.to_a
      if house.people.size > 2
        house.name

      elsif people.size == 2
        a, b = people

        if a.last_name == b.last_name
          "#{a.first_name} and #{b.name}"
        else
          "#{a.name} and #{b.name}"
        end

      elsif people.size == 1
        people[0].name
      end
    end

    column "Street Address 1" do |house|
      house.address_1
    end

    column "Street Address 2 (Optional)" do |house|
      house.address_2
    end

    column "City" do |house|
      house.city
    end

    column "State/Region" do |house|
      house.state
    end

    column "Country" do |house|
      "USA"
    end

    column "Zip/Postal code" do |house|
      house.zipcode
    end

    column "Email (Optional)" do |house|
      house.email
    end
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

            def toggle_boolean household, method
              value = household.send(method)
              toggle_path = toggle_boolean_admin_household_path(household, boolean: method)
              if value.present?
                link_to(content_tag(:span, "Yes", class: "status_tag yes"), toggle_path)
              else
                link_to(content_tag(:span, "No", class: "status_tag no"), toggle_path)
              end.html_safe
            end


            def toggle_timestamp household, method
              timestamp = household.send(method)
              toggle_path = toggle_timestamp_admin_household_path(household, timestamp: method)
              if timestamp.present?
                link_to(content_tag(:span, "Yes", class: "status_tag yes"), toggle_path) + " "+ I18n.l(timestamp, format: :long)
              else
                link_to(content_tag(:span, "No", class: "status_tag no"), toggle_path)
              end.html_safe
            end

            row :rsvp_code
            row :reception_only do
              toggle_boolean household, :reception_only
            end

            row :physical_invite do
              toggle_boolean household, :physical_invite
            end

            row "Responded" do |household|
              toggle_timestamp household, :logged_in_at
            end
            row :save_the_date_email_sent do |household|
              toggle_timestamp household, :save_the_date_email_sent_at
            end
            row :save_the_date_paper_sent do |household|
              toggle_timestamp household, :save_the_date_paper_sent_at
            end
            row :invite_email_sent do |household|
              toggle_timestamp household, :invite_email_sent_at
            end
            row :invite_paper_sent do |household|
              toggle_timestamp household, :invite_paper_sent_at
            end
          end
        end

        panel "Members" do
          table_for household.people do
            column :name
            column :attending do |person|
              label = person.attending ? "yes" : "no"
              link_to(content_tag(:span, label, class: [:status_tag, label]), toggle_boolean_admin_person_path(person, field: :attending))
            end

            column :alcohol do |person|
              label = person.drinks_alcohol ? "yes" : "no"
              link_to(content_tag(:span, label, class: [:status_tag, label]), toggle_boolean_admin_person_path(person, field: :drinks_alcohol))
            end

          end
        end
      end

    end


    active_admin_comments
  end

  member_action :toggle_timestamp do
    timestamp = params[:timestamp].to_sym

    if resource.send(timestamp).present?
      resource.update_attributes!(timestamp => nil)
    else
      resource.update_attributes!(timestamp => Time.current)
    end

    redirect_to :back
  end

  member_action :toggle_boolean do
    method = params[:boolean].to_sym

    if resource.send(method).present?
      resource.update_attributes!(method => false)
    else
      resource.update_attributes!(method => true)
    end

    redirect_to :back
  end
end