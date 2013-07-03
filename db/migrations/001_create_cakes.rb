Sequel.migration do
  up do
    create_table :cakes do
      primary_key :id
      foreign_key :parent_id, :cakes, on_delete: :set_null
      String :identifier, null: false
      TrueClass :infinity, default: false, null: false
      Float :size
    end
  end

  down do
    drop_table :cakes
  end
end
