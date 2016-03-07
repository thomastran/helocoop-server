class UsersVoip < ActiveRecord::Base
  has_many :log_voips, dependent: :destroy
  has_many :rate_voips, dependent: :destroy
end
