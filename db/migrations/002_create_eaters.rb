Sequel.migration do
  up do
    create_table :eaters do
      primary_key :id
      String :identifier, null: false
    end
  end

  down do
    drop_table :eaters
  end
end
