# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
    include FactoryBot::Syntax::Methods

    let(:bvcog_config) { instance_double(BvcogConfig, reports_path: './') }

    before do
        allow(BvcogConfig).to receive(:last).and_return(bvcog_config)
    end

    it 'filters contracts based on entity' do
        # Create test data
        user = create(:user, id: 3, level: UserLevel::ONE)
        entity_one = create(:entity, name: 'Entity 1')
        entity_two = create(:entity, name: 'Entity 2')
        contract_one = create(:contract, entity: entity_one, program: create(:program), vendor: create(:vendor), point_of_contact: user)
        contract_two = create(:contract, entity: entity_two, program: create(:program), vendor: create(:vendor), point_of_contact: user)

        # Invoke the method being tested
        report = described_class.new(entity_id: entity_one.id, created_by: user.id)
        filtered_contracts = report.query_filtered_report_contracts

        # Assertion to check if the contracts are filtered based on entity_id
        expect(filtered_contracts).to include(contract_one)
        expect(filtered_contracts).not_to include(contract_two)
    end

    it 'filters contracts based on program' do
        # Create test data
        user = create(:user, id: 3, level: UserLevel::ONE)
        program_one = create(:program, name: 'Program 1')
        program_two = create(:program, name: 'Program 2')
        contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: user)
        contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: user)

        # Invoke the method being tested
        report = described_class.new(program_id: program_one.id, created_by: user.id)
        filtered_contracts = report.query_filtered_report_contracts

        # Assertion to check if the contracts are filtered based on entity_id
        expect(filtered_contracts).to include(contract_one)
        expect(filtered_contracts).not_to include(contract_two)
    end

    describe '#set_report_file' do
        it 'generates a file name' do
            user = create(:user, id: 3, level: UserLevel::ONE)
            entity_one = create(:entity, name: 'Entity 1')

            # Invoke the method being tested
            report = described_class.new(entity_id: entity_one.id, created_by: user.id, title: 'abc')
            report.set_report_file
            # Assertion to check if the file name contains title and random uuid
            expect(report.file_name).to match(/^abc-[a-f0-9]{8}\.pdf$/)
        end

        it 'sets the full path of the report' do
            user = create(:user, id: 1, level: UserLevel::ONE)
            entity_one = create(:entity, name: 'Entity 1')

            # Invoke the method being tested
            report = described_class.new(entity_id: entity_one.id, created_by: user.id, title: 'abc')
            report.set_report_file
            # Assertion to check if the file name contains title and random uuid
            expect(report.full_path).to eq(File.join('./', report.file_name))
        end
    end

    describe '#generate_standard_users_report' do
        it 'creates a PDF report with active and inactive users' do
            # Create test data
            user = create(:user, id: 3, level: UserLevel::ONE)
            program_one = create(:program, name: 'Program 1')
            program_two = create(:program, name: 'Program 2')
            contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: user)
            contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: user)

            # Invoke the method being tested
            report = described_class.new(program_id: program_one.id, created_by: user.id, title: 'Test_report')
            filtered_contracts = report.query_filtered_report_contracts

            # Assertion to check if the contracts are filtered based on entity_id
            expect(filtered_contracts).to include(contract_one)
            expect(filtered_contracts).not_to include(contract_two)

            report.generate_standard_users_report
            expect(File).to exist(report.full_path)

            File.delete(report.full_path) if File.exist?(report.full_path)
        end
    end

    describe '#generate_standard_contracts_report' do
        it 'creates a PDF report with filtered contract details' do
            # Create test data
            user = create(:user, id: 3, level: UserLevel::ONE)
            program_one = create(:program, name: 'Program 1')
            program_two = create(:program, name: 'Program 2')
            contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: user)
            contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: user)

            # Invoke the method being tested
            report = described_class.new(program_id: program_one.id, created_by: user.id, title: 'Test_report')
            filtered_contracts = report.query_filtered_report_contracts

            # Assertion to check if the contracts are filtered based on entity_id
            expect(filtered_contracts).to include(contract_one)
            expect(filtered_contracts).not_to include(contract_two)

            report.generate_standard_contracts_report
            expect(File).to exist(report.full_path)

            File.delete(report.full_path) if File.exist?(report.full_path)
        end
    end
    describe '#generate_contract_expiration_report' do
        let(:reports_path) { Rails.root.join('tmp', 'reports') }
        let(:today) { Time.zone.today }

        before do
            allow(BvcogConfig).to receive(:last).and_return(OpenStruct.new(reports_path: reports_path.to_s))
            FileUtils.mkdir_p(reports_path)
        end

        after do
            FileUtils.rm_rf(reports_path)
        end

        context 'when contracts exist in each range' do
            let!(:contracts_30_days) do
                create_list(:contract, 1, ends_at: today + 15.days, entity: create(:entity), program: create(:program), vendor: create(:vendor))
            end
            let!(:contracts_31_60_days) do
                create_list(:contract, 1, ends_at: today + 45.days, entity: create(:entity), program: create(:program), vendor: create(:vendor))
            end
            let!(:contracts_61_90_days) do
                create_list(:contract, 1, ends_at: today + 75.days, entity: create(:entity), program: create(:program), vendor: create(:vendor))
            end

            it 'generates the correct file name and path' do
                user = create(:user, id: 2099, level: UserLevel::ONE)
                entity_one = create(:entity, name: 'Entity 1')

                # Invoke the method being tested
                report = described_class.new(entity_id: entity_one.id, created_by: user.id)
                report.generate_contract_expiration_report
                expected_file_name = "bvcog-auto-contract-expiration-report-#{today.strftime('%Y-%m-%d')}.pdf"
                expected_full_path = File.join(reports_path, expected_file_name)

                expect(report.file_name).to eq(expected_file_name)
                expect(report.full_path).to eq(expected_full_path)
            end

            it 'creates a PDF file at the correct location' do
                user = create(:user, id: 2099, level: UserLevel::ONE)
                entity_one = create(:entity, name: 'Entity 1')

                # Invoke the method being tested
                report = described_class.new(entity_id: entity_one.id, created_by: user.id)
                report.generate_contract_expiration_report
                expect(File.exist?(report.full_path)).to be true
            end

            it 'includes correct content in the PDF' do
                user = create(:user, id: 2099, level: UserLevel::ONE)
                entity_one = create(:entity, name: 'Entity 1')

                # Invoke the method being tested
                report = described_class.new(entity_id: entity_one.id, created_by: user.id)

                report.generate_contract_expiration_report

                expect(File.exist?(report.full_path)).to be true

                # Read the PDF content
                pdf_text = (extract_pdf_text(report.full_path))

                # Check for titles
                expect(pdf_text).to include('Contracts Expiring in the next 30 days')
                expect(pdf_text).to include('Contracts Expiring in the next 31-60 days')
                expect(pdf_text).to include('Contracts Expiring in the next 61-90 days')
                #
                # # Check for contract data
                contracts_30_days.each do |contract|
                    expect(pdf_text).to include(contract.title.slice(0, 5))
                    expect(pdf_text).to include(contract.vendor.name.slice(0, 5))
                    expect(pdf_text).to include(contract.ends_at.strftime('%m/%d/%Y'))
                end
                #
                contracts_31_60_days.each do |contract|
                    expect(pdf_text).to include(contract.title.slice(0, 5))
                    expect(pdf_text).to include(contract.vendor.name.slice(0, 5))
                    expect(pdf_text).to include(contract.ends_at.strftime('%m/%d/%Y'))
                end
                #
                contracts_61_90_days.each do |contract|
                    expect(pdf_text).to include(contract.title.slice(0, 5))
                    expect(pdf_text).to include(contract.vendor.name.slice(0, 5))
                    expect(pdf_text).to include(contract.ends_at.strftime('%m/%d/%Y'))
                end
            end
        end

        context 'when no contracts exist in any range' do
            it 'creates an empty PDF with appropriate section headers' do
                user = create(:user, id: 2099, level: UserLevel::ONE)
                entity_one = create(:entity, name: 'Entity 1')

                # Invoke the method being tested
                report = described_class.new(entity_id: entity_one.id, created_by: user.id)

                report.generate_contract_expiration_report

                expect(File.exist?(report.full_path)).to be true

                # Read the PDF content
                report.generate_contract_expiration_report
                pdf_text = extract_pdf_text(report.full_path)

                expect(pdf_text).to include('Contracts Expiring in the next 30 days')
                expect(pdf_text).to include('Contracts Expiring in the next 31-60 days')
                expect(pdf_text).to include('Contracts Expiring in the next 61-90 days')
            end
        end
    end
    def extract_pdf_text(file_path)
        reader = PDF::Reader.new(file_path)
        reader.pages.map(&:text).join("\n")
    end
    def normalize_text(text)
        text.gsub("\n", ' ')
    end
end
