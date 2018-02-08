feature "Served pages" do

	scenario "homepage" do
		visit '/'
		expect(page).to have_content 'Welcome'
	end

  scenario "Displays 'Hello World!'" do
    visit '/users'
    expect(page).to have_content 'Hello World!'
    expect(page).to_not have_content "I don't exist"
  end

  scenario "Displays a sign up page" do
  	visit '/users/new'
  	expect(page).to have_content 'Sign up'
  end

  scenario "user signs up- redirects to welcome" do
  	visit '/users/new'
  	fill_in 'username', with: 'Tester'
  	click_on 'submit'
  	expect(page).to have_content "Welcome"
  end

  scenario "User visits non-existant page" do
  	visit '/bloopers'
  	expect(page).to have_content '404 Error Page not found'
  end
end
feature "Served files" do

	scenario "request a public file" do
		visit'/public/sign-in.html'
		expect(page).to have_content "Sign up"
	end
end
