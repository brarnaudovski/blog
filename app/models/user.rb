class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save :email_to_downcase

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  private

  def email_to_downcase
    self.email = email.downcase
  end
end
