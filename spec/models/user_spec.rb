require 'rails_helper'

RSpec.describe User, type: :model do
  # let!(:user){ build(:user) } # cria a instancia antes de quando é chamado no teste
  let(:user){ build(:user) } # cria a instancia quando é chamado no teste

  # it{ expect(user).to respond_to(:email) }

  # context 'when name is blank' do
  #   before(:each){ user.name = ' ' }

  #   it { expect(user).not_to be_valid }
  # end

  # context 'when name is nil' do
  #   before(:each){ user.name = nil}

  #   it { expect(user).not_to be_valid }
  # end

  # it { expect(user).to validate_presence_of(:name) }
  # it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value('raphael@gmail.com').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
  # subject { build(:user) }
  # before { @user = FactoryGirl.build(:user) }

  # it{ expect(subject).to respond_to(:email) }
  # it{ expect(subject).to respond_to(:name) }
  # it{ expect(subject).to respond_to(:password) }
  # it{ expect(subject).to respond_to(:password_confirmation) }
  # it{ expect(subject).to be_valid }

  describe '#info' do
    it 'returns email, created_at and a Token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
      
      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abc123xyzTOKEN")
    end
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique auth token ' do
      allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('abc123xyzTOKEN')
    end

    it 'generates another auth token when the current auth token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('abc123tokenxyz', 'abc123tokenxyz', 'abcXYZ123456789')
      existing_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
