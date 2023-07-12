require "rails_helper"
require_relative "../shared_examples/object_example_spec"

RSpec.describe Tour, type: :model do
  include_examples "object constructor"

  describe "#filter_by_text" do
    it "filter by text" do
      expect(Tour.filter_by_text(tour.name)).to eq([tour])
    end
  end

  describe "#filter_by_category" do
    it "filter by category" do
      tours
      expect(Tour.filter_by_category(Category.first.id)).to eq(Category.first.tours)
    end
  end

  describe "#compare_date" do
    it "error when start date after end date" do
      tour.start_date = tour.end_date + 1.day
      tour.compare_date
      expect(tour.errors[:end_date]).to include(I18n.t("tours.compare_date"))
    end

    it "error when start date before today" do
      tour.start_date = Date.today - 1.day
      tour.compare_date
      expect(tour.errors[:start_date]).to include(I18n.t("tours.before_today"))
    end

    it "error when end date before today" do
      tour.end_date = Date.today - 1.day
      tour.compare_date
      expect(tour.errors[:end_date]).to include(I18n.t("tours.before_today"))
    end
  end

  describe "#display_image" do
    it "resize to limit image size" do
      limit = Array.new(Settings.limit_image_area)
      expect(tour.image).to receive(:variant).with(resize_to_limit: limit)
      tour.display_image
    end
  end
end
