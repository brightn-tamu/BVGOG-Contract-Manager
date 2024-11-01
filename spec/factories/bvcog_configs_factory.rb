# frozen_string_literal: true

# BvcogConfig Factory

FactoryBot.define do
  factory :bvcog_config do
    contracts_path { "#{Faker::File.dir}"}
    reports_path { "#{Faker::File.dir}" }
  end
end
