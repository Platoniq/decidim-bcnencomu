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
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "bca0b383e5eac51414cc5c3347fc8227",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "364d7f8370cdbe7ae70c545fff2e21fa",
      "/app/views/decidim/consultations/consultations/_regular_questions.html.erb" => "0c5093e02db04da679d92415e2abd937",
      "/app/views/decidim/consultations/consultations/show.html.erb" => "84a1569b796f724efa304b9dfc40f68a",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "207a85b27ee044bd6f5fa79e4ba9dce9",
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "ae7c38afcc6588a00f8298ea69769da7",
      "/app/views/decidim/consultations/questions/show.html.erb" => "db9cbbd5933b17bce7ff93b1ff9ddfb7",
      # assets
      "/app/packs/src/decidim/consultations/utils_multiple.js" => "8ee3b5bfa77b98f9a953357a54770284",
      # classes in initializers/custom_consultations.rb
      "/app/helpers/decidim/consultations/questions_helper.rb" => "4afbf06016579ceb71a5c3ebee458a8b",
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
      "/lib/decidim/assemblies/admin_engine.rb" => "7bf18f6b4aba746f45899930454e50e0",
      "/app/models/decidim/assembly.rb" => "87a29d8481d481fe18f537f38be7aec8",
      "/app/views/decidim/assemblies/_filter_by_type.html.erb" => "76988d76b84d96079e6d9e1b252a3fda",
      "/app/views/decidim/assemblies/assemblies/_parent_assemblies.html.erb" => "fd026d4ee40dd1d5ebf8ad9ec5d0dbb4"
    }
  },
  {
    package: "decidim-meetings",
    files: {
      "/app/controllers/decidim/meetings/meetings_controller.rb" => "0ba80f4e517f9adff431e715e5faa2fb"
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
