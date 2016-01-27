ActiveAdmin.register_page "Dashboard" do

  menu priority: 3, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    render partial: 'devise/menu/login_items'
  end


end
