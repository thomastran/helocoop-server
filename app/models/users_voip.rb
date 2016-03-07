class UsersVoip < ActiveRecord::Base
  has_many :logvoips, dependent: :destroy
  has_many :ratevoips, dependent: :destroy
end
