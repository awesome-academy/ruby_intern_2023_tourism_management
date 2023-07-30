require_relative "../../services/tour_service"

module API
  module V1
    class Tours < Grape::API
      include API::V1::Defaults
      helpers Grape::Pagy::Helpers

      helpers do
        def build_seach_params
          seach_option = {
            "tour_cont": params[:search_text],
            "cost_gteq": params[:cost_gteq],
            "cost_lteq": params[:cost_lteq],
            "category_id_eq": params[:category_id_eq]
          }
          q = TourService.load_paging_tour seach_option
          pagy q.result
        end
      end

      resource :tours do
        desc "Return tours"
        params do
          optional :search_text, type: String, desc: "Search text"
          optional :cost_gteq, type: Integer, desc: "Cost greater than or equal to"
          optional :cost_lteq, type: Integer, desc: "Cost less than or equal to"
          optional :category_id_eq, type: Integer, desc: "Category equal to"
          use :pagy,
              page_param: :page,
              items_param: :per_page,
              items: 10,
              max_items: 50
        end
        get "", root: :tours do
          tours = build_seach_params
          if tours.present?
            present({code: 200, tours: present(tours, with: Entities::TourList)})
          else
            api_error!("Can't paginate tours", 404)
          end
        end
      end

      resource :tours do
        desc "Return a tour"
        params do
          requires :id, type: String, desc: "Tour id"
        end
        get "/:id", root: :tour do
          tour = TourService.find_tour_by_id params[:id]
          if tour
            present({code: 200, tour: present(tour, with: Entities::Tour)})
          else
            api_error!("Tour not found", 404)
          end
        end
      end
    end
  end
end
