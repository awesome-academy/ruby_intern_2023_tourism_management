RSpec.shared_examples "handle not log in" do
  it "flash not log in" do
    expect(flash[:danger]).to eq I18n.t("orders.flash.not_logged_in")
  end

  it "redirect to login" do
    expect(response).to redirect_to login_path
  end
end

RSpec.shared_examples "object constructor" do
  let(:tour) { create(:tour) }
  let(:user) { create(:user) }
  let(:order) { create(:order) }
end
