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
FactoryBot.define do
  factory :wallet do
    user
    balance { 0 }
  end
end
