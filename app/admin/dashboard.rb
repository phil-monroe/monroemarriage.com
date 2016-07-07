ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    columns do
      column span: 1 do
        panel "Households" do
          counts = OpenStruct.new({
            :Invited             => Household.count,
            :Responded           => Household.have_responded.count,
            :Not_Responded       => Household.have_not_responded.count,
            :Should_Contact      => Household.need_to_contact.count
          })

          para do
            attributes_table_for counts do
              row :Invited
              row :Responded
              row :Not_Responded
              row :Should_Contact
            end
          end

          para do
            pie_chart(counts.to_h.slice(:Responded, :Not_Responded))
          end
        end
      end

      column span: 4 do
        panel "People" do
          counts = OpenStruct.new({
            :Invited             => Person.count,
            :Attending_Wedding   => Person.invited_to_wedding.attending.count,
            :Attending_Reception => Person.attending.count,
            :Drinking_Alcohol    => Person.attending.drinkers.count,
          })

          para do
            attributes_table_for counts do
              row :Invited
              row :Attending_Wedding
              row :Attending_Reception
              row :Drinking_Alcohol
            end
          end

          para do
            bar_chart(counts.to_h)
          end
        end

      end
    end
  end
end
