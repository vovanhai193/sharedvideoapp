# spec/features/create_city_spec.rb

require 'rails_helper'

RSpec.describe 'Sign In', type: :feature do
  let(:user) { create(:user, password: "123456", password_confirmation: "123456") }
  
  scenario 'valid inputs' do
    visit root_path
    click_on 'Login'

    fill_in 'Username', with: user.username
    fill_in 'Password', with: '123456'
    click_on 'Log in'
    expect(page).to have_content(user.email)
  end

  scenario 'invalid inputs' do
    visit root_path
    click_on 'Login'

    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'incorred'
    click_on 'Log in'
    expect(page).to have_content('Invalid Username or password.')
  end
end
