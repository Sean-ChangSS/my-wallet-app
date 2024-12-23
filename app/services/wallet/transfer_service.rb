class Wallet::TransferService < Wallet::BaseService
  attr_accessor :user, :dest_username, :amount

  validates :user, type: { type: User }, presence: true
  validates :dest_username, type: { type: String }, presence: true
  validates :amount, type: { type: Integer }, presence: true, comparison: { greater_than: MIN_TRANSFER_AMOUNT, less_than_or_equal_to: MAX_TRANSFER_AMOUNT }

  def perform
    dest_user = User.find_by(username: dest_username)

    if dest_user.nil?
      errors.add(:dest_username, "Transfer target user does not exist.")
      return false
    end

    ActiveRecord::Base.transaction do
      wallets = Wallet.where(user_id: [ user.id, dest_user.id ]).order(:id).lock
      src_wallet = wallets.find { |w| w.user_id == user.id }
      dest_wallet = wallets.find { |w| w.user_id == dest_user.id }

      if src_wallet.balance - amount < 0
        errors.add(:amount, "Insufficient balance to transfer.")
        raise ActiveRecord::Rollback
      end

      if dest_wallet.balance + amount > MAX_BALANCE
        errors.add(:amount, "Transfer to target exceeds maximum allowed balance.")
        raise ActiveRecord::Rollback
      end

      src_wallet.balance -= amount
      dest_wallet.balance += amount

      src_wallet.save!
      dest_wallet.save!

      TransactionEvent.create!(
        wallet: src_wallet,
        amount: amount,
        balance: src_wallet.balance,
        transaction_type: TransactionEvent.transaction_types["transfer_out"]
      )
      TransactionEvent.create!(
        wallet: dest_wallet,
        amount: amount,
        balance: dest_wallet.balance,
        transaction_type: TransactionEvent.transaction_types["transfer_in"]
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:amount, e.message)
    false
  end
end
