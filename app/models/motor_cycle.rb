class MotorCycle < ActiveRecord::Base
  #name relation must singular
  belongs_to :employee, dependent::delete
end
