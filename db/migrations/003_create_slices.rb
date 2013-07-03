Sequel.migration do
  up do
    create_table :slices do
      primary_key :id
      foreign_key :cake_id, :cakes, on_delete: :cascade
      foreign_key :eater_id, :eaters, on_delete: :cascade
      String :identifier, null: false
      TrueClass :infinity, default: false, null: false
      Float :size
    end
  end

  down do
    drop_table :slices
  end
end
