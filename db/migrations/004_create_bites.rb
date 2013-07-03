Sequel.migration do
  up do
    create_table :bites do
      primary_key :id
      foreign_key :slice_id, :slices, on_delete: :cascade
      Float :size, null: false
      Time :occured_at, null: false
      TrueClass :phonecall, default: false
      TrueClass :estimation, default: false
    end
  end

  down do
    drop_table :bites
  end
end
