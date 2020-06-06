require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user)           { create :user }

  describe "on creation" do
    it "is valid" do
      expect(user.valid?).to be_truthy
    end
  end

  it "saves name lowercase, formatted with capitals" do
    user = create(:user, name: "xAS")
    expect(user.name).to eq "xas"
    expect(user.name_formatted).to eq "xAS"
  end

end
