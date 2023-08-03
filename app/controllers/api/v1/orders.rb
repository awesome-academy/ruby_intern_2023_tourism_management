module API
  module V1
    class Orders < Grape::API
      include API::V1::Defaults
      helpers Grape::Pagy::Helpers

      before do
        authenticate_user!
      end

      authorize_routes!
      resource :orders do
        desc "Get orders"
        params do
          optional :user_id, type: Integer, desc: "User id"
          use :pagy,
              page_param: :page,
              items_param: :per_page,
              items: 10,
              max_items: 50
        end
        get "", authorize: [:read, Order] do
          if params[:user_id]
            @user = User.find params[:user_id]
            raise ::CanCan::AccessDenied unless @user == @current_user

            @orders = pagy @user.orders.newest
          else
            @orders = pagy Order.newest
          end
          present({code: 200, orders: present(@orders, with: Entities::Order)})
        end
      end
    end
  end
end
