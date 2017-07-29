require "rails_helper"

RSpec.describe Story, type: :model do
  # Association test
  it { should have_many(:moments).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:reports).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should belong_to(:category) }

  # Validation tests
end
