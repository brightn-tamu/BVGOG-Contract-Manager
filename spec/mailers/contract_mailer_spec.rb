# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractMailer, type: :mailer do
    describe '#expiry_reminder' do
        let(:program_manager) { create(:user, program: contract.program, is_program_manager: true) }
        let(:point_of_contact) { create(:user, email: 'contact@example.com') }
        let(:contract) { create(:contract, point_of_contact:, ends_at: Date.today + 10) }

        before do
            program_manager
            @mail = described_class.expiry_reminder(contract).deliver_now
        end

        it 'sends emails' do
            expect(described_class.deliveries.count).to eq(1)
        end

        it 'sends email to the correct recipients' do
            expect(@mail.to).to contain_exactly(point_of_contact.email, program_manager.email)
        end

        it 'sends email with the correct subject' do
            days_remaining = (contract.ends_at.to_datetime - Date.today.to_datetime).to_i
            expect(@mail.subject).to eq("REMINDER: Contract expiring in #{days_remaining} days ")
        end

        it 'sends email with the correct template' do
            expect(@mail.html_part.decoded).to match(/This is a friendly reminder that your contract, #{contract.title}, with #{contract.vendor.name} will be expiring on #{contract.ends_at.strftime("%B %d, %Y")}/)
        end
    end

end
