import DestinyInventoryItemDefinition from './json/DestinyInventoryItemDefinition.json'
import DestinyPlugSetDefinition from './json/DestinyPlugSetDefinition.json'
import DestinyStatDefinition from './json/DestinyStatDefinition.json'

const getDestinyInventoryItemDefinition = (hash: string) =>
  (DestinyInventoryItemDefinition as any)[hash]

const getPlugSetDefinition = (hash: string) =>
  (DestinyPlugSetDefinition as any)[hash]

const getStatDefinition = (hash: string) => (DestinyStatDefinition as any)[hash]

const getPerkInfo = (perks?: { plugItemHash: number }[]) => {
  if (Array.isArray(perks) !== true || perks === undefined) {
    return []
  }

  return perks.map((perk) => {
    const hash = perk.plugItemHash.toString()
    const item = getDestinyInventoryItemDefinition(hash)
    const stats = item?.investmentStats || []
    const investmentStats = stats
      .filter((stat: any) => stat.value !== 0)
      .map((stat: any) => {
        const definition = getStatDefinition(stat.statTypeHash)

        return {
          statHash: definition?.hash,
          name: definition?.displayProperties?.name,
          description: definition?.displayProperties?.description,
          value: stat?.value,
          index: definition?.index,
        }
      })
      .sort((a: any, b: any) => a.index - b.index)

    return {
      name: item?.displayProperties?.name,
      description: item?.displayProperties?.description,
      type: item?.itemType,
      typeName: item?.itemTypeDisplayName,
      icon: item?.displayProperties?.icon,
      stats: investmentStats,
    }
  })
}

const getSockets = (item: any) => {
  const itemEntries = item?.sockets?.socketEntries || {}
  const entries = Object.values(itemEntries)
  const masterworkHash = 2218962841
  const trackerHash = 1282012138
  const intrinsicHash = 3956125808
  const weaponModHash = 711121010
  const shaderHash = 1288200359

  return entries
    .filter(
      (entry: any) =>
        entry?.socketTypeHash !== 0 &&
        entry?.socketTypeHash !== intrinsicHash &&
        entry?.socketTypeHash !== masterworkHash &&
        entry?.socketTypeHash !== shaderHash &&
        entry?.socketTypeHash !== trackerHash &&
        entry?.socketTypeHash !== weaponModHash
    )
    .map((entry: any) => {
      const reusablePlugSet = getPlugSetDefinition(entry.reusablePlugSetHash)
        ?.reusablePlugItems
      const randomizedPlugSet = getPlugSetDefinition(
        entry.randomizedPlugSetHash
      )?.reusablePlugItems
      const reusablePlugItems = entry.reusablePlugItems

      return {
        socketTypeHash: entry.socketTypeHash,
        intrinsicPerks: getPerkInfo(reusablePlugSet),
        randomPerks: getPerkInfo(randomizedPlugSet),
        curatedPerks: getPerkInfo(reusablePlugItems),
      }
    })
}

const getStats = (item: any) => {
  const itemStats = item?.stats?.stats || {}
  const stats = Object.values(itemStats)

  return stats
    .filter((stat: any) => stat.value !== 0)
    .map((stat: any) => {
      const definition = getStatDefinition(stat.statHash)

      return {
        statHash: definition?.hash,
        name: definition?.displayProperties?.name,
        description: definition?.displayProperties?.description,
        value: stat?.value,
        index: definition?.index,
      }
    })
    .sort((a: any, b: any) => a.index - b.index)
}

const getWeapon = (hash: number) => {
  const item = getDestinyInventoryItemDefinition(`${hash}`)

  if (item === null) {
    return 'not found'
  }

  const weapon = {
    itemhash: item.hash,
    name: item?.displayProperties?.name,
    description: item?.displayProperties?.description,
    type: item?.itemType,
    typeName: item?.itemTypeDisplayName,
    icon: item?.displayProperties?.icon,
    tierType: item?.inventory?.tierType,
    tierTypeName: item?.inventory?.tierTypeName,
    stats: getStats(item),
    perks: getSockets(item),
  }

  return weapon
}

const getWeapons = () => {
  const weaponType = 3
  const legendaryTier = 5
  const exoticTier = 6

  return Object.values(DestinyInventoryItemDefinition)
    .filter(
      (item: any) =>
        item?.itemType === weaponType &&
        (item?.inventory?.tierType === legendaryTier ||
          item?.inventory?.tierType === exoticTier)
    )
    .map((row: any) => getWeapon(row.hash))
}

console.log(JSON.stringify(getWeapons(), null, 2))
