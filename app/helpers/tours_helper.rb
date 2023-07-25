module ToursHelper
  def tour_ordered?
    current_user&.orders&.exists?(tour_id: session[:tour_id])
  end

  def is_current_user_comment? comment
    current_user && current_user.id == comment.user.id
  end
end
