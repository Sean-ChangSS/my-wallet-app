# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.after_create' do
    context '.create_wallet' do
      it 'create user should create wallet' do
        user = User.create!(username: 'test')
        expect(user.wallet).to be_a(Wallet)
      end
    end
  end
end
