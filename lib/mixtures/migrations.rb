class CreateSchemaMigrations < ActiveRecord::Migration
  def self.up
    create_table :schema_migrations, :id => false do |t|
      t.string :migration
    end
  end
  
  def self.down
    drop_table :schema_migrations
  end
end

tables_result = ActiveRecord::Base.connection.execute("SHOW TABLES")
tables = []
while t = tables_result.fetch_row do
  tables << t[0]
end
CreateSchemaMigrations.migrate(:up) unless tables.include?("schema_migrations")
migrations_result = ActiveRecord::Base.connection.execute("SELECT * FROM schema_migrations")
migrations = []
while m = migrations_result.fetch_row do
  migrations << m[0]
end

class CreateDatasets < ActiveRecord::Migration
  def self.up
    create_table :datasets do |t|
      t.string :name
      t.timestamps
    end
    execute "INSERT INTO schema_migrations (migration) VALUES ('create_datasets')"
  end
  
  def self.down
    drop_table :datasets
    execute "DELETE FROM schema_migrations WHERE migration = 'create_datasets'"
  end
end

CreateDatasets.migrate(:up) unless migrations.include?("create_datasets")

class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records, :id => false do |t|
      t.string :table
      t.integer :dataset_id
      t.text :data
      t.integer :id
      t.timestamps
    end
    
    add_index :records, :id
    add_index :records, :table
    add_index :records, :dataset_id
    execute "INSERT INTO schema_migrations (migration) VALUES ('create_records')"
  end
  
  def self.down
    drop_table :records
  end
end

CreateRecords.migrate(:up) unless migrations.include?('create_records')