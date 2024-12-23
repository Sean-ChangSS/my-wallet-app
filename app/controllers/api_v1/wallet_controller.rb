class ApiV1::WalletController < ApiV1::BaseController
  before_action :authenticate_request

  <<-APIDOC
    =begin
      @apiGroup Wallet
      @api {post}/v1/wallet/deposit wallet/deposit
      @apiBody {Integer} amount amount
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
      @apiBody {Integer} amount amount
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
      @apiBody {String} username username
      @apiBody {Integer} amount amount
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
  
  <<-APIDOC
    =begin
      @apiGroup Wallet
      @api {get}/v1/wallet/transactions wallet/transactions
      @apiParam {Integer} page page
      @apiParam {Integer} per_page per_page
      @apiSuccessExample {json} success
        HTTP/1.1 200
        {
          "transactions": [
            {
              id: 1,
              amount: 10,
              balance: 11,
              transaction_type: 0,
              created_at: "2024-12:22 17:55"
            }
          ],
          "meta": {
            current_page: 2,
            next_page: 3,
            prev_page: 1,
            total_page: 3,
            total_count: 57
          }
        }
    =end
  APIDOC
  def transactions
    page = params[:page] || 1
    per_page = params[:per_page] || 20

    transactions_events = current_user.wallet.transaction_events
      .order(created_at: :desc).page(page).per(per_page)

    render json: {
      transactions: transactions_events.as_json(only: [:id, :amount, :balance, :transaction_type, :created_at]),
      meta: pagination_meta(transactions_events)
    }
  end

  private

  def pagination_meta(result)
    {
      current_page: result.current_page,
      next_page: result.next_page,
      prev_page: result.prev_page,
      total_pages: result.total_pages,
      total_count: result.total_count
    }
  end
end