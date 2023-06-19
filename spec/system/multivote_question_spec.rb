# frozen_string_literal: true

require "rails_helper"

describe "Multiple Answers Question", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create :user, :confirmed, organization: organization }
  let(:consultation) { create(:consultation, :active, organization: organization) }
  let(:question) { create :question, :multiple, :published, consultation: consultation, min_votes: 1, max_votes: 4 }
  let(:response_group_a) { create :response_group, question: question }
  let(:response_group_b) { create :response_group, question: question }
  let(:response_group_c) { create :response_group, question: question }
  let!(:response_a) { create :response, question: question, response_group: response_group_a }
  let!(:response_b) { create :response, question: question, response_group: response_group_a }
  let!(:response_c) { create :response, question: question, response_group: response_group_a }
  let!(:response_d) { create :response, question: question, response_group: response_group_a, title: Decidim::Faker::Localized.localized { "Option -suplent-" } }
  let!(:response_e) { create :response, question: question, response_group: response_group_b }
  let!(:response_f) { create :response, question: question, response_group: response_group_b }
  let!(:response_g) { create :response, question: question, response_group: response_group_b, title: Decidim::Faker::Localized.localized { "Option -suplent-" } }
  let!(:response_h) { create :response, question: question, response_group: response_group_c, title: Decidim::Faker::Localized.localized { "-en blanc-" } }

  context "and authenticated user" do
    context "and never voted before" do
      before do
        switch_to_host(organization.host)
        login_as user, scope: :user
        visit decidim_consultations.question_path(question)
      end

      it "contains a vote button" do
        expect(page).to have_link(id: "multivote_button")
      end

      it "voting leads to a new page" do
        click_link(id: "multivote_button")
        expect(page).to have_current_path decidim_consultations.question_question_multiple_votes_path(question)
      end
    end

    context "when voting" do
      before do
        switch_to_host(organization.host)
        login_as user, scope: :user
        visit decidim_consultations.question_question_multiple_votes_path(question)
      end

      it "contains vote button" do
        expect(page).to have_button(id: "vote_button")
      end

      it "contains number of votes available" do
        within "#remaining-votes-count" do
          expect(page).to have_content("4")
        end
      end

      it "decreases number of votes on voting" do
        check("vote_id_#{response_a.id}")

        within "#remaining-votes-count" do
          expect(page).to have_content("3")
        end
      end

      it "allows to vote the votes configured and unvote button appears after voting" do
        check("vote_id_#{response_a.id}")
        check("vote_id_#{response_b.id}")
        check("vote_id_#{response_c.id}")
        check("vote_id_#{response_d.id}")

        within "#remaining-votes-count" do
          expect(page).to have_content("0")
        end

        expect(page).to have_checked_field("vote_id_#{response_a.id}")
        expect(page).to have_checked_field("vote_id_#{response_b.id}")
        expect(page).to have_checked_field("vote_id_#{response_c.id}")
        expect(page).to have_checked_field("vote_id_#{response_d.id}")

        click_button("vote_button")

        expect(page).to have_current_path decidim_consultations.question_path(question)
        expect(page).to have_button(id: "unvote_button")
      end

      it "does not allow to vote over maximum candidats" do
        check("vote_id_#{response_a.id}")
        check("vote_id_#{response_b.id}")
        check("vote_id_#{response_c.id}")
        check("vote_id_#{response_e.id}")

        page.accept_alert

        within "#remaining-votes-count" do
          expect(page).to have_content("1")
        end

        expect(page).to have_checked_field("vote_id_#{response_a.id}")
        expect(page).to have_checked_field("vote_id_#{response_b.id}")
        expect(page).to have_checked_field("vote_id_#{response_c.id}")
        expect(page).not_to have_checked_field("vote_id_#{response_d.id}")
      end

      it "do not allow to vote over maximum suplents" do
        check("vote_id_#{response_d.id}")
        check("vote_id_#{response_g.id}")

        page.accept_alert

        within "#remaining-votes-count" do
          expect(page).to have_content("3")
        end

        expect(page).to have_checked_field("vote_id_#{response_d.id}")
        expect(page).not_to have_checked_field("vote_id_#{response_g.id}")
      end

      it "decreases to zero the number of remaining votes when voting blank and removes blank when voting another response" do
        check("vote_id_#{response_h.id}")

        within "#remaining-votes-count" do
          expect(page).to have_content("0")
        end

        expect(page).to have_checked_field("vote_id_#{response_h.id}")

        check("vote_id_#{response_a.id}")
        check("vote_id_#{response_b.id}")

        within "#remaining-votes-count" do
          expect(page).to have_content("2")
        end

        expect(page).to have_checked_field("vote_id_#{response_a.id}")
        expect(page).to have_checked_field("vote_id_#{response_b.id}")
        expect(page).not_to have_checked_field("vote_id_#{response_h.id}")
      end
    end

    context "and voted before" do
      let!(:vote_a) { create :vote, author: user, question: question, response: response_a }
      let!(:vote_b) { create :vote, author: user, question: question, response: response_b }

      before do
        switch_to_host(organization.host)
        login_as user, scope: :user
        visit decidim_consultations.question_path(question)
      end

      it "contains an unvote button" do
        expect(page).to have_button(id: "unvote_button")
      end

      it "vote button appears after unvoting" do
        click_button(id: "unvote_button")

        page.accept_alert

        expect(page).to have_link(id: "multivote_button")
      end
    end
  end
end
