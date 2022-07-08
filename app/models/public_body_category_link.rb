# == Schema Information
# Schema version: 20210114161442
#
# Table name: public_body_category_links
#
#  public_body_category_id :integer          not null
#  public_body_heading_id  :integer          not null
#  category_display_order  :integer
#  id                      :integer          not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#

class PublicBodyCategoryLink < ApplicationRecord
  belongs_to :public_body_category,
             :inverse_of => :public_body_category_links
  belongs_to :public_body_heading,
             :inverse_of => :public_body_category_links

  validates_presence_of :public_body_category
  validates_presence_of :public_body_heading
  validates :category_display_order, :numericality => { :only_integer => true,
                                                        :message => 'Display order must be a number' }

  before_validation :on => :create do
    unless self.category_display_order
      self.category_display_order = PublicBodyCategoryLink.next_display_order(public_body_heading_id)
    end
  end

  def self.next_display_order(heading_id)
    if last = where(:public_body_heading_id => heading_id).order(:category_display_order).last
      last.category_display_order + 1
    else
      0
    end
  end

end
