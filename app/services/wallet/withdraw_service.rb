class Wallet::WithdrawService < BaseService
  attr_accessor :user, :amount

  validates :user, type: { type: User }, presence: true
  validates :amount, type: { type: Integer }, presence: true, comparison: { greater_than: 0, less_than: 1_000_000_000 }

  def perform
    Wallet.transaction do
      wallet = Wallet.lock.find_by(user_id: user.id)

      if wallet.balance - amount < 0
        errors.add(:amount, "Insufficient balance to withdraw #{amount}.")
        raise ActiveRecord::Rollback
      end

      wallet.decrement!(:balance, amount)
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:amount, e.message)
    false
  end
end