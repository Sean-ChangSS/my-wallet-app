class Wallet::WithdrawService < Wallet::BaseService
  attr_accessor :user, :amount

  validates :user, type: { type: User }, presence: true
  validates :amount, type: { type: Integer }, presence: true, comparison: { greater_than: MIN_TRANSFER_AMOUNT, less_than: MAX_TRANSFER_AMOUNT }

  def perform
    ActiveRecord::Base.transaction do
      wallet = Wallet.lock.find_by(user_id: user.id)

      if wallet.balance - amount < 0
        errors.add(:amount, "Insufficient balance to withdraw #{amount}.")
        raise ActiveRecord::Rollback
      end

      wallet.balance -= amount
      wallet.save!

      TransactionEvent.create!(
        wallet: wallet,
        amount: amount,
        balance: wallet.balance,
        transaction_type: TransactionEvent.transaction_types["withdraw"]
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:amount, e.message)
    false
  end
end
