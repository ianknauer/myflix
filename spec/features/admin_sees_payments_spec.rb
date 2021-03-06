require 'spec_helper'

feature "Admin sees payments" do
  background do
    alice = Fabricate(:user, full_name: "Alice B", email: "aliceb@good.ca")
    Fabricate(:payment, amount: 999, user: alice)
  end
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice B")
    expect(page).to have_content("aliceb@good.ca")
  end
  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice B")
    expect(page).to have_content("You are not permitted to do that")
  end
end