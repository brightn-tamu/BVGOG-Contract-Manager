# frozen_string_literal: true
require 'rails_helper'

require 'byebug'
RSpec.describe VendorsController, type: :controller do

  describe '#search_vendors' do
    let!(:vendor1) { Vendor.create(name: 'Awesome Vendor') }
    let!(:vendor2) { Vendor.create(name: 'Another Vendor') }
    let!(:vendor3) { Vendor.create(name: 'Unrelated Name') }

    it 'returns vendors matching the search term' do
      # Simulate a search parameter
      allow(controller).to receive(:params).and_return({ search: 'Awesome' })

      # Call the private method using `send`
      result = controller.send(:search_vendors, Vendor.all)

      # Check that only matching vendors are returned
      expect(result).to contain_exactly(vendor1)
    end

    it 'returns all vendors when search term is empty' do
      allow(controller).to receive(:params).and_return({ search: '' })

      result = controller.send(:search_vendors, Vendor.all)

      expect(result).to contain_exactly(vendor1, vendor2, vendor3)
    end

    it 'returns no vendors when no matches found' do
      allow(controller).to receive(:params).and_return({ search: 'Nonexistent' })

      result = controller.send(:search_vendors, Vendor.all)

      expect(result).to be_empty
    end
  end
  describe '#sort_vendors' do
    let!(:vendor1) { Vendor.create(name: 'Vendor One', created_at: 1.day.ago) }
    let!(:vendor2) { Vendor.create(name: 'Vendor Two', created_at: 2.days.ago) }
    let!(:vendor3) { Vendor.create(name: 'Vendor Three', created_at: 3.days.ago) }

    let!(:review1) { FactoryBot.create(:vendor_review, vendor: vendor1, rating: 5) }
    let!(:review2) { FactoryBot.create(:vendor_review, vendor: vendor1, rating: 4) }
    let!(:review3) { FactoryBot.create(:vendor_review, vendor: vendor2, rating: 3) }

    it 'sorts vendors by the number of reviews in descending order' do
      allow(controller).to receive(:params).and_return({ sort: 'reviews', order: 'desc' })

      result = controller.send(:sort_vendors)

      expect(result.pluck(:id)).to eq([vendor1.id, vendor2.id, vendor3.id])
    end


    it 'sorts vendors by average rating in ascending order' do
      allow(controller).to receive(:params).and_return({ sort: 'rating', order: 'asc' })

      result = controller.send(:sort_vendors)

      expect(result.pluck(:id)).to eq([vendor3.id, vendor2.id, vendor1.id])
    end

  end
end
