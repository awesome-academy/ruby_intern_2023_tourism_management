module ApplicationHelper
  include Pagy::Frontend
  include Devise::Controllers::Helpers
  def full_title page_title
    base_title = t "application.base_title"
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end

  def admin_login?
    current_user&.admin?
  end
end
