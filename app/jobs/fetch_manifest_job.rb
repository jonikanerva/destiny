class FetchManifestJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    db_file = "/Users/joni/Desktop/world_sql_content_05feb511d99733ad8d1bbe60465007c1.content"

    SQLite3::Database.new(db_file) do |db|
      db.execute("select * from DestinyStatDefinition") do |row|
        json = JSON.parse row.second

        stat = Stat.find_or_initialize_by(stat_id: json["statHash"])
        stat.stat_id = json["statHash"]
        stat.name = json["statName"]
        stat.description = json["statDescription"]
        stat.save!
      end
    end
  end
end
