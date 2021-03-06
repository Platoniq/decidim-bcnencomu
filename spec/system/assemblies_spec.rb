# frozen_string_literal: true

require "rails_helper"

describe "Visit assemblies", type: :system do
  let(:organization) { create :organization }
  let!(:organs) { create :assemblies_type, id: 17 }
  let!(:type2) { create :assemblies_type }
  let!(:alternative_assembly) { create(:assembly, slug: "slug1", assembly_type: organs, organization: organization) }
  let!(:assembly) { create(:assembly, slug: "slug3", assembly_type: nil, organization: organization) }
  let!(:assembly2) { create(:assembly, slug: "slug2", assembly_type: type2, organization: organization) }

  let(:route) { "organs" } # same as defined in secrets.yml!!
  let(:position) { 2.4 }
  let(:types) { [organs.id] }
  let(:alternative_assembly_types) do
    [
      {
        key: route,
        position_in_menu: position,
        assembly_type_ids: types
      }
    ]
  end

  before do
    switch_to_host(organization.host)
  end

  context "when visiting home page" do
    before do
      visit decidim.root_path
    end

    it "shows the original assembly menu" do
      within ".main-nav" do
        expect(page).to have_content("Espais de participació")
        expect(page).to have_link(href: "/assemblies")
      end
    end

    it "shows the extra configured menu" do
      within ".main-nav" do
        expect(page).to have_content("Òrgans")
        expect(page).to have_link(href: "/organs")
      end
    end

    context "and navigating to original assemblies" do
      before do
        within ".main-nav" do
          click_link "Espais de participació"
        end
      end

      it "shows assemblies without excluded types" do
        within "#parent-assemblies" do
          expect(page).not_to have_content(alternative_assembly.title["ca"])
          expect(page).to have_content(assembly2.title["ca"])
          expect(page).to have_content(assembly.title["ca"])
        end
      end

      it "has the assemblies path" do
        expect(page).to have_current_path decidim_assemblies.assemblies_path
      end
    end

    context "and navigating to alternative assemblies" do
      before do
        within ".main-nav" do
          click_link "Òrgans"
        end
      end

      it "shows assemblies without excluded types" do
        within "#parent-assemblies" do
          expect(page).to have_content(alternative_assembly.title["ca"])
          expect(page).not_to have_content(assembly2.title["ca"])
          expect(page).not_to have_content(assembly.title["ca"])
        end
      end

      it "has the alternative path" do
        expect(page).to have_current_path organs_path
      end
    end
  end

  context "when accessing original assemblies with an alternative path" do
    before do
      visit "/organs/#{assembly2.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path decidim_assemblies.assembly_path(assembly2.slug)
    end
  end

  context "when accessing alternative assemblies with the original path" do
    before do
      visit "/assemblies/#{alternative_assembly.slug}"
    end

    it "redirects to the alternative path" do
      expect(page).to have_current_path organ_path(alternative_assembly.slug)
    end
  end

  context "when accessing non typed assemblies with the alternative path" do
    before do
      visit "/organs/#{assembly.slug}"
    end

    it "redirects to the original path" do
      expect(page).to have_current_path decidim_assemblies.assembly_path(assembly.slug)
    end
  end
end
