import 'react-tabulator/lib/styles.css'
import 'react-tabulator/css/bootstrap/tabulator_bootstrap.min.css'
import './Weapons.css'

import React, { useMemo } from 'react'
import { ReactTabulator } from 'react-tabulator'

import { Stats, Weapons, WeaponStats } from '../data/processManifest'

interface WeaponProps {
  weapons: Weapons[]
  weaponType: string
  stats: Map<number, Stats>
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

const getStatForWeapon = (
  statHash: number,
  stats: WeaponStats[]
): number | undefined => {
  const stat = stats.filter((stat) => stat.statHash === statHash)

  return stat[0] ? stat[0].value : undefined
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
    sorter: 'numeric',
  }))
  const columns = [
    {
      title: 'Image',
      field: 'icon',
      formatter: 'image',
      formatterParams: {
        height: '70px',
        width: '70px',
      },
    },
    { title: 'Name', field: 'name', sorter: 'alphanum', width: 250 },
    { title: 'Tier', field: 'tier', sorter: 'alphanum' },
    ...statHeaders,
  ]

  const data = selectedWeapons.map((weapon) => {
    const weaponData: any = {
      id: weapon.hash,
      icon: `https://bungie.net${weapon.icon}`,
      name: weapon.name,
      tier: weapon.tierTypeName,
    }
    statColumns.forEach((stat) => {
      weaponData[`stat${stat.hash}`] = getStatForWeapon(stat.hash, weapon.stats)
    })

    return weaponData
  })

  return { columns, data }
}

const Weapons: React.FC<WeaponProps> = ({ weapons, weaponType, stats }) => {
  const { columns, data } = useMemo(
    () => prepareWeaponsData(weapons, stats, weaponType),
    [weapons, stats, weaponType]
  )

  return (
    <ReactTabulator
      data={data}
      columns={columns}
      tooltips={true}
      layout="fitDataFill"
    />
  )
}

export default Weapons
