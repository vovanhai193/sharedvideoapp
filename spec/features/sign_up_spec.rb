# spec/features/create_city_spec.rb

require 'rails_helper'

RSpec.describe 'Sign Up', type: :feature do
  let(:user) { build(:user) }
  let(:exist_user) { create(:user) }
  
  scenario 'valid inputs' do
    visit root_path
    click_on 'Sign Up'

    fill_in 'Username', with: user.username
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content(user.email)
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'invalid inputs' do
    visit root_path
    click_on 'Sign Up'

    fill_in 'Username', with: exist_user.username
    fill_in 'Email', with: nil
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '1234567'
    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content("Username has already been taken")
  end
end
