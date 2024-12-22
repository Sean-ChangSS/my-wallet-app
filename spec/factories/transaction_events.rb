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
FactoryBot.define do
  factory :transaction_event do
    wallet
    amount { 1 }
    balance { 1 }
    transaction_type { 1 }
  end
end
