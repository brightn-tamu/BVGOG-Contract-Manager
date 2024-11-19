# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'FlashHelper', type: :helper do
  describe '#flash_type_to_bulma_class' do
    it 'returns "is-danger" for "alert"' do
      expect(helper.send(:flash_type_to_bulma_class, 'alert')).to eq('is-danger')
    end

    it 'returns "is-success" for "notice"' do
      expect(helper.send(:flash_type_to_bulma_class, 'notice')).to eq('is-success')
    end

    it 'returns "is-info" for any other type' do
      expect(helper.send(:flash_type_to_bulma_class, 'random')).to eq('is-info')
    end
  end
end
