# spec/lib/jwt_utils_spec.rb

require 'rails_helper'

RSpec.describe JwtUtils, type: :module do
  let(:payload) { { user_id: 1 } }
  let(:token) { JwtUtils.encode(payload) }

  describe '.encode' do
    it 'returns a string token' do
      expect(token).to be_a(String)
    end

    it 'includes the expiration time in the payload' do
      decoded = JWT.decode(token, JwtUtils::SECRET_KEY, true, { algorithm: JwtUtils::ALGORITHM })
      expect(decoded[0]).to include('exp')
    end
  end

  describe '.decode' do
    it 'returns the original payload' do
      decoded = JwtUtils.decode(token)
      expect(decoded['user_id']).to eq(payload[:user_id])
    end

    context 'when the token is expired' do
      let(:expired_token) { JwtUtils.encode(payload, 1.hour.ago) }

      it 'raises a Token has expired error' do
        expect { JwtUtils.decode(expired_token) }.to raise_error('Token has expired')
      end
    end

    context 'when the token is invalid' do
      let(:invalid_token) { token + 'invalid' }

      it 'raises an Invalid token error' do
        expect { JwtUtils.decode(invalid_token) }.to raise_error('Invalid token')
      end
    end

    context 'when the token has an invalid signature' do
      let(:tampered_payload) { { user_id: 2 } }

      it 'raises an Invalid token error' do
        # Tamper with the token by changing the payload
        tampered_token_parts = token.split('.')
        tampered_payload_encoded = Base64.urlsafe_encode64(tampered_payload.to_json).gsub('=', '')
        tampered_token_parts[1] = tampered_payload_encoded
        tampered_token = tampered_token_parts.join('.')

        expect { JwtUtils.decode(tampered_token) }.to raise_error('Invalid token')
      end
    end
  end
end
