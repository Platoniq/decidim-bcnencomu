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
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440",
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc",
      # devise
      "/app/views/decidim/devise/sessions/new.html.erb" => "1da8569a34bcd014ffb5323c96391837",
      # cells
      "/app/cells/decidim/tos_page/form.erb" => "2518b45c702590a44e1df5b2eb13d937"
    }
  },
  {
    package: "decidim-direct_verifications",
    files: {
      # devise
      "/app/views/devise/mailer/direct_invite.html.erb" => "094174f490539e4b21d530efce951c2f",
      "/app/views/devise/mailer/direct_invite.text.erb" => "a8bb5931b6c1b719a96de60dc7093d5f"
    }
  },
  {
    package: "decidim-consultations",
    files: {
      # views
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "0655db0b199a7cb49389f055210a9cdb",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "364d7f8370cdbe7ae70c545fff2e21fa",
      "/app/views/decidim/consultations/consultations/_regular_questions.html.erb" => "0c5093e02db04da679d92415e2abd937",
      "/app/views/decidim/consultations/consultations/show.html.erb" => "84a1569b796f724efa304b9dfc40f68a",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "5290000e36d1508d588218ad3bb8c808",
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "ae7c38afcc6588a00f8298ea69769da7",
      "/app/views/decidim/consultations/questions/show.html.erb" => "1608782bab215fb95920fc3e824a8a5a",
      # assets
      "/app/assets/javascripts/decidim/consultations/utils_multiple.js" => "1fa33123c28b00e571a6f7702e8c0d2d",
      # classes in initializers/custom_consultations.rb
      "/app/helpers/decidim/consultations/questions_helper.rb" => "4afbf06016579ceb71a5c3ebee458a8b",
      "/app/models/decidim/consultations/response.rb" => "e841b88f8e2d70577222be2a97cba442",
      "/app/models/decidim/consultations/question.rb" => "434ba865b6f51d14171aada1c554bcbd",
      "/app/controllers/decidim/consultations/admin/responses_controller.rb" => "b8a63f442dd146f1ea3596d485ea29f7",
      "/app/forms/decidim/consultations/multi_vote_form.rb" => "fc2160f0b5e85c9944d652b568c800f3"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      # just to take into the account if some routes change
      "/lib/decidim/assemblies/engine.rb" => "20d16ed292562a28198c5644426eb5d8",
      "/lib/decidim/assemblies/admin_engine.rb" => "5cb65ce77bd8bb2508984faa7825326f",
      "/app/models/decidim/assembly.rb" => "0d9726c3f40c320b02b31f59a70dbf02",
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "76988d76b84d96079e6d9e1b252a3fda",
      "/app/views/decidim/assemblies/assemblies/_parent_assemblies.html.erb" => "fd026d4ee40dd1d5ebf8ad9ec5d0dbb4"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "9b5f2673ac38699c86c89fbd0d6e326f"
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
