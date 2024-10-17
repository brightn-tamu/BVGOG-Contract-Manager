# frozen_string_literal: true

# Vendor Factory

FactoryBot.define do
    factory :vendor do
        name { "#{Faker::Company.name} #{Faker::Company.suffix}" }
    end
end
