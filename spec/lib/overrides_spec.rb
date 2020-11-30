# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_main_footer.html.erb" => "995cddce875d4a8b49a9997526145799",
      # views
      "/app/views/decidim/devise/sessions/new.html.erb" => "1da8569a34bcd014ffb5323c96391837",
    }
  },
  {
    package: "decidim-consultations",
    files: {
      # views
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "0655db0b199a7cb49389f055210a9cdb",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "364d7f8370cdbe7ae70c545fff2e21fa",
      "/app/views/decidim/consultations/consultations/_regular_questions.html.erb" => "0c5093e02db04da679d92415e2abd937", # todo check upgrade
      "/app/views/decidim/consultations/consultations/show.html.erb" => "84a1569b796f724efa304b9dfc40f68a",  # todo check upgrade
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",  # todo check upgrade
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "5290000e36d1508d588218ad3bb8c808",  # todo check upgrade
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "ae7c38afcc6588a00f8298ea69769da7",  # todo check upgrade
      "/app/views/decidim/consultations/questions/show.html.erb" => "1608782bab215fb95920fc3e824a8a5a",  # todo check upgrade
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
