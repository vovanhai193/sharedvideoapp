require "rails_helper"

describe "Share a video", type: :feature do
  let(:user) { create(:user, password: "123456", password_confirmation: "123456") }

  context "when user is authorizated" do
    before do
      login(user.username, '123456')

      visit root_path

      click_on ("Share a movie")

      fill_in "Youtube url", with: youtube_url

      click_on ("Share")
    end

    context "valid youtube url" do
      let(:youtube_url) { "https://www.youtube.com/watch?v=AB1qJ74PQio" }

      it "the video is displayed to list page" do
        expect(page).to have_content("SECRET INVASION - FINAL TRAILER")
      end
    end

    context "invalid youtube url" do
      let(:youtube_url) { "https://invalid.com" }

      it "show error message" do
        expect(page).to have_content("Youtube Url is invalid")
      end
    end

    context "video not found" do
      let(:youtube_url) { "https://www.youtube.com/watch?v=AB23J74PQio" }

      it "show error message" do
        expect(page).to have_content("Youtube Video is not found")
      end
    end
  end

  context "unauthorizated" do
    it "didn't show share movie button" do
      visit root_path
      expect(page).not_to have_content("Share a movie")
    end
  end
end

def login(username, password)
  visit new_user_session_path

  fill_in "Username", with: username
  fill_in "Password", with: password

  click_on 'Log in'
end
