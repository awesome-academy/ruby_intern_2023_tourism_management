require "open-uri"
5.times do |i|
  name = "Category number abc #{i+1}"
  description = "Description for category #{i+1}"
  duration = i + 2
  Category.create!(
    name: name,
    description: description,
    duration: duration
  )
end

categories = Category.all
urls = [
  "https://hinhanhonline.com/Images/Album/DulichVietNam/vinh-ha-long-01.jpg",
  "https://hinhanhonline.com/Images/Album/DulichVietNam/du-lich-ha-noi-01.jpg",
  "https://toplist.vn/images/800px/dao-phu-quoc-15999.jpg",
  "https://znews-photo.zingcdn.me/w660/Uploaded/jaroin/2017_03_10/hoi_an.jpg",
  "https://dulichtheomua.com/wp-content/uploads/2021/11/thac-ban-gioc-hung-vi.jpg"
]
categories.each do |category|
  5.times do |i|
    tour = Tour.new
    tour.name = "Tour number abc #{i+1}"
    tour.description = "Description for tour #{i+1}"
    tour.start_date = Date.today
    tour.end_date = Date.today + i + 2
    tour.cost = 123546
    tour.visit_location = "Visit location for #{i + 1}"
    tour.start_location = "Start location for #{i + 1}"
    tour.schedule = {
      day1: {
        name: "Day 1",
        activities: ["Activity 1", "Activity 2"]
      },
      day2: {
        name: "Day 2",
        activities: ["Activity 3", "Activity 4"]
      }
    }
    tour.category_id = category.id

    image_data = URI.open(urls[i])
    tour.image.attach(io: image_data, filename: "image#{i}.jpg", content_type: "image/jpeg")
    tour.save!
  end
end
# User.create!(
#   phone: "0123456789",
#   email: "test123@test.com",
#   password: "123456",
#   password_confirmation: "123456",
#   name: "Test",
#   role: "user",
# )
