class ProcessManifestJob < ActiveJob::Base
  queue_as :default

  def perform(database_file)
    @database_file = database_file

    raise "Invalid database" unless File.exist?(@database_file)

    update_stats
    update_items_and_values
  end

  private

    def db
      @db ||= SQLite3::Database.new(@database_file)
    end

    def update_stats
      result = db.execute("select * from DestinyStatDefinition")
      progressbar = progress_bar result.count, "Updating stats"

      result.each do |row|
        json = JSON.parse row.second

        stat = Stat.find_or_initialize_by stat_hash: json["statHash"]
        stat.stat_hash   = json["statHash"]
        stat.name        = json["statName"]
        stat.description = json["statDescription"]
        stat.save!

        progressbar.increment
      end
    end

    def update_items_and_values
      result = db.execute("select * from DestinyInventoryItemDefinition")
      progressbar = progress_bar result.count, "Updating items"

      result.each do |row|
        json = JSON.parse row.second

        item = Item.find_or_initialize_by item_hash: json["itemHash"]
        item.item_hash      = json["itemHash"]
        item.name           = json["itemName"]
        item.description    = json["itemDescription"]
        item.icon           = json["icon"]
        item.tier_type      = json["tierType"]
        item.tier_type_name = json["tierTypeName"]
        item.item_type_name = json["itemTypeName"]
        item.save!

        # loop default item stat values
        json["stats"].each do |v|
          insert_value(item, v)
        end

        # loop values from all sources
        sources = json["sources"] || []
        sources.each do |source|
          # loop stat values
          source["computedStats"].each do |v|
            insert_value(item, v)
          end
        end

        progressbar.increment
      end
    end

    def insert_value(item, v)
      hash = v.last

      value = item.values.find_or_initialize_by(
        stat_hash:     hash["statHash"],
        value:         hash["value"],
        minimum_value: hash["minimum"],
        maximum_value: hash["maximum"],
      )

      value.stat_hash        = hash["statHash"]
      value.value            = hash["value"]
      value.minimum_value    = hash["minimum"]
      value.maximum_value    = hash["maximum"]
      value.save!
    end

    def progress_bar(total, title)
      ProgressBar.create(
        format: "%t: %B (%p%% %e)",
        length: 80,
        throttle_rate: 1,
        title: title,
        total: total,
      )
    end
end
