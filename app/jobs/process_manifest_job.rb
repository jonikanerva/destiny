class ProcessManifestJob < ActiveJob::Base
  queue_as :default

  def perform(database_file)
    @database_file = database_file

    raise 'Invalid database' unless File.exist?(@database_file)

    Value.delete_all
    Item.delete_all

    update_stats
    update_items_and_values
  end

  private

    def db
      @db ||= SQLite3::Database.new(@database_file)
    end

    def update_stats
      result = db.execute('select * from DestinyStatDefinition')
      progressbar = progress_bar result.count, 'Updating stats'

      # this is what a stat object looks like
      # {
      #   "displayProperties": {
      #     "description": "Increases the speed at which you regain lost health.",
      #     "name": "Recovery",
      #     "icon": "/common/destiny2_content/icons/452c215c3ccaac0f9825b443e9d030c5.png",
      #     "hasIcon": true
      #   },
      #   "aggregationType": 1,
      #   "hasComputedBlock": false,
      #   "interpolate": false,
      #   "hash": 1943323491,
      #   "index": 5,
      #   "redacted": false
      # }

      result.each do |row|
        json = JSON.parse row.second

        stat = Stat.find_or_initialize_by stat_hash: json['hash']
        stat.stat_hash   = json['hash']
        stat.name        = json['displayProperties']['name']
        stat.description = json['displayProperties']['description']
        stat.save!

        progressbar.increment
      end
    end

    def update_items_and_values
      result = db.execute('select * from DestinyInventoryItemDefinition')
      progressbar = progress_bar result.count, 'Updating items'

      result.each do |row|
        json = JSON.parse row.second

        item = Item.find_or_initialize_by item_hash: json['hash']
        item.item_hash      = json['hash']
        item.name           = json['displayProperties']['name']
        item.description    = json['displayProperties']['description']
        item.icon           = json['displayProperties']['icon']
        item.tier_type      = json['inventory']['tierType']
        item.tier_type_name = json['inventory']['tierTypeName']
        item.item_type_name = json['itemType']
        item.save!

        progressbar.increment
        next

        values = json['stats'] || []
        values.each do |v|
          insert_value(item, v)
        end

        # loop all drop sources
        sources = json['sources'] || []
        sources.each do |source|
          # check if item still drops
          spawns = source['spawnIndexes']
          disabled = spawns.empty? || (spawns.count == 1 && spawns.first.zero?)

          # skip if this item does not drop anymore
          next if disabled

          # loop stat values
          values = source['computedStats'] || []
          values.each do |v|
            insert_value(item, v, false)
          end
        end

        progressbar.increment
      end
    end

    def insert_value(item, v, default_value = true)
      hash = v.last

      value = item.values.find_or_initialize_by stat_hash: hash['statHash']
      value.stat_hash     = hash['statHash']
      value.value         = hash['value']   if default_value # default value only from default
      value.minimum_value = hash['minimum'] if value.minimum_value.nil? || hash['minimum'] < value.minimum_value
      value.maximum_value = hash['maximum'] if value.maximum_value.nil? || hash['maximum'] > value.maximum_value
      value.save!
    end

    def progress_bar(total, title)
      ProgressBar.create(
        format: '%t: [%B] (%j%% %e)',
        length: 80,
        throttle_rate: 1,
        title: title,
        total: total,
      )
    end
end
