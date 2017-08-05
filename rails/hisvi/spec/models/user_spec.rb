require "rails_helper"

RSpec.describe User, type: :model do
  # Association test
  it { should have_many(:active_relationships).dependent(:destroy) }
  it { should have_many(:passive_relationships).dependent(:destroy) }
  it { should have_many(:following).through(:active_relationships) }
  it { should have_many(:followers).through(:passive_relationships) }
  it { should have_many(:stories).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:reports).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:email) }
end
