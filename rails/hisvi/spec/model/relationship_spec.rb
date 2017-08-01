require "rails_helper"

RSpec.describe Relationship, type: :model do
  # Association test
  it { should belong_to(:follower) }
  it { should belong_to(:followed) }

  # Validation tests
end
