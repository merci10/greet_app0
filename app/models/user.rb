class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                      foreign_key: "follower_id",
                      dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                      foreign_key: "followed_id",
                      dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes
  has_many :like_notes, through: :likes, source: :note
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
  before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
						format: { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	def set_image(file)
	  if !file.nil?
      file_name = file.original_filename
      File.open("public/user_images/#{file_name}", 'wb'){ |f| f.write(file.read) } 
      self.user_image = file_name
    end
  end

  #渡された文字のハッシュを返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #ランダムなトークンを変えす
  def self.new_token
  	SecureRandom.urlsafe_base64
  end

  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  #渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
  	return false if digest.nil?
  	BCrypt::Password.new(digest).is_password?(token)
  end

  #ユーザーのログイン情報を破棄する
  def forget
  	update_attribute(:remember_digest, nil)
  end

  #アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  #有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
        reset_sent_at: Time.zone.now)
  end

  #password再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    # Note.where("user_id IN (?) OR user_id = ?", following_ids, id)

    # Note.where("user_id IN (:following_ids) OR user_id = :user_id",
    #            following_ids: following_ids, user_id: id)

    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Note.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  #ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  #ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: 
          other_user.id).destroy
  end

  #現在のユーザーがフォローしていたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # likeをする
  def like(note)
    likes.create(note_id: note.id)
  end

  # likeを取り消す
  def unlike(note)
    likes.find_by(note_id: note.id).destroy
  end

  #ユーザーがlikeしている全noteを返す



  private

    #メールアドレスを全て小文字にする
    def downcase_email
      self.email.downcase!
    end

    #有効化トークンとダイジェストを作成及び代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
