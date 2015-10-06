class Comment < ActiveRecord::Base
  #name relation must be singular
  belongs_to :article
end
