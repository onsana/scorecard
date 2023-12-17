require "rails_helper"

RSpec.describe User, type: :model do
  describe ".user_ratings" do
    let(:user1) { create(:user, login: "user1", github_id: 123) }
    let(:user2) { create(:user, login: "user2", github_id: 456) }
    let(:user3) { create(:user, login: "user3", github_id: 789) }

    before do
      create(:pull, user: user1, github_id: 111, github_number: 12)
      create(:pull, user: user1, github_id: 222, github_number: 32)
      create(:pull, user: user3, github_id: 333, github_number: 33, date_created: Date.current - 30.days)
      create(:comment, user: user1)
      create(:review, user: user1)
      create(:comment, user: user2)
      create(:review, user: user2)
      create(:review, user: user3)
    end

    it "returns user ratings with counts and calculated rating" do
      result = described_class.user_ratings

      expect(result.to_a.length).to eq(3)

      # Check user1 ratings
      user1_result = result.find { |r| r["user_id"] == user1.id }
      expect(user1_result["login"]).to eq("user1")
      expect(user1_result["pull_count"]).to eq(2)
      expect(user1_result["comment_count"]).to eq(1)
      expect(user1_result["review_count"]).to eq(1)
      expect(user1_result["user_rating"]).to eq(2 * 12 + 1 * 1 + 1 * 3)

      # Check user2 ratings
      user2_result = result.find { |r| r["user_id"] == user2.id }
      expect(user2_result["login"]).to eq("user2")
      expect(user2_result["pull_count"]).to eq(0)
      expect(user2_result["comment_count"]).to eq(1)
      expect(user2_result["review_count"]).to eq(1)
      expect(user2_result["user_rating"]).to eq(0 * 12 + 1 * 1 + 1 * 3)

      # Check user3 ratings
      user3_result = result.find { |r| r["user_id"] == user3.id }
      expect(user3_result["login"]).to eq("user3")
      expect(user3_result["pull_count"]).to eq(0) # date_created > 7 fays ago
      expect(user3_result["comment_count"]).to eq(0)
      expect(user3_result["review_count"]).to eq(1)
      expect(user3_result["user_rating"]).to eq(0 * 12 + 0 * 1 + 1 * 3)
    end
  end
end
