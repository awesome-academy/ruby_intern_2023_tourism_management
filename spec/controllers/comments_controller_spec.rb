require "rails_helper"
require_relative "../shared_examples/object_example_spec"

RSpec.describe CommentsController, type: :controller do
  include_examples "object constructor"

  let(:post_comment){
    post :create, params:{
      comment:{
        review: "Tour rat tuyet voi",
        rate: 5,
        user_id: user.id,
        order_id: order.id,
        tour_id: order.tour_id
      }
    }
  }

  describe "POST #create" do
    context "when not login" do
      before do
        post_comment
      end

      it_behaves_like "handle not log in"
    end

    describe "when log in" do
      before do
        user.confirm
        sign_in user
      end
      context "when comment success" do
        before do
          post_comment
        end

        it "flash" do
          expect(flash[:success]).to eq I18n.t("comments.flash.comment_success")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when comment failed" do
        before do
          post :create, params:{
            comment:{
              review: "",
              rate: "",
              user_id: user.id,
              order_id: order.id,
              tour_id: order.tour_id
            }
          }
        end

        it "flash" do
          expect(flash[:danger]).to eq I18n.t("comments.flash.both_blank")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when comment success" do
        before do
          post_comment
        end

        it "flash" do
          expect(flash[:success]).to eq I18n.t("comments.flash.comment_success")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when update success" do
        before do
          put :update, params:{id: comment.id, comment:{review: "Comment da thay doi", rate: "1"}}
        end

        it "flash" do
          expect(flash[:success]).to eq I18n.t("comments.flash.update_success")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when update failed" do
        before do
          put :update, params:{id: comment.id, comment:{review: "abc", rate: "1"}}
        end

        it "flash" do
          expect(flash[:danger]).to eq I18n.t("comments.flash.review_too_short")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when destroy success" do
        before do
          delete :destroy, params:{id: comment.id}
        end

        it "flash" do
          expect(flash[:success]).to eq I18n.t("comments.flash.delete_success")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when destroy failed" do
        before do
          allow_any_instance_of(Comment).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
          delete :destroy, params:{id: comment.id}
        end

        it "flash" do
          expect(flash[:danger]).to eq I18n.t("comments.flash.delete_failed")
        end

        it_behaves_like "handle orders history redirect"
      end

      context "when comment not found" do
        before do
          comment_id = comment.id
          comment.destroy!
          delete :destroy, params:{id: comment_id}
        end

        it "flash" do
          expect(flash[:danger]).to eq I18n.t("comments.flash.comment_not_found")
        end

        it_behaves_like "handle orders history redirect"
      end
    end
  end
end
