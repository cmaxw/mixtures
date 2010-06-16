module Mixtures
  def self.import(options = {})
    options = {:host => "localhost", :user => "root", :password => "", :dataset => "default"}.merge(options)
    db = Mysql.connect(options[:host], options[:user], options[:password], options[:database])
    dataset = Dataset.find_or_create_by_name(options[:dataset])
    dataset.records.destroy_all
    table_results = db.query("SHOW TABLES")
    while t = table_results.fetch_row do
      import_table(t[0], dataset, db)
    end
  end
  
  def self.import_table(table_name, dataset, db)
    records = db.query("SELECT * FROM #{table_name}")
    while record = records.fetch_hash do
      new_record = dataset.records.create(:data => record.to_json, :table => table_name) do |nr|
        nr.id = record["id"]
      end
    end
  end
end