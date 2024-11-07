class User < ApplicationRecord
  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  # defaults removed: :registerable, :recoverable,
  devise :database_authenticatable, :rememberable,
         :trackable, :validatable
end
