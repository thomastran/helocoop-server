class Authentication < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :trackable,
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :rememberable,  :validatable
end
