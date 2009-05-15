
class StrictWidget < Widget
  validates_presence_of     :name
  validates_numericality_of :price
end

