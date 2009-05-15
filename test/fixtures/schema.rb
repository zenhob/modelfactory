ActiveRecord::Schema.define do
  create_table "defaults", :force => true do |t|
    t.string   "bar"
    t.integer  "baz"
  end
end

