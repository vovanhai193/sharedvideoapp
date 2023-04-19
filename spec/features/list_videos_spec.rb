# spec/features/create_city_spec.rb

require 'rails_helper'

RSpec.describe 'List videos', type: :feature do
  let!(:videos) { create_list(:video, 3) }
  
  scenario 'show list video' do
    visit root_path

    videos.each do |video|
      expect(page).to have_content(video.title)
    end
  end
end
