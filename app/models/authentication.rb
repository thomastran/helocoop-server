class Authentication < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :trackable,
  # :confirmable, :lockable, :timeoutable and :omniauthable  :registerable,
  devise :database_authenticatable, :timeoutable,
         :rememberable,  :validatable
end
