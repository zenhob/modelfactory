ActiveRecord::Schema.define do
  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.decimal  "price"
    t.string   "type"
    t.integer  "category_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
  end
end

