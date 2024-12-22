# == Schema Information
#
# Table name: transaction_events
#
#  id               :bigint           not null, primary key
#  amount           :integer          not null
#  balance          :integer          not null
#  transaction_type :integer          not null
#  created_at       :datetime         not null
#  source_wallet_id :integer
#  wallet_id        :integer          not null
#
# Indexes
#
#  index_transaction_events_on_wallet_id_and_created_at  (wallet_id,created_at)
#
require 'rails_helper'

RSpec.describe TransactionEvent, type: :model do
  it do
    user = create(:user)
    TransactionEvent.create!(
      wallet: user.wallet,
      transaction_type: TransactionEvent.transaction_types['deposit'],
      amount: 1,
      balance: 1
    )
  end
end
