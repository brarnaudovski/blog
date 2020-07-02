require 'rails_helper'

RSpec.describe User do
  context "when saving" do
    it "transform email to lower case" do
      john = create(:user, email: 'TESTING@TEST.COM')

      expect(john.email).to eq 'testing@test.com'
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:articles) }
    it { is_expected.to have_many(:comments) }

    describe 'dependency' do
      let(:articles_count) { 1 }
      let(:comments_count) { 1 }
      let(:user) { create(:user) }

      it 'destroys comments' do
        create_list(:comment, comments_count, user: user)

        expect { user.destroy }.to change { Comment.count }.by(-comments_count)
      end

      it 'destroys articles' do
        create_list(:article, articles_count, user: user)

        expect { user.destroy }.to change { Article.count }.by(-articles_count)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to have_secure_password }

    context 'when matching uniqueness of email' do
      subject { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email) }
    end

    it { is_expected.to validate_length_of(:password).is_at_least(User::MINIMUM_PASSWORD_LENGTH) }
    it { is_expected.to validate_length_of(:name).is_at_most(User::MAXIMUM_NAME_LENGTH) }
    it { is_expected.to validate_length_of(:email).is_at_most(User::MAXIMUM_EMAIL_LENGTH) }

    context 'when using invalid email format' do
      it 'is invalid' do
        john = build(:user, email: 'test@invalid')

        expect(john.valid?).to be false
      end
    end
  end
end
