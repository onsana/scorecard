require "rails_helper"

RSpec.describe Pull, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    subject { FactoryBot.build(:pull) }
    it { should validate_uniqueness_of(:github_id) }
    it { should validate_uniqueness_of(:github_number) }
  end
end
