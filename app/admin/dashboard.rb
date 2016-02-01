ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    columns span: 3 do
      column do
        panel "Info" do
          attributes_table_for 1 do
            row("# Households")                 { Household.count }
            row("# People")                     { Person.count }
            row("# People Attending Wedding")   { Person.attending_wedding.count }
            row("# People Attending Reception") { Person.attending_reception.count }
          end
        end
      end
      column
      column
    end
  end
end
