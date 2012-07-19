class Comment < ActiveRecord::Base
  attr_accessible :author, :text

  validates :author, :presence => true
  validates :text, :presence => true,
                    :length => { :minimum => 3 }

  def initialize(params)
    params[:author] = params[:author].gsub(/<\/?[^>]*>/, "") # Remove html markup
    params[:text] = params[:text].gsub(/<\/?[^>]*>/, "") # Remove html markup
    super(params)
  end
end
