class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates :username,
              :presence => true,
              :uniqueness => { :case_sensitive => false }

  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true

  has_many :orders


  def stock
    Stock.where(user_id: self.id).first
  end

  def stock_id
    stock.id
  end

  include SearchCop

  search_scope :search do
    attributes :name
    attributes :email
  end

  def role_name
    {1 => "caixa", 2 => "vendedor", 3 => "administrador"}[role.to_i]
  end

  def client?
    role.to_i == 0
  end

  def caixa?
    role.to_i == 1 || role.to_i >= 3
  end

  def vendedor?
    role.to_i == 2 || role.to_i >= 3
  end

  def admin?
    role.to_i >= 3
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
