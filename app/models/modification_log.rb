# frozen_string_literal: true

class ModificationLog < ApplicationRecord
    belongs_to :contract
    belongs_to :modified_by, class_name: 'User'

    validates :modification_type, :changes_made, :status, presence: true
    validates :modification_type, inclusion: { in: %w[renew amend] }
    validates :status, inclusion: { in: %w[pending approved rejected] }
    # TODO: Add 'approved by' or 'rejected by' fields?
    
    def send_failure_notification
        ContractMailer.amend_failure_notification(self).deliver_now
    end

    serialize :changes_made, Hash
end
