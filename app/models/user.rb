class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_secure_password

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_save :email_to_downcase

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  private

  def email_to_downcase
    self.email = email.downcase
  end
end
