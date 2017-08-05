require "rails_helper"

RSpec.describe Moment, type: :model do
  # Association test
  it { should belong_to(:story) }

  # Validation tests
end
