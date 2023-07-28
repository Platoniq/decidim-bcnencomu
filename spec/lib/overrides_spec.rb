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
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9",
      # devise
      "/app/views/decidim/devise/sessions/new.html.erb" => "9d090fc9e565ded80a9330d4e36e495c",
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
      "/app/views/decidim/consultations/admin/consultations/results.html.erb" => "1a2f7afd79b20b1fcf66bdece660e8ae",
      "/app/views/decidim/consultations/admin/questions/_form.html.erb" => "1eb11e33f7ffa2739d1c11ff9ab6dff4",
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "e1ab4e8e5cc988f60f2bfe5e4be0a9f4",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "2d02835e2a1538cd7f6db698e302a29b",
      "/app/views/decidim/consultations/consultations/_regular_questions.html.erb" => "0c5093e02db04da679d92415e2abd937",
      "/app/views/decidim/consultations/consultations/show.html.erb" => "84a1569b796f724efa304b9dfc40f68a",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "9bc6f3b47e2e850ecaf33df56988d437",
      "/app/views/decidim/consultations/questions/_results.html.erb" => "2d8196efbf23e2ad7b8c32713c28b240",
      "/app/views/decidim/consultations/questions/_vote_button.html.erb" => "7f3516e6d13cc4a1a9c0894b9d9fb808",
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "bb4b10e9278cffd8d0d4eb57f5197a89",
      "/app/views/decidim/consultations/questions/show.html.erb" => "a01add938f39d496ca7ae9beee9f6945",
      # forms
      "/app/forms/decidim/consultations/admin/question_form.rb" => "ec32922ff3c79bd5e808208f25946ba2",
      # commands
      "/app/commands/decidim/consultations/admin/create_question.rb" => "9837cbac4b972db8f9c6327b91fdadd0",
      "/app/commands/decidim/consultations/admin/update_question.rb" => "bd54eb7e7ebc06be78b14684d05baa6d",
      # assets
      "/app/packs/src/decidim/consultations/utils_multiple.js" => "8ee3b5bfa77b98f9a953357a54770284",
      # classes in initializers/custom_consultations.rb
      "/app/helpers/decidim/consultations/questions_helper.rb" => "77f47837e3ea973fa85c498400948678",
      "/app/models/decidim/consultations/response.rb" => "e841b88f8e2d70577222be2a97cba442",
      "/app/models/decidim/consultations/question.rb" => "bc6e8618100f112c1d23bee9aaf5c0ed",
      "/app/controllers/decidim/consultations/admin/responses_controller.rb" => "b8a63f442dd146f1ea3596d485ea29f7",
      "/app/forms/decidim/consultations/multi_vote_form.rb" => "fc2160f0b5e85c9944d652b568c800f3"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      # just to take into the account if some routes change
      "/lib/decidim/assemblies/engine.rb" => "9d08692b06cf403b6b788c728733f36e",
      "/lib/decidim/assemblies/admin_engine.rb" => "94c7e7db6aa85d2ea196e254a68e4626",
      "/app/models/decidim/assembly.rb" => "b9ed4a9f5d822109728aed51bf5dcb48",
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "c6ddcc8dd42702031f8027bb56b69687",
      "/app/views/decidim/assemblies/assemblies/_parent_assemblies.html.erb" => "fd026d4ee40dd1d5ebf8ad9ec5d0dbb4"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "c4b88c68ea8b5653c6f1e35cd2646011"
    }
  },
  {
    package: "decidim-direct_verifications",
    files: {
      # The only change for controllers is the full namespace for the parent class as it didn't resolved it well when it
      # was just ApplicationController
      "/app/controllers/decidim/direct_verifications/verification/admin/authorizations_controller.rb" => "ec24f7eb75ad7ab298ef13a956873cf6",
      "/app/controllers/decidim/direct_verifications/verification/admin/direct_verifications_controller.rb" => "4f9cef25f72bb5ce88480850bd3f162a",
      "/app/controllers/decidim/direct_verifications/verification/admin/imports_controller.rb" => "477a63f3c749de204ccdc0987cd6b20d",
      "/app/controllers/decidim/direct_verifications/verification/admin/stats_controller.rb" => "a0c4ae48b1372ea5d37aae0112c9c826",
      "/app/controllers/decidim/direct_verifications/verification/admin/user_authorizations_controller.rb" => "c0f3387a8b76ecdf238e12e6c03daf3e"
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
