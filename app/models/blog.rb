class Blog < ActiveRecord::Base
  attr_accessible :text, :title
  has_many :comments

  validates :title, :presence => true,
                    :length => { :minimum => 5 }
  validates :text, :presence => true,
                    :length => { :minimum => 5 }
end