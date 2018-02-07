feature "Server functions" do

  scenario "Displays 'Hello World!'" do
    visit '/users'
    expect(page).to have_content 'Hello World!'
    expect(page).to_not have_content "I don't exist"
  end

  scenario "Displays a sign up page" do
  	visit '/users/new'
  	expect(page).to have_content 'Sign up'
  end
end
