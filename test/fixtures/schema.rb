ActiveRecord::Schema.define do
  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.decimal  "price"
    t.string   "type"
  end
end

