import 'react-tabulator/lib/styles.css'
import 'react-tabulator/css/bootstrap/tabulator_bootstrap.min.css'
import './Weapons.css'

import React from 'react'
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
    sorter: 'number',
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
    { title: 'Name', field: 'name', sorter: 'string', width: 250 },
    { title: 'Tier', field: 'tier', sorter: 'string' },
    ...statHeaders,
  ]

  const data = selectedWeapons.map((weapon) => {
    const weaponData = {
      id: weapon.hash,
      icon: `https://bungie.net${weapon.icon}`,
      name: weapon.name,
      tier: weapon.tierTypeName,
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

const Weapons: React.FC<WeaponProps> = ({ weapons, weaponType, stats }) => {
  const { columns, data } = prepareWeaponsData(weapons, stats, weaponType)

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