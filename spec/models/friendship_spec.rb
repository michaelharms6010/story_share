describe User, type: :model do

  let(:user) { create :user }
  let(:friend1) { create :user }
  let(:friend2) { create :user }


  before(:each) do
    @friendship = user.add_friend(friend1.name)
    @inverse_friendship = @friendship.inverse_friendship
  end

  describe "add friend" do
    it "is valid" do
      expect(@friendship.valid?).to be_truthy
      expect(@friendship.confirmed).to be_falsey
      expect(@friendship.rejected).to be_falsey
      expect(@friendship.accepted).to be_truthy
      expect(friend1.friendship_requests.length).to eq(1)
      expect(friend1.friendship_requests.first.id).to eq(@friendship.id)
    end

    it "creates valid inverse friendship" do
      expect(@inverse_friendship.valid?).to be_truthy
      expect(@inverse_friendship.confirmed).to be_truthy
      expect(@inverse_friendship.rejected).to be_falsey
      expect(@inverse_friendship.accepted).to be_falsey
    end

    it "can be confirmed" do
      expect(user.friends.count).to eq(0)
      expect(friend1.friends.count).to eq(0)
      expect(@friendship.accept_friendship).to be_truthy
      @inverse_friendship.reload
      expect(user.friends.count).to eq(1)
      expect(friend1.friends.count).to eq(1)

      expect(@friendship.confirmed).to be_truthy
      expect(@friendship.rejected).to be_falsey
      expect(@friendship.accepted).to be_truthy
      expect(@inverse_friendship.confirmed).to be_truthy
      expect(@inverse_friendship.rejected).to be_falsey
      expect(@inverse_friendship.accepted).to be_truthy
    end

    it "can be rejected" do
      expect(user.friends.count).to eq(0)
      expect(friend1.friends.count).to eq(0)
      expect(@friendship.reject_friendship).to be_truthy
      @inverse_friendship.reload
      expect(user.friends.count).to eq(0)
      expect(friend1.friends.count).to eq(0)

      expect(@friendship.confirmed).to be_truthy
      expect(@friendship.rejected).to be_truthy
      expect(@friendship.accepted).to be_falsey
      expect(@inverse_friendship.confirmed).to be_truthy
      expect(@inverse_friendship.rejected).to be_falsey
      expect(@inverse_friendship.accepted).to be_falsey
    end
  end

end
