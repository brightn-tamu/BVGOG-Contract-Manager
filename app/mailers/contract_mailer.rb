# frozen_string_literal: true

# Sends reminder emails for contract expiry
class ContractMailer < ApplicationMailer
    def expiry_reminder(contract)
        @contract = contract
        # We may have multiple program managers, so we need to get all of their emails
        program_manager_emails = User.where(program: contract.program, is_program_manager: true).pluck(:email)
        days_remaining = (contract.ends_at.to_datetime - Time.zone.today.to_datetime).to_i

        emails = [contract.point_of_contact.email, program_manager_emails].flatten
        mail(to: emails,
             subject: "REMINDER: Contract expiring in #{days_remaining} days ")
    end

    def expiration_report(report)
        @report = report
        Rails.logger.debug "Users to send report: #{BvcogConfig.last.users.map(&:email).join(', ')}"
        BvcogConfig.last.users.each do |user|
            @user = user
            attachments[report.file_name] = File.read(report.full_path)
            mail = mail(
                to: @user.email,
                subject: "Contract Expiration Report - #{Time.zone.today.strftime('%m/%d/%Y')}"
            ) do |format|
                format.html { render 'expiration_report', locals: { name: @user.full_name } }
            end
            mail.deliver_now
        end
    end

    def email_reject_amend(modification_log)
        @modification_log = modification_log
        @modified_by = modification_log.modified_by
        @contract = modification_log.contract

        mail(
            to: @modified_by.email,
            subject: 'Contract Amendment Request Rejected'
        )
    end

    def email_void_amend(modification_log)
        @modification_log = modification_log
        @modified_by = modification_log.modified_by
        @contract = modification_log.contract

        mail(
            to: @modified_by.email,
            subject: 'Contract Amendment Request Voided'
        )
    end

end
