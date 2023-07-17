require "rails_helper"
require_relative "../../shared_examples/object_example_spec"

RSpec.describe Admin::ToursController, type: :controller do
  include_examples "object constructor"

  let(:post_tour){
    post :create, params:{
      tour:{
        name: "Tour Washington DC Ameica",
        description: "It is the capital city of America",
        start_date: Date.tomorrow,
        end_date: Date.tomorrow + 3.days,
        cost: 4000000,
        visit_location: "Washington",
        start_location: "Ha Noi",
        content: "<div>Lich Trinh</div>",
        tour_guide_cost: 2000000,
        image: fixture_file_upload("images/left_arrow.png", "image/jpeg"),
        is_create_category: 0
      },
      category_id: category.id
    }
  }

  let(:post_tour_with_new_category){
    post :create, params:{
      tour:{
        name: "Tour Washington DC Ameica",
        description: "It is the capital city of America",
        start_date: Date.tomorrow,
        end_date: Date.tomorrow + 3.days,
        cost: 4000000,
        visit_location: "Washington",
        start_location: "Ha Noi",
        content: "<div>Lich Trinh</div>",
        tour_guide_cost: 2000000,
        image: fixture_file_upload("images/left_arrow.png", "image/jpeg"),
        is_create_category: 1,
        category_attributes: {
          name: "Category name 1",
          description: "Description of category 1",
          duration: 3
        }
      },
    }
  }

  describe "GET #index" do
    it_behaves_like "handle render index"
  end

  describe "GET #new" do
    before do
      admin.confirm
      sign_in admin
    end

    it "render new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    before do
      admin.confirm
      sign_in admin
    end

    context "when create success" do
      before do
        post_tour
      end

      it "flash" do
        expect(flash[:success]).to eq I18n.t("admin.tours.flash.created_tour_success")
      end

      it_behaves_like "handle admin tours redirect"
    end

    context "when create failed" do
      before do
        allow_any_instance_of(Tour).to receive(:save).and_return(false)
        post_tour
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.tours.flash.created_tour_failed")
      end

      it "render new" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "when params category not found" do
      before do
        post :create, params:{
          tour:{
            name: "Tour Washington DC Ameica",
            description: "It is the capital city of America",
            start_date: Date.tomorrow,
            end_date: Date.tomorrow + 3.days,
            cost: 4000000,
            visit_location: "Washington",
            start_location: "Ha Noi",
            content: "<div>Lich Trinh</div>",
            tour_guide_cost: 2000000,
            image: fixture_file_upload("images/left_arrow.png", "image/jpeg"),
            is_create_category: 0
          },
          category_id: -1
        }
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.tours.flash.category_not_found")
      end

      it "render new" do
        expect(response).to render_template(:new)
      end
    end

    it "should be new category when choose create category" do
      post_tour_with_new_category
      new_tour = Tour.find_by name: "Tour Washington DC Ameica"
      new_category = Category.find_by name: "Category name 1"
      expect(new_tour.category_id).to eq new_category.id
    end
  end

  describe "GET #edit" do
    before do
      admin.confirm
      sign_in admin
    end

    it "render edit template" do
      get :edit, params:{id: tour.id}
      expect(response).to render_template(:edit)
    end

    context "when start date before today" do
      before do
        tour.start_date = Date.today
        tour.save
        get :edit, params:{id: tour.id}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.tours.flash.cant_edit_tour")
      end

      it_behaves_like "handle admin tours redirect"
    end

    context "when tour not found" do
      before do
        get :edit, params:{id: -1}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.tours.flash.tour_not_found")
      end

      it_behaves_like "handle admin tours redirect"
    end
  end

  describe "PUT #update" do
    before do
      admin.confirm
      sign_in admin
    end

    context "when update success" do
      before do
        put :update, params:{id: tour.id, tour: {name: "Tour Tam Dao Vinh Phuc"}, category_id: categories.first.id}
      end

      it "flash" do
        expect(flash[:success]).to eq I18n.t("admin.tours.flash.updated_tour_success")
      end

      it_behaves_like "handle admin tours redirect"
    end

    context "when category not found" do
      before do
        put :update, params:{id: tour.id, tour: {name: "Tour Tam Dao Vinh Phuc"}, category_id: -1}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.tours.flash.category_not_found")
      end

      it_behaves_like "handle admin tours redirect"
    end

    context "when update failed" do
      before do
        allow_any_instance_of(Tour).to receive(:update).and_return(false)
        put :update, params:{id: tour.id, tour: {name: "Tour Tam Dao Vinh Phuc"}, category_id: category.id}
      end

      it "flash" do
        expect(flash[:danger]).to eq I18n.t("admin.tours.flash.updated_tour_failed")
      end

      it "render edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
