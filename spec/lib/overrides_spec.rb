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
      "/app/views/layouts/decidim/_main_footer.html.erb" => "aa621b251a3b7f22c670eb98e1a77105",
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc",
      # devise
      "/app/views/decidim/devise/sessions/new.html.erb" => "b8cd220c06cd5771b68869fd7ec7aaa7",
    },
    package: "decidim-direct_verifications",
    files: {
      # devise
      "/app/views/devise/mailer/direct_invite.html.erb" => "a8bb5931b6c1b719a96de60dc7093d5f",
      "/app/views/devise/mailer/direct_invite.text.erb" => "094174f490539e4b21d530efce951c2f",
    },
    package: "decidim-consultations",
    files: {
      # views
      "/app/views/decidim/consultations/admin/question_configuration/_form.html.erb" => "0655db0b199a7cb49389f055210a9cdb",
      "/app/views/decidim/consultations/admin/responses/_form.html.erb" => "6846d66395457acdd7d6ec839a49b0ec",
      "/app/views/decidim/consultations/consultations/_question.html.erb" => "e0490411ca3af6573cc736b297cbe6c8",
      "/app/views/decidim/consultations/consultations/_regular_questions.html.erb" => "0c5093e02db04da679d92415e2abd937",
      "/app/views/decidim/consultations/consultations/show.html.erb" => "84a1569b796f724efa304b9dfc40f68a",
      "/app/views/decidim/consultations/question_multiple_votes/_form.html.erb" => "af610283ce7ee20f5ef786228a263d4a",
      "/app/views/decidim/consultations/question_multiple_votes/_voting_rules.html.erb" => "5290000e36d1508d588218ad3bb8c808",
      "/app/views/decidim/consultations/questions/_vote_modal.html.erb" => "b23948e4ed7e0360a09faef326bc3664",
      "/app/views/decidim/consultations/questions/show.html.erb" => "24b06841ae047c8fde62c50e09d91b9b",
      # classes in initializers/custom_consultations.rb
      "/app/helpers/decidim/consultations/questions_helper.rb" => "9775042c1648009e43a05d3276bf53ff",
      "/app/models/decidim/consultations/response.rb" => "03f21a7e00b6f06ad93a70efdf82a9e4",
      "/app/models/decidim/consultations/question.rb" => "41f6887340926eff8e7d9db43f81b01c",
      "/app/controllers/decidim/consultations/admin/responses_controller.rb" => "b8a63f442dd146f1ea3596d485ea29f7",
      "/app/forms/decidim/consultations/multi_vote_form.rb" => "fc2160f0b5e85c9944d652b568c800f3",
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
