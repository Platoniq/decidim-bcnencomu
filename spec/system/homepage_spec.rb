# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:organization) { create :organization }

  let!(:consultation) { create(:consultation, :published, organization: organization) }
  let!(:assembly) { create(:assembly, :published, organization: organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Inici")
    expect(page).to have_content("Espais participatius")
    expect(page).to have_content("Consultes")
  end
end
