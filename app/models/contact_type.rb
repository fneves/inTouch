class ContactType < ActiveRecord::Base
  has_many :contacts

  def to_s
    descriptor
  end
end
