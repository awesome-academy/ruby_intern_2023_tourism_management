RSpec.shared_examples "handle not log in" do
  it "flash not log in" do
    expect(flash[:danger]).to eq I18n.t("application.not_permit_action")
  end
end

RSpec.shared_examples "object constructor" do
  let(:category) { create(:category) }
  let(:tour) { create(:tour) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:order) { create(:order) }
  let(:tours) {
    5.times do
      create(:tour)
    end
    return Tour.all
  }
  let(:categories) {
    5.times do
      create(:category)
    end
    return Category.all
  }
end

RSpec.shared_examples "handle render index" do
  context "when not login" do
    before do
      get :index
    end

    it "flash login required" do
      expect(flash[:danger]).to eq I18n.t("admin.login_required")
    end

    it "redirect to login path" do
      expect(response).to redirect_to login_path
    end
  end

  context "when admin log in" do
    before do
      admin.confirm
      sign_in admin
      get :index
    end

    it "render index template" do
      expect(response).to render_template(:index)
    end
  end

  context "when user log in" do
    before do
      user.confirm
      sign_in user
      get :index
    end

    it "flash admin unauthorized" do
      expect(flash[:danger]).to eq I18n.t("admin.unauthorized")
    end

    it "redirect to login path" do
      expect(response).to redirect_to login_path
    end
  end
end

RSpec.shared_examples "handle admin orders redirect" do
  it "redirect to admin orders" do
    expect(response).to redirect_to admin_orders_path
  end
end

RSpec.shared_examples "handle admin tours redirect" do
  it "redirect to admin tours" do
    expect(response).to redirect_to admin_tours_path
  end
end
