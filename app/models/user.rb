# modelsにはDBの規則を書く

class User < ApplicationRecord

  # emailのフォーマット正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # DB保存する前に実行する処理（emailは必ず小文字で保存して一意性を保つ）
  before_save { self.email = email.downcase }

  # 空白(nil)制限,文字長制限,(emailはフォーマット制限,一意制限)
  validates :name,  presence: true, length: { maximum: 50  }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # passwordハッシュ化
  has_secure_password

  # passwordの文字長制限
  validates :password, presence: true, length: { minimum: 6 }

  # ユーザ入力のパスワードのハッシュ値を返す
  def User.digest(input_pass)
    # costが高ければ安全なハッシュ値を返す
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    # ハッシュ化パスワードの生成
    BCrypt::Password.create(input_pass, cost: cost)
  end

end