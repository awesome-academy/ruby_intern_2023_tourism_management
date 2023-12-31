require "rails_helper"
require_relative "../shared_examples/object_example_spec"

RSpec.describe OrdersController, type: :controller do
  include_examples "object constructor"

  let(:post_order){
    post :create, params:{
      order:{
        contact_name: "Nguyen Duc Huy",
        contact_phone: "0975222888",
        contact_address: "133 Xuan Thuy",
        amount_member: "2",
        note: "Ghi chu",
        tour_guide: "1",
        total_cost: "150000"
      }
    }
  }

  let(:create_exist_order){
    Order.create!(
      contact_name: "Nguyen Duc Huy",
      contact_phone: "0975222888",
      contact_address: "133 Xuan Thuy",
      amount_member: "2",
      note: "Ghi chu",
      tour_guide: "1",
      total_cost: "150000",
      tour_id: session[:tour_id],
      user_id: user.id
    )
  }

  describe "GET #index" do
    context "when log in" do
      before do
        user.confirm
        sign_in user
      end

      it "render index template" do
        get :index, params: { user_id: user.id }
        expect(response).to render_template(:index)
      end
    end
    context "when not log in" do
      before do
        get :index, params: { user_id: user.id }
      end
      it_behaves_like "handle not log in"
    end
  end

  describe "GET #new" do
    context "when Start date is before Today" do
      before do
        user.confirm
        sign_in user
        tour.start_date = Time.zone.today
        tour.save!
        session[:tour_id] = tour.id
      end

      it "flash tour ended" do
        get :new
        expect(flash[:danger]).to eq I18n.t("orders.flash.tour_ended")
      end
    end
    context "when valid to create" do
      before do
        tour.reload
        user.confirm
        sign_in user
        session[:tour_id] = tour.id
      end

      it "render new order template" do
        get :new
        expect(response).to render_template(:new)
      end

      describe "when order existed" do
        before do
          create_exist_order
          get :new
        end

        it "flash" do
          expect(flash[:danger]).to eq I18n.t("orders.flash.order_existed")
        end

        it "redirect to root" do
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "POST #create" do
    context "when not login" do
      before do
        post_order
      end

      it_behaves_like "handle not log in"
    end
    context "when login" do
      before do
        user.confirm
        sign_in user
        session[:tour_id] = tour.id
      end

      it "flash success create" do
        post_order
        expect(flash[:success]).to eq I18n.t("orders.flash.create_order_success")
      end

      it "flash not current tour" do
        session[:tour_id] = -1
        post_order
        expect(flash[:danger]).to eq I18n.t("orders.flash.cant_find_current_tour")
      end

      it "flash tour start date before today" do
        tour.start_date = Time.zone.today
        tour.save!
        session[:tour_id] = tour.id
        post_order
        expect(flash[:danger]).to eq I18n.t("orders.flash.tour_ended")
      end

      it "flash failed if order create failed" do
        allow_any_instance_of(Order).to receive(:save).and_return(false)
        post_order
        expect(flash[:danger]).to eq I18n.t("orders.flash.create_order_failed")
      end

      describe "when order existed" do
        before do
          create_exist_order
          post_order
        end

        it "flash" do
          expect(flash[:danger]).to eq I18n.t("orders.flash.order_existed")
        end

        it "redirect to root" do
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "PUT #update" do
    context "when not login" do
      before do
        put :update, params:{id: order.id, order:{status: Order.statuses[:cancelled]}}
      end

      it_behaves_like "handle not log in"
    end
    context "when login" do
      before do
        user.confirm
        sign_in user
      end

      it "flash success cancelled" do
        put :update, params:{id: order.id, status: Order.statuses[:cancelled]}
        expect(flash[:success]).to eq I18n.t("orders.flash.cancel_order_success")
      end

      it "flash order not found" do
        put :update, params:{id: -1, order:{status: Order.statuses[:cancelled]}}
        expect(flash[:danger]).to eq I18n.t("orders.flash.cant_find_order")
      end

      it "flash order not pending" do
        order.approved!
        put :update, params:{id: order.id, order:{status: Order.statuses[:cancelled]}}
        expect(flash[:danger]).to eq I18n.t("admin.orders.flash.order_status_changed")
      end

      it "flash failed update if order update failed" do
        allow_any_instance_of(Order).to receive(:update).and_return(false)
        put :update, params:{id: order.id, order:{status: Order.statuses[:cancelled]}}
        expect(flash[:danger]).to eq I18n.t("orders.flash.cant_cancelled_tour")
      end
    end
  end
end
