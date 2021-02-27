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
// run ts-node data/processManifest.ts

interface Stats {
  hash: number
  name: string
  description: string
}

interface WeaponStats {
  statHash: number
  value: number
  minimum: number
  maximum: number
  displayMaximum: number
}

interface Weapons {
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

const weaponTypeStats = (
  weapons: Weapons[],
  stats: Map<number, Stats>
): Stats[] => {
  const statColumns = new Map<number, Stats>()

  weapons.forEach((weapon) =>
    weapon.stats.forEach((stat) => {
      const value = stats.get(stat.statHash)

      if (value && value.name !== '') {
        statColumns.set(stat.statHash, value)
      }
    })
  )

  return [...statColumns.values()]
}

const getStatForWeapon = (statHash: number, stats: WeaponStats[]): number => {
  const stat = stats.filter((stat) => stat.statHash === statHash)

  return stat[0] ? stat[0].value : 0
}

const prepareWeaponsData = (
  weapons: Weapons[],
  stats: Map<number, Stats>,
  weaponType: string
) => {
  const selectedWeapons = weapons.filter(
    (weapon) => weapon.typeName === weaponType
  )
  const statColumns = weaponTypeStats(selectedWeapons, stats)
  const statHeaders = statColumns.map((stat) => ({
    title: stat.name,
    field: `stat${stat.hash}`,
    width: 50,
    sortable: true,
  }))
  const columns = [
    { title: '', field: 'icon' },
    { title: 'Name', field: 'name', width: undefined },
    ...statHeaders,
  ]

  const data = selectedWeapons.map((weapon) => {
    const weaponData = {
      id: weapon.hash,
      icon: `https://bungie.net${weapon.icon}`,
      name: weapon.name,
      tier: weapon.tierTypeName,
      type: weapon.type,
    }
    const statsData: { [key: string]: number } = Object.assign(
      {},
      ...statColumns.map((stat) => ({
        [`stat${stat.hash}`]: getStatForWeapon(stat.hash, weapon.stats),
      }))
    )

    return { ...weaponData, ...statsData }
  })

  return { columns, data }
}

const getStats = () =>
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

const getWeapons = () =>
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

const uniqueWeaponTypes = (weapons: Weapons[]): string[] =>
  [...new Set(weapons.map((weapon) => weapon.typeName))].sort()

const uniqueStats = (stats: Stats[]): Map<number, Stats> => {
  const statsMap = new Map<number, Stats>()

  stats.forEach((stat) => {
    statsMap.set(stat.hash, stat)
  })

  return statsMap
}

const processManifest = () => {
  console.log('Processing...')

  return Promise.all([getStats(), getWeapons()])
    .then(([stats, weapons]) => {
      const weaponTypes = uniqueWeaponTypes(weapons)
      const statsData = uniqueStats(stats)

      return weaponTypes.map((weaponType) => {
        const { columns, data } = prepareWeaponsData(
          weapons,
          statsData,
          weaponType
        )

        return {
          weaponType,
          columns,
          data,
        }
      })
    })
    .then((weaponData) =>
      fs.writeFile('./data/weaponData.json', JSON.stringify(weaponData))
    )
    .then(() => console.log('Done, wrote ./data/weaponData.json'))
    .catch((error) => console.error(error))
}

processManifest()
