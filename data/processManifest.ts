import sqlite3 from 'sqlite3'
import { open } from 'sqlite'
import { promises as fs } from 'fs'

// curl https://www.bungie.net/Platform/Destiny2/Manifest/ --header 'X-API-Key: YOUR_BUNGIE_KEY' | jq '.Response.mobileWorldContentPaths.en'
//
// download the file given at Response.mobileWorldContentPaths.en
// curl https://www.bungie.net/[Response.mobileWorldContentPaths.en] -o database.zip
//
// unzip database.zip
// rename to database.db

export interface Stats {
  hash: number
  name: string
  description: string
}

export interface WeaponStats {
  statHash: number
  value: number
  minimum: number
  maximum: number
  displayMaximum: number
}

export interface Weapons {
  hash: number
  name: string
  description: string
  type: number
  typeName: string
  icon: string
  tierType: number
  tierTypeName: string
  stats: WeaponStats[]
}

const dbConfig = {
  filename: `${__dirname}/database.db`,
  mode: sqlite3.OPEN_READONLY,
  driver: sqlite3.Database,
}

open(dbConfig)
  .then((db) => db.all('select json from DestinyStatDefinition'))
  .then((result) =>
    result.map((row) => {
      const stat = JSON.parse(row.json)

      return {
        hash: stat?.hash,
        name: stat?.displayProperties?.name,
        description: stat?.displayProperties?.description,
      }
    })
  )
  .then((stats: Stats[]) =>
    fs.writeFile('./data/stats.json', JSON.stringify(stats))
  )
  .catch((error) => console.error(error))

open(dbConfig)
  .then((db) => db.all('select json from DestinyInventoryItemDefinition'))
  .then((result) =>
    result.map((row) => {
      const item = JSON.parse(row.json)
      const itemStats = item?.stats?.stats || {}
      const stats: WeaponStats[] = Object.values(itemStats)

      return {
        hash: item.hash,
        name: item?.displayProperties?.name,
        description: item?.displayProperties?.description,
        type: item?.itemType,
        typeName: item?.itemTypeDisplayName,
        icon: item?.displayProperties?.icon,
        tierType: item?.inventory?.tierType,
        tierTypeName: item?.inventory?.tierTypeName,
        stats: stats.filter((stat) => stat?.value !== 0),
      }
    })
  )
  .then((items: Weapons[]) => items.filter((item) => item?.type === 3))
  .then((items: Weapons[]) =>
    items.filter((item) => item?.tierType === 5 || item?.tierType === 6)
  )
  .then((weapons) =>
    fs.writeFile('./data/weapons.json', JSON.stringify(weapons))
  )
  .catch((error) => console.error(error))
