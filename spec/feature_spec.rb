feature "Server functions" do

  scenario "Displays 'Hello World!'" do
    visit '/'
    expect(page).to have_content 'Hello World!'
    expect(page).to_not have_content "I don't exist"
  end

end
