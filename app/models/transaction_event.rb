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
class TransactionEvent < ApplicationRecord
  belongs_to :wallet
  belongs_to :source_wallet, class_name: 'Wallet', optional: true

  enum :transaction_type, { deposit: 0, withdraw: 1, transfer: 2 }
end
