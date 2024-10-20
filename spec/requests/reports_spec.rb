# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/reports', type: :request do
    include Devise::Test::IntegrationHelpers
    include FactoryBot::Syntax::Methods
    let(:bvcog_config) { instance_double(BvcogConfig, reports_path: './public/reports/') }

    # Report. As you add validations to Report, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
        user = create(:user)
        return build(
            :report,
            title: 'new_report',
            file_name: 'new-report-124231.pdf',
            full_path: 'home/downloads/new-report-124231.pdf',
            report_type: :users,
            user_id: user.id
        ).attributes.except('id', 'created_at', 'updated_at')

    end

    let(:invalid_attributes) do
        return build(
            :report,
            title: nil,
            file_name: nil,
            full_path: nil,
            report_type: nil,
            user_id: nil
        ).attributes.except('id', 'created_at', 'updated_at')
    end

    describe 'GET /index' do
        it 'redirects to the new report path with the correct type' do
            # Make the GET request to the index action
            get reports_path

            # Expect a redirect to the new report path with the specified type
            expect(response).to redirect_to(new_report_path(type: ReportType::CONTRACTS))
        end
    end

    describe 'GET /show' do
        it 'renders a successful response' do
            report = Report.create! valid_attributes
            get report_url(report)
            expect(response).to be_successful
        end
    end

    describe 'GET /new' do
        it 'renders a successful response for reports type contracts' do
            get "#{new_report_url}?type=contracts"
            expect(response).to be_successful
        end

        it 'renders a successful response for reports type users' do
            get "#{new_report_url}?type=users"
            expect(response).to be_successful
        end
    end

    describe 'POST /create' do
        context 'with valid parameters' do
            it 'creates a new Report' do
                login_user
                allow(BvcogConfig).to receive(:last).and_return(bvcog_config)
                expect do
                    post reports_url, params: { report: valid_attributes }
                end.to change(Report, :count).by(1)
                # delete report_url(report)
            end

            it 'redirects to the created report' do
                login_user
                allow(BvcogConfig).to receive(:last).and_return(bvcog_config)
                post reports_url, params: { report: valid_attributes }
                expect(response).to redirect_to(report_url(Report.last))
                # delete report_url(report)
            end
        end

        context 'with invalid parameters' do
            it 'does not create a new Report' do
                login_user
                expect do
                    post reports_url, params: { report: invalid_attributes }
                end.to change(Report, :count).by(0)
            end

            it "renders a successful response (i.e. to display the 'new' template)" do
                login_user
                post reports_url, params: { report: invalid_attributes }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response).to render_template(:new)
            end
        end
    end

    describe 'PATCH /update' do
        context 'with valid parameters' do
            let(:new_attributes) do
            end

            it 'redirects to the report' do
                report = Report.create! valid_attributes
                patch report_url(report), params: { report: new_attributes }
                report.reload
                expect(response).to redirect_to(report_url(report))
            end
        end

        context 'with invalid parameters' do
            it "renders a successful response (i.e. to display the 'edit' template)" do
                report = Report.create! valid_attributes
                patch report_url(report), params: { report: invalid_attributes }
                expect(response).to redirect_to(report_url(report))
            end
        end
    end

    describe 'DELETE /destroy' do
        it 'destroys the requested report' do
            report = Report.create! valid_attributes
            expect do
                delete report_url(report)
            end.to change(Report, :count).by(-1)
        end

        it 'redirects to the reports list' do
            report = Report.create! valid_attributes
            delete report_url(report)
            expect(response).to redirect_to(reports_url)
        end
    end
end
