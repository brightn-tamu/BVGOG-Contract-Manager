Then('all contracts displayed should be in progress') do
    # Find the number of rows (contracts) on the home page initially
    contract_titles = page.all('tbody tr td a').map(&:text)

    # Loop through each contract title
    contract_titles.each do |title|
        # Navigate to the home page and find the link for the contract
        visit root_path
        within('#home-page-contracts-table-container') do
            # Find the link with the exact title and click it
            click_link title
        end

        # Check if the contract status on the show page is 'IN_PROGRESS'
        expect(page).to have_content('In Progress')

        # Navigate back to the home page for the next iteration
    end
end

Then('all contracts displayed should be in review') do
    # Find the number of rows (contracts) on the home page initially
    contract_titles = page.all('tbody tr td a').map(&:text)

    # Loop through each contract title
    contract_titles.each do |title|
        # Navigate to the home page and find the link for the contract
        visit root_path
        within('#home-page-contracts-table-container') do
            # Find the link with the exact title and click it
            click_link title
        end

        # Check if the contract status on the show page is 'IN_REVIEW'
        expect(page).to have_content('In Review')

        # Navigate back to the home page for the next iteration
    end
end
