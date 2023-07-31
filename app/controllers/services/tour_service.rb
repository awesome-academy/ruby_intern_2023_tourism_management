class TourService
  def self.find_tour_by_id id
    Tour.includes(comments: :user, options: [:rich_text_option_content]).find_by(id: id)
  end

  def self.load_paging_tour search_params
    q = Tour.includes(:category, {image_attachment: :blob}).ransack(search_params)
    q.sorts = ["updated_at desc", "name asc"] if q.sorts.empty?
    q
  end
end
