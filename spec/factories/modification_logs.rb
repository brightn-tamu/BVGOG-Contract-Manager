# frozen_string_literal: true

FactoryBot.define do
    factory :modification_log do
		contract
		status { 'pending' }
		modification_type { 'amend' }
		modified_by { association :user }

		transient do
			old_number { Faker::Alphanumeric.alphanumeric(number: 10) }
			new_number { Faker::Alphanumeric.alphanumeric(number: 10) }
			old_starts_at { Faker::Date.between(from: 2.years.ago, to: Time.zone.today).to_s }
			new_starts_at { Faker::Date.between(from: 2.years.ago, to: Time.zone.today).to_s }
			old_ends_at { Faker::Date.between(from: 20.years.from_now, to: 30.years.from_now).to_s }
			new_ends_at { Faker::Date.between(from: 20.years.from_now, to: 30.years.from_now).to_s }
			old_total_amount { Faker::Number.between(from: 0, to: 99_000_000).to_s }
			new_total_amount { Faker::Number.between(from: 0, to: 99_000_000).to_s }
			old_description { Faker::Lorem.paragraph(sentence_count: 15) }
			new_description { Faker::Lorem.paragraph(sentence_count: 15) }
		end

		changes_made {
			{
				'number' => [old_number, new_number],
				'starts_at' => [old_starts_at, new_starts_at],
				'ends_at' => [old_ends_at, new_ends_at],
				'total_amount' => [old_total_amount, new_total_amount],
				'description' => [old_description, new_description]
			}
		}
    end
end
