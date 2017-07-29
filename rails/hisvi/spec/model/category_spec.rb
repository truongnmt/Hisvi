require "rails_helper"

RSpec.describe Category, type: :model do
  # Association test
  it { should have_many(:stories) }

  # Validation tests
end
