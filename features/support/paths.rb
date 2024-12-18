# frozen_string_literal: true

module NavigationHelpers
    # Maps a name to a path. Used by the
    #
    #   When /^I go to (.+)$/ do |page_name|
    #
    # step definition in web_steps.rb
    #
    def path_to(page_name)
        case page_name

        when /^the sign_in page/ then '/users/sign_in'
        when /^the home page/ then '/'
        when /^the users page/ then '/users'
        when /^the admin page/ then '/admin'
        when /^the contracts page/ then '/contracts'
        when /^the new contract page/ then '/contracts/new'
        when /^the vendors page/ then '/vendors'
        when /^the new vendor page/ then '/vendors/new'
        when /^the reports page/ then '/reports/'
        when /^the new report page/ then '/reports/new'
        when /^the new user invitation page/ then '/users/invitation/new'
        when /^the renew page/ then '/contracts/1/renew'
        when /^the amend page/ then '/contracts/1/amend'

        else
            raise "Can't find mapping from \"#{page_name}\" to a path.\nNow, go and add a mapping in #{__FILE__}"
        end
    end
end

World(NavigationHelpers)
