# == Schema Information
#
# Table name: wallets
#
#  id         :bigint           not null, primary key
#  balance    :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_wallets_on_user_id  (user_id) UNIQUE
#
class Wallet < ApplicationRecord
  belongs_to :user
  has_many :transaction_event
end
