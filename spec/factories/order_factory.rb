require "faker"

FactoryBot.define do
  factory :category do
    name { Faker::Address.unique.full_address }
    description { Faker::Lorem.sentence }
    duration { Faker::Number.between(from: 1, to: 10) }
  end

  factory :tour do
    name {Faker::Address.unique.full_address}
    description {Faker::Lorem.sentence}
    start_date {Faker::Date.between(from: Date.tomorrow, to: Date.tomorrow + 5.day)}
    end_date {Faker::Date.between(from: start_date, to: start_date + 5.day)}
    cost {200000}
    visit_location {Faker::Address.full_address}
    start_location {Faker::Address.full_address}
    content {"<div>Lich Trinh</div>"}
    tour_guide_cost {100000}
    association :category
    image do
      {
        io: URI.open("https://hinhanhonline.com/Images/Album/DulichVietNam/vinh-ha-long-01.jpg"),
        filename: "image_1.jpg",
        content_type: "image/jpeg"
      }
    end
  end

  factory :user do
    phone {Faker::PhoneNumber.phone_number}
    email {Faker::Internet.unique.email}
    address {Faker::Address.full_address}
    password {"123456"}
    password_confirmation {"123456"}
    name {Faker::Name.last_name}
    role {"user"}
  end

  factory :order do
    association :tour
    association :user
    contact_name {Faker::Name.name}
    contact_phone {Faker::PhoneNumber.phone_number}
    contact_address {Faker::Address.full_address}
    amount_member {Faker::Number.between(from: 1, to: 10)}
    note {Faker::Lorem.sentence}
    tour_guide {Faker::Number.between(from: 0, to: 1)}
    total_cost {"8150000"}
  end
end
