require "rails_helper"

RSpec.describe Report, type: :model do
  # Association test
  it { should belong_to(:user) }
  it { should belong_to(:story) }

  # Validation tests
end
