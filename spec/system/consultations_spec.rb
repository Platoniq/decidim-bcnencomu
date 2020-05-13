# frozen_string_literal: true

require 'rails_helper'

describe 'Visit the consultations main page', type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:older_consultation) do
    create(:consultation, :published, organization: organization, created_at: 1.month.ago)
  end

  let!(:recent_consultation) do
    create(:consultation, :published, organization: organization, created_at: Time.now.utc)
  end
  let(:previous_question) { create :question, consultation: consultation }
  let(:question) { create :question, consultation: consultation }
  let(:next_question) { create :question, consultation: consultation }
  let(:consultation) { older_consultation }

  before do
    switch_to_host(organization.host)
    visit decidim_consultations.consultations_path
  end

  it 'renders the consultations page' do
    expect(page).to have_content('2 CONSULTATIONS')
  end

  context "when visiting a consultation" do
    before do
      visit decidim_consultations.consultation_path(slug: consultation.slug)
    end

    it "renders the consultation page" do
      expect(page).to have_content(consultation.title[:en])
    end
  end

  context "when visiting a question" do
    before do
      visit decidim_consultations.question_path(slug: question.slug)
    end

    it "renders the question page" do
      expect(page).to have_content(question.title[:en])
    end
  end
end