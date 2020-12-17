# frozen_string_literal: true

require "rails_helper"

describe "Visit the home page", type: :system do
  let(:organization) { create :organization }

  let!(:organs) { create :assemblies_type, id: 17 }
  let!(:consultation) { create(:consultation, :published, organization: organization) }

  before do
    switch_to_host(organization.host)
  end

  it "renders the expected menu" do
    visit decidim.root_path

    within ".main-nav" do
      expect(page).to have_content("Inici")
      expect(page).not_to have_content("Espais participatius")
      expect(page).not_to have_content("Òrgans")
      expect(page).to have_content("Consultes")
    end
  end

  context "when there is normal assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Inici")
        expect(page).to have_content("Espais participatius")
        expect(page).not_to have_content("Òrgans")
        expect(page).to have_content("Consultes")
      end
    end
  end

  context "when there is alternative assemblies" do
    let!(:assembly) { create(:assembly, :published, organization: organization) }
    let!(:assembly2) { create(:assembly, :published, assembly_type: organs, organization: organization) }

    it "renders the expected menu" do
      visit decidim.root_path

      within ".main-nav" do
        expect(page).to have_content("Inici")
        expect(page).to have_content("Espais participatius")
        expect(page).to have_content("Òrgans")
        expect(page).to have_content("Consultes")
      end
    end
  end
end
