# frozen_string_literal: true

# Contracts
class Contract < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :description, length: { maximum: 2048 }
    validates :entity_id, presence: true
    validates :program_id, presence: true
    validates :point_of_contact_id, presence: true
    validates :vendor_id, presence: true
    validates :starts_at, presence: true
    validates :ends_at, comparison: { greater_than_or_equal_to: :starts_at }, if: -> { end_trigger == 'limited_term' }
    validates :ends_at_final, comparison: { greater_than_or_equal_to: :ends_at }, if: lambda {
                                                                    end_trigger == 'limited_term' && ends_at_final.present?
                                                            }
    validates :contract_type, presence: true, inclusion: { in: ContractType.list }
    validates :contract_status, inclusion: { in: ContractStatus.list }


    validates :end_trigger, inclusion: { in: EndTrigger.list }

    validates :contract_value,
    numericality: { less_than_or_equal_to: 99_000_000, allow_nil: true }
    validates :contract_value,
    numericality: { greater_than_or_equal_to: 0, allow_nil: true }

    belongs_to :entity, class_name: 'Entity'
    belongs_to :program, class_name: 'Program'
    belongs_to :point_of_contact, class_name: 'User'
    belongs_to :vendor, class_name: 'Vendor'
    has_many :contract_documents, class_name: 'ContractDocument'
    has_many :decisions, class_name: 'ContractDecision'

    # Enums
    has_enumeration_for :contract_type, with: ContractType, create_helpers: true
    has_enumeration_for :contract_status, with: ContractStatus, create_helpers: true
    has_enumeration_for :end_trigger, with: EndTrigger, create_helpers: true

    # Methods
    # Deprecated
    # :nocov:
    def send_expiry_reminder
        ContractMailer.expiry_reminder(self).deliver_now
    end
    # :nocov:

    # Deprecated
    # :nocov:
    def expired?
        ends_at < Time.zone.today or final_ends_at < Time.zone.today
    end
    # :nocov:

    public :send_expiry_reminder
end
