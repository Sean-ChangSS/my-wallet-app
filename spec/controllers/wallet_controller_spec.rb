require 'rails_helper'

RSpec.describe 'ApiV1::WalletController', type: :request do
  describe 'POST /v1/wallet/deposit' do
    let(:user) { create(:user) }
    let(:wallet) { user.wallet }
    let(:initial_balance) { 0 }

    def perform_deposit(amount)
      post '/v1/wallet/deposit', params: { amount: amount }.to_json, headers: auth_header(user.id)
    end

    def perform_deposit_without_params
      post '/v1/wallet/deposit', headers: auth_header(user.id)
    end

    context 'when depositing valid amounts' do
      it 'deposit 1 to empty wallet should be accepted' do
        expect { perform_deposit(1) }.to change { wallet.reload.balance }.from(0).to(1)
          .and change { wallet.transaction_events.count }.from(0).to(1)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['balance']).to eq(1)

        transaction_event = wallet.transaction_events.first
        expect(transaction_event.wallet_id).to eq(wallet.id)
        expect(transaction_event.amount).to eq(1)
        expect(transaction_event.balance).to eq(1)
        expect(transaction_event.transaction_type).to eq('deposit')
      end

      it 'deposit 1 to empty wallet with 100 parallel requests should add 100 to wallet' do
        threads = []
        100.times do
          threads << Thread.new do
            perform_deposit(1)
          end
        end
        threads.each(&:join)

        expect(response).to have_http_status(:ok)

        wallet.reload
        expect(wallet.balance).to eq(100)
      end
    end

    context 'when depositing invalid amounts' do
      it 'deposit 1 to wallet with 999,999,999 should be rejected and return 400' do
        wallet.update!(balance: 999_999_999)

        perform_deposit(1)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(999_999_999)
      end

      it 'deposit 0 should be rejected and return 400' do
        perform_deposit(0)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'deposit 1,000,000,000 should be rejected and return 400' do
        perform_deposit(1_000_000_000)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'deposit -1 should be rejected and return 400' do
        perform_deposit(-1)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'deposit 0.5 should be rejected and return 400' do
        perform_deposit(0.5)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'deposit "abc" should be rejected and return 400' do
        perform_deposit("abc")

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end
    end

    context 'when missing parameter' do
      it 'should return 400' do
        perform_deposit_without_params

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end
    end
  end

  describe 'POST /v1/wallet/withdraw' do
    let(:user) { create(:user) }
    let(:wallet) { user.wallet }
    let(:initial_balance) { 100 }

    before do
      wallet.update!(balance: initial_balance)
    end

    def perform_withdraw(amount)
      post '/v1/wallet/withdraw', params: { amount: amount }.to_json, headers: auth_header(user.id)
    end

    def perform_withdraw_without_params
      post '/v1/wallet/withdraw', headers: auth_header(user.id)
    end

    context 'when withdrawing valid amounts' do
      it 'withdraw 1 from empty wallet should be accepted' do
        expect { perform_withdraw(1) }.to change { wallet.reload.balance }.from(100).to(99)
          .and change { wallet.transaction_events.count }.from(0).to(1)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['balance']).to eq(99)

        wallet.reload
        expect(wallet.balance).to eq(99)

        transaction_event = wallet.transaction_events.first
        expect(transaction_event.wallet_id).to eq(wallet.id)
        expect(transaction_event.amount).to eq(1)
        expect(transaction_event.balance).to eq(99)
        expect(transaction_event.transaction_type).to eq('withdraw')
      end

      it 'withdraw 1 from empty wallet with 100 parallel requests should reduce balance by 100' do
        threads = []
        100.times do
          threads << Thread.new do
            perform_withdraw(1)
          end
        end
        threads.each(&:join)

        expect(response).to have_http_status(:ok)

        wallet.reload
        expect(wallet.balance).to eq(0)
      end
    end

    context 'when withdrawing invalid amounts' do
      it 'withdraw 1 from empty wallet should be rejected with 400' do
        wallet.update!(balance: 0)

        perform_withdraw(1)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        # Ensure balance hasn't changed
        wallet.reload
        expect(wallet.balance).to eq(0)
      end

      it 'withdraw 0 should be rejected with 400' do
        perform_withdraw(0)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'withdraw 1,000,000,000 should be rejected with 400' do
        perform_withdraw(1_000_000_000)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'withdraw -1 should be rejected with 400' do
        perform_withdraw(-1)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'withdraw 0.5 should be rejected with 400' do
        perform_withdraw(0.5)

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end

      it 'withdraw "abc" should be rejected with 400' do
        perform_withdraw("abc")

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end
    end

    context 'when missing parameter' do
      it 'should return 400' do
        perform_withdraw_without_params

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_a(String)

        wallet.reload
        expect(wallet.balance).to eq(initial_balance)
      end
    end
  end

  describe 'POST /v1/wallet/transfer' do
    let(:user_a) { create(:user, username: 'user_a') }
    let(:user_b) { create(:user, username: 'user_b') }
    let(:initial_balance_a) { 0 }
    let(:initial_balance_b) { 0 }
    let(:params) { {} }

    before do
      user_a.wallet.update!(balance: initial_balance_a)
      user_b.wallet.update!(balance: initial_balance_b)
    end

    def perform_transfer
      post '/v1/wallet/transfer', params: params.to_json, headers: auth_header(user_a.id)
    end

    context 'A sends B 1' do
      let(:params) { { username: 'user_b', amount: 1 } }

      context 'with sufficient source balance and sufficient target remain' do
        let(:initial_balance_a) { 1 }
        let(:initial_balance_b) { 0 }

        it 'accepts transfer with HTTP 200' do
          expect { perform_transfer }.to change { user_a.wallet.reload.balance }.from(1).to(0)
            .and change { user_b.wallet.reload.balance }.from(0).to(1)
            .and change { user_a.wallet.transaction_events.reload.count }.from(0).to(1)
            .and change { user_b.wallet.transaction_events.reload.count }.from(0).to(1)

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({ 'balance' => 0 })

          transaction_event_a = user_a.wallet.transaction_events.first
          expect(transaction_event_a.wallet_id).to eq(user_a.wallet.id)
          expect(transaction_event_a.amount).to eq(1)
          expect(transaction_event_a.balance).to eq(0)
          expect(transaction_event_a.transaction_type).to eq('transfer_out')

          transaction_event_b = user_b.wallet.transaction_events.first
          expect(transaction_event_b.wallet_id).to eq(user_b.wallet.id)
          expect(transaction_event_b.amount).to eq(1)
          expect(transaction_event_b.balance).to eq(1)
          expect(transaction_event_b.transaction_type).to eq('transfer_in')
        end
      end

      context 'with insufficient source balance' do
        let(:initial_balance_a) { 0 }
        let(:initial_balance_b) { 0 }

        it 'rejects transfer with HTTP 400' do
          perform_transfer

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['error']).to be_a(String)
          expect(user_a.wallet.reload.balance).to eq(initial_balance_a)
          expect(user_b.wallet.reload.balance).to eq(initial_balance_b)
        end
      end

      context 'with insufficient target remain' do
        let(:initial_balance_a) { 1 }
        let(:initial_balance_b) { 999_999_999 }

        it 'rejects transfer with HTTP 400' do
          perform_transfer

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['error']).to be_a(String)
          expect(user_a.wallet.reload.balance).to eq(initial_balance_a)
          expect(user_b.wallet.reload.balance).to eq(initial_balance_b)
        end
      end
    end

    context 'A sends B 0' do
      let(:params) { { username: 'user_b', amount: 0 } }

      it 'rejects the request for trivial operation with HTTP 400' do
        perform_transfer

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to be_a(String)
        expect(user_a.wallet.reload.balance).to eq(initial_balance_a)
        expect(user_b.wallet.reload.balance).to eq(initial_balance_b)
      end
    end

    context 'A sends B 1,000,000,000' do
      let(:params) { { username: 'user_b', amount: 1_000_000_000 } }

      it 'rejects the request for invalid amount with HTTP 400' do
        perform_transfer

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to be_a(String)
        expect(user_a.wallet.reload.balance).to eq(initial_balance_a)
        expect(user_b.wallet.reload.balance).to eq(initial_balance_b)
      end
    end

    context 'A sends B -1' do
      let(:params) { { username: 'user_b', amount: -1 } }

      it 'rejects the request for invalid amount with HTTP 400' do
        perform_transfer

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to be_a(String)
        expect(user_a.wallet.reload.balance).to eq(initial_balance_a)
        expect(user_b.wallet.reload.balance).to eq(initial_balance_b)
      end
    end

    context 'A sends B 1, but B does not exist' do
      let(:initial_balance_a) { 1 }
      let(:initial_balance_b) { 0 }
      let(:params) { { username: 'non_existent_user', amount: 1 } }

      it 'rejects the request because target user does not exist with HTTP 400' do
        perform_transfer

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to be_a(String)
        expect(user_a.wallet.reload.balance).to eq(initial_balance_a)
      end
    end
  end

  describe 'GET /v1/wallet/balance' do
    let(:user) { create(:user) }
    let(:initial_balance) { 0 }

    before do
      user.wallet.update!(balance: initial_balance)
    end

    def perform_get_balance
      get '/v1/wallet/balance', headers: auth_header(user.id)
    end

    context 'get balance with 0 wallet balance' do
      let(:initial_balance) { 0 }

      it 'should return 0' do
        perform_get_balance

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance']).to eq(initial_balance)
      end
    end

    context 'get balance with 999,999,999 wallet balance' do
      let(:initial_balance) { 999_999_999 }

      it 'should return 999,999,999' do
        perform_get_balance

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance']).to eq(999_999_999)
      end
    end

    context 'get balance after update' do
      it 'should return updated balance' do
        user.wallet.update!(balance: 100)

        perform_get_balance

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance']).to eq(100)
      end
    end
  end

  describe 'GET /v1/wallet/transactions' do
    let(:user) { create(:user) }
    let!(:transactions) { create_list(:transaction_event, 50, wallet: user.wallet) }

    def perform_get_transactions
      get '/v1/wallet/transactions', params: { page: 2, per_page: 10 }, headers: auth_header(user.id)
    end

    context "with valid parameters" do
      it "returns a 200 status code" do
        perform_get_transactions

        expect(response).to have_http_status(:ok)
      end

      it "returns the correct page of transactions" do
        perform_get_transactions

        expect(JSON.parse(response.body)['transactions'][0]['id']).to eq(
          TransactionEvent.all.order(created_at: :desc)[10].id
        )
      end

      it "returns pagination metadata" do
        perform_get_transactions

        expect(JSON.parse(response.body)['meta']).to eq({
          'current_page' => 2,
          'next_page' => 3,
          'prev_page' => 1,
          'total_pages' => 5,
          'total_count' => 50
        })
      end
    end
  end
end
