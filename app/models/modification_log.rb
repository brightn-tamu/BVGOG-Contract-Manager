class ModificationLog < ApplicationRecord
    belongs_to :contract
  
    validates :modified_by, :modification_type, :changes_made, :status, presence: true
    validates :modification_type, inclusion: { in: %w[renew amend] }
    validates :status, inclusion: { in: %w[pending approved rejected] }
    #TODO: Add 'approved by' or 'rejected by' fields?

    serialize :changes_made, Hash
  end