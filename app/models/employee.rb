class Employee < ActiveRecord::Base
  #name relation must singular
  #has_one :motor_cycle, dependent::destroy
end
