require "rails_helper"
require_relative "../../shared_examples/object_example_spec"

RSpec.describe Admin::OrdersController, type: :controller do
  include_examples "object constructor"

  describe "GET #index" do
    it_behaves_like "handle render index"
  end

  describe "PUT #update" do
    before do
      admin.confirm
      sign_in admin
    end

    context "when update success" do
      before do
        put :update, params:{id: order.id, order:{status: Order.statuses[:approved]}}
      end

      it "flash" do
        expect(flash[:success]).to eq I18n.t("admin.orders.flash.update_order_success")
      end

      it_behaves_like "handle admin orders redirect"
    end

    context "when order not found" do
      before do
        put :update, params:{id: -1, order:{status: Order.statuses[:cancelled]}}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("orders.flash.cant_find_order")
      end

      it_behaves_like "handle admin orders redirect"
    end

    context "when order not pending" do
      before do
        order.cancelled!
        put :update, params:{id: order.id, order:{status: Order.statuses[:approved]}}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.orders.flash.order_status_changed")
      end

      it_behaves_like "handle admin orders redirect"
    end

    context "when update failed" do
      before do
        allow_any_instance_of(Order).to receive(:update).and_return(false)
        put :update, params:{id: order.id, order:{status: Order.statuses[:cancelled]}}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.orders.flash.cant_update_order")
      end

      it_behaves_like "handle admin orders redirect"
    end
  end
end
