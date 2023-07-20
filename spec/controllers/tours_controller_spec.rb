require "rails_helper"
require_relative "../shared_examples/object_example_spec"

RSpec.describe ToursController, type: :controller do
  include_examples "object constructor"

  describe "GET #index" do
    it "render index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "render show template" do
      get :show, params: { id: tour.id }
      expect(response).to render_template(:show)
    end

    it "flash when tour not found" do
      get :show, params: { id: -1 }
      expect(flash[:danger]).to eq I18n.t("tours.not_found")
    end
  end
end
