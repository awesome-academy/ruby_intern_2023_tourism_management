require "faker"

FactoryBot.define do
  factory :category do
    name {"Category 1"}
    description {"Description 1"}
    duration {2}
  end

  factory :tour do
    name {Faker::Address.unique.full_address}
    description {"Description tour 1"}
    start_date {Date.tomorrow}
    end_date {Date.tomorrow}
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
    amount_member {"2"}
    note {"Ghi chu"}
    tour_guide {"1"}
    total_cost {"8150000"}
  end
end
