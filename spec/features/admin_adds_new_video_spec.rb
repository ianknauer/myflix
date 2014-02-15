require 'spec_helper'

feature 'Admin Adds New Video' do
  scenario 'Admin successfully adds a new video' do
    admin = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")
    sign_in(admin)
    visit new_admin_video_path
    
    fill_in "Name", with: "Monk"
    select "Dramas", from: "Category"
    fill_in "Description", with: "SF detective"
    attach_file "Large thumb", "spec/support/uploads/monk_large.jpg"
    attach_file "Small thumb", "spec/support/uploads/monk.jpg"
    fill_in "Video Url", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"
    
    sign_out
    sign_in
    
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end
end