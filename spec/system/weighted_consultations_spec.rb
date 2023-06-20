# frozen_string_literal: true

require "rails_helper"

describe "Multiple question with multiple votes for different responses from different groups", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:is_weighted) { true }
  let!(:consultation) { create(:consultation, :published, organization: organization) }
  let!(:question) { create(:question, :multiple, organization: organization, consultation: consultation, is_weighted: is_weighted, min_votes: 1, max_votes: 4) }
  let!(:complete_response_group) { create(:response_group, question: question) }
  let!(:other_complete_response_group) { create(:response_group, question: question) }
  let!(:incomplete_response_group) { create(:response_group, question: question) }
  let!(:other_incomplete_response_group) { create(:response_group, question: question) }
  let!(:another_incomplete_response_group) { create(:response_group, question: question) }
  let!(:blank_response_group) { create(:response_group, question: question) }
  let!(:complete_response_a) { create(:response, question: question, response_group: complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 1 Option A" }) }
  let!(:complete_response_b) { create(:response, question: question, response_group: complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 1 Option B" }) }
  let!(:complete_response_c) { create(:response, question: question, response_group: complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 1 Option C" }) }
  let!(:complete_response_d) { create(:response, question: question, response_group: complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 1 Option D -suplent-" }) }
  let!(:other_complete_response_a) { create(:response, question: question, response_group: other_complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 2 Option A" }) }
  let!(:other_complete_response_b) { create(:response, question: question, response_group: other_complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 2 Option B" }) }
  let!(:other_complete_response_c) { create(:response, question: question, response_group: other_complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 2 Option C" }) }
  let!(:other_complete_response_d) { create(:response, question: question, response_group: other_complete_response_group, title: Decidim::Faker::Localized.localized { "Complete 2 Option D -suplent-" }) }
  let!(:incomplete_response_a) { create(:response, question: question, response_group: incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 1 Option A" }) }
  let!(:incomplete_response_b) { create(:response, question: question, response_group: incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 1 Option B" }) }
  let!(:incomplete_response_c) { create(:response, question: question, response_group: incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 1 Option C" }) }
  let!(:other_incomplete_response_a) { create(:response, question: question, response_group: other_incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 2 Option A" }) }
  let!(:other_incomplete_response_b) { create(:response, question: question, response_group: other_incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 2 Option B" }) }
  let!(:other_incomplete_response_c) { create(:response, question: question, response_group: other_incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 2 Option C -suplent-" }) }
  let!(:another_incomplete_response_a) { create(:response, question: question, response_group: another_incomplete_response_group, title: Decidim::Faker::Localized.localized { "Incomplete 3 Option A" }) }
  let!(:blank_response) { create(:response, question: question, response_group: blank_response_group, title: Decidim::Faker::Localized.localized { "-en blanc-" }) }
  let(:users) { create_list(:user, 22, organization: organization) }

  before do
    create(:vote, question: question, author: users[0], response: complete_response_a)
    create(:vote, question: question, author: users[0], response: complete_response_b)
    create(:vote, question: question, author: users[0], response: complete_response_c)
    create(:vote, question: question, author: users[0], response: complete_response_d)
    create(:vote, question: question, author: users[1], response: blank_response)
    create(:vote, question: question, author: users[2], response: other_complete_response_a)
    create(:vote, question: question, author: users[2], response: other_complete_response_b)
    create(:vote, question: question, author: users[2], response: other_complete_response_c)
    create(:vote, question: question, author: users[2], response: other_complete_response_d)
    create(:vote, question: question, author: users[3], response: complete_response_a)
    create(:vote, question: question, author: users[3], response: complete_response_b)
    create(:vote, question: question, author: users[3], response: complete_response_c)
    create(:vote, question: question, author: users[3], response: other_complete_response_d)
    create(:vote, question: question, author: users[4], response: complete_response_a)
    create(:vote, question: question, author: users[4], response: complete_response_b)
    create(:vote, question: question, author: users[4], response: complete_response_c)
    create(:vote, question: question, author: users[5], response: incomplete_response_a)
    create(:vote, question: question, author: users[5], response: incomplete_response_b)
    create(:vote, question: question, author: users[5], response: incomplete_response_c)
    create(:vote, question: question, author: users[6], response: other_incomplete_response_a)
    create(:vote, question: question, author: users[6], response: other_incomplete_response_b)
    create(:vote, question: question, author: users[6], response: other_incomplete_response_c)
    create(:vote, question: question, author: users[7], response: incomplete_response_a)
    create(:vote, question: question, author: users[7], response: incomplete_response_b)
    create(:vote, question: question, author: users[7], response: other_incomplete_response_c)
    create(:vote, question: question, author: users[8], response: complete_response_a)
    create(:vote, question: question, author: users[9], response: complete_response_a)
    create(:vote, question: question, author: users[9], response: complete_response_b)
    create(:vote, question: question, author: users[9], response: complete_response_c)
    create(:vote, question: question, author: users[9], response: complete_response_d)
    create(:vote, question: question, author: users[10], response: incomplete_response_a)
    create(:vote, question: question, author: users[11], response: incomplete_response_a)
    create(:vote, question: question, author: users[12], response: incomplete_response_a)
    create(:vote, question: question, author: users[13], response: incomplete_response_a)
    create(:vote, question: question, author: users[14], response: incomplete_response_a)
    create(:vote, question: question, author: users[15], response: incomplete_response_a)
    create(:vote, question: question, author: users[16], response: incomplete_response_a)
    create(:vote, question: question, author: users[17], response: incomplete_response_a)
    create(:vote, question: question, author: users[18], response: complete_response_a)
    create(:vote, question: question, author: users[18], response: complete_response_b)
    create(:vote, question: question, author: users[18], response: complete_response_c)
    create(:vote, question: question, author: users[18], response: complete_response_d)
    create(:vote, question: question, author: users[19], response: complete_response_a)
    create(:vote, question: question, author: users[19], response: complete_response_b)
    create(:vote, question: question, author: users[19], response: complete_response_c)
    create(:vote, question: question, author: users[19], response: complete_response_d)
    create(:vote, question: question, author: users[20], response: complete_response_a)
    create(:vote, question: question, author: users[20], response: complete_response_b)
    create(:vote, question: question, author: users[20], response: complete_response_c)
    create(:vote, question: question, author: users[20], response: complete_response_d)
    create(:vote, question: question, author: users[21], response: complete_response_a)
    create(:vote, question: question, author: users[21], response: complete_response_b)
    create(:vote, question: question, author: users[21], response: complete_response_c)
    create(:vote, question: question, author: users[21], response: complete_response_d)
  end

  it "return which list is complete" do
    expect(complete_response_group.complete_list?).to be true
    expect(other_complete_response_group.complete_list?).to be true
    expect(incomplete_response_group.complete_list?).to be false
    expect(other_incomplete_response_group.complete_list?).to be false
    expect(blank_response_group.complete_list?).to be false
  end

  context "when the question is weighted" do
    it "wins the complete response a due to the bonus of complete responses" do
      expect(question.most_voted_response).to eq(complete_response_a)
      expect(question.sorted_results.first).to eq(complete_response_a)
      expect(question.sorted_results.last).to eq(another_incomplete_response_a)
    end

    it "returns the votes with bonus for complete lists" do
      expect(complete_response_a.weighted_votes_count).to eq(10.2)
      expect(complete_response_b.weighted_votes_count).to eq(9.2)
      expect(complete_response_c.weighted_votes_count).to eq(9.2)
      expect(complete_response_d.weighted_votes_count).to eq(7.2)
      expect(other_complete_response_a.weighted_votes_count).to eq(1.2)
      expect(other_complete_response_b.weighted_votes_count).to eq(1.2)
      expect(other_complete_response_c.weighted_votes_count).to eq(1.2)
      expect(other_complete_response_d.weighted_votes_count).to eq(2.2)
      expect(incomplete_response_a.weighted_votes_count).to eq(10)
      expect(incomplete_response_b.weighted_votes_count).to eq(2)
      expect(incomplete_response_c.weighted_votes_count).to eq(1)
      expect(other_incomplete_response_a.weighted_votes_count).to eq(1)
      expect(other_incomplete_response_b.weighted_votes_count).to eq(1)
      expect(other_incomplete_response_c.weighted_votes_count).to eq(2)
      expect(another_incomplete_response_a.weighted_votes_count).to eq(0)
      expect(blank_response.weighted_votes_count).to eq(1)
    end
  end

  context "when the question is not weighted" do
    let(:is_weighted) { false }

    it "wins the incomplete response a because there is no bonus of complete responses" do
      expect(question.most_voted_response).to eq(incomplete_response_a)
      expect(question.sorted_results.first).to eq(incomplete_response_a)
      expect(question.sorted_results.last).to eq(another_incomplete_response_a)
    end

    it "does not return the votes with bonus for complete lists" do
      expect(complete_response_a.weighted_votes_count).to eq(9)
      expect(complete_response_b.weighted_votes_count).to eq(8)
      expect(complete_response_c.weighted_votes_count).to eq(8)
      expect(complete_response_d.weighted_votes_count).to eq(6)
      expect(other_complete_response_a.weighted_votes_count).to eq(1)
      expect(other_complete_response_b.weighted_votes_count).to eq(1)
      expect(other_complete_response_c.weighted_votes_count).to eq(1)
      expect(other_complete_response_d.weighted_votes_count).to eq(2)
      expect(incomplete_response_a.weighted_votes_count).to eq(10)
      expect(incomplete_response_b.weighted_votes_count).to eq(2)
      expect(incomplete_response_c.weighted_votes_count).to eq(1)
      expect(other_incomplete_response_a.weighted_votes_count).to eq(1)
      expect(other_incomplete_response_b.weighted_votes_count).to eq(1)
      expect(other_incomplete_response_c.weighted_votes_count).to eq(2)
      expect(another_incomplete_response_a.weighted_votes_count).to eq(0)
      expect(blank_response.weighted_votes_count).to eq(1)
    end
  end
end
