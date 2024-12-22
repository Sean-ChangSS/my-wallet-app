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
        perform_deposit(1)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['balance']).to eq(1)

        wallet.reload
        expect(wallet.balance).to eq(1)
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
end
