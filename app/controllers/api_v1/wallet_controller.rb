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
end