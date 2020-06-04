describe User, type: :model do

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

  describe "block_game_profile" do
    it "is generated on user creation" do
      user = create(:user, name: "xAS")
      expect(user.block_game_profile.present?).to be_truthy
    end
  end
end
