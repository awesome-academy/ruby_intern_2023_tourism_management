require "rails_helper"
require_relative "../shared_examples/object_example_spec"

RSpec.describe UsersController, type: :controller do
  include_examples "object constructor"

  describe "GET #show" do
    it "render show template" do
      user.confirm
      sign_in user
      get :show, params: { id: user.id }
      expect(response).to render_template(:show)
    end

    it "flash when user not found" do
      user.confirm
      sign_in user
      get :show, params: { id: -1 }
      expect(flash[:danger]).to eq I18n.t("users.flash.user_not_found")
    end

    context "when not login" do
      before do
        get :show, params: { id: user.id }
      end
      it_behaves_like "handle not log in"
    end
  end
end
