require "rails_helper"
include SessionsHelper
require_relative "../shared_examples/object_example_spec"

RSpec.describe OrdersController, type: :controller do
  include_examples "object constructor"
  describe "GET #index" do
    context "when log in" do
      before do
        log_in user
      end

      it "render index template" do
        get :index, params: { user_id: user.id }
        expect(response).to render_template(:index)
      end
    end
    context "when not log in" do
      before do
        log_out if logged_in?
        get :index, params: { user_id: user.id }
      end
      it_behaves_like "handle not log in"
    end
  end

  describe "GET #new" do
    context "when Start date is before Today" do
      before do
        log_in user
        tour.start_date = Date.today
        tour.save!
        tour_selected tour
      end

      it "flash tour ended" do
        get :new
        expect(flash[:danger]).to eq I18n.t("orders.flash.tour_ended")
      end
    end
    context "when valid to create" do
      before do
        tour.reload
        log_in user
        tour_selected tour
      end

      it "render new order template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    context "when not login" do
      before do
        log_out if logged_in?
        post :create
      end

      it_behaves_like "handle not log in"
    end
    context "when login" do
      before do
        log_in user
        tour_selected tour
      end

      it "flash success create" do
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
        expect(flash[:success]).to eq I18n.t("orders.flash.create_order_success")
      end

      it "flash not current tour" do
        session[:tour_id] = -1
        post :create
        expect(flash[:danger]).to eq I18n.t("orders.flash.cant_find_current_tour")
      end

      it "flash tour start date before today" do
        tour.start_date = Date.today
        tour.save!
        tour_selected tour
        post :create
        expect(flash[:danger]).to eq I18n.t("orders.flash.tour_ended")
      end

      it "flash failed if order create failed" do
        allow_any_instance_of(Order).to receive(:save).and_return(false)
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
        expect(flash[:danger]).to eq I18n.t("orders.flash.create_order_failed")
      end
    end
  end

  describe "PUT #update" do
    context "when not login" do
      before do
        log_out if logged_in?
        put :update, params:{id: order.id, order:{status: Order.statuses[:cancelled]}}
      end

      it_behaves_like "handle not log in"
    end
    context "when login" do
      before do
        log_in user
      end

      it "flash success cancelled" do
        put :update, params:{id: order.id, order:{status: Order.statuses[:cancelled]}}
        expect(flash[:success]).to eq I18n.t("orders.flash.cancel_order_success")
      end

      it "flash order not found" do
        put :update, params:{id: -1, order:{status: Order.statuses[:cancelled]}}
        expect(flash[:danger]).to eq I18n.t("orders.flash.cant_find_order")
      end

      it "flash order not pending" do
        order.update! status: Order.statuses[:approved]
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
