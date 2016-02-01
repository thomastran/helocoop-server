class User < ActiveRecord::Base
  has_many :logs, dependent: :destroy
  has_many :rates, dependent: :destroy
end
