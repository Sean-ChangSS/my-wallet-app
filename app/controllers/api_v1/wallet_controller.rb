class ApiV1::WalletController < ApiV1::BaseController
  before_action :authenticate_request

  <<-APIDOC
    =begin
      @apiGroup Wallet
      @api {post}/v1/wallet/deposit wallet/deposit
      @apiParam {Integer} amount amount
      @apiSuccessExample {json} success
        HTTP/1.1 200
        {
          "balance": 100
        }
      @apiFailureExample {json} failure
        HTTP/1.1 4xx
        {
          "error": "amount should not be empty"
        }
    =end
  APIDOC
  def deposit
    deposit_service = Wallet::DepositService.new(user: current_user, amount: params['amount'])

    if deposit_service.execute
      return render_success({ balance: current_user.wallet.balance})
    else
      return render_bad_request({ error: deposit_service.first_err_msg })
    end
  end

  <<-APIDOC
    =begin
      @apiGroup Wallet
      @api {post}/v1/wallet/withdraw wallet/withdraw
      @apiParam {Integer} amount amount
      @apiSuccessExample {json} success
        HTTP/1.1 200
        {
          "balance": 100
        }
      @apiFailureExample {json} failure
        HTTP/1.1 4xx
        {
          "error": "amount should not be empty"
        }
    =end
  APIDOC
  def withdraw
    withdraw_service = Wallet::WithdrawService.new(user: current_user, amount: params['amount'])

    if withdraw_service.execute
      return render_success({ balance: current_user.wallet.balance})
    else
      return render_bad_request({ error: withdraw_service.first_err_msg })
    end
  end

  <<-APIDOC
    =begin
      @apiGroup Wallet
      @api {post}/v1/wallet/transfer wallet/transfer
      @apiParam {String} username username
      @apiParam {Integer} amount amount
      @apiSuccessExample {json} success
        HTTP/1.1 200
        {
          "balance": 100
        }
      @apiFailureExample {json} failure
        HTTP/1.1 4xx
        {
          "error": "amount should not be empty"
        }
    =end
  APIDOC
  def transfer
    transfer_service = Wallet::TransferService.new(
      user: current_user,
      dest_username: params['username'],
      amount: params['amount']
    )

    if transfer_service.execute
      return render_success({ balance: current_user.wallet.balance})
    else
      return render_bad_request({ error: transfer_service.first_err_msg })
    end
  end

  <<-APIDOC
    =begin
      @apiGroup Wallet
      @api {get}/v1/wallet/balance wallet/balance
      @apiSuccessExample {json} success
        HTTP/1.1 200
        {
          "balance": 100
        }
    =end
  APIDOC
  def get_balance
    return render_success({ balance: current_user.wallet.balance})
  end
end