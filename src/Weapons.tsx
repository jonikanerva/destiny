import './Weapons.css'

import React from 'react'

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

const pick = (object: any, key: any): any => object[key]

const Weapons: React.FC<WeaponProps> = ({ weapons, weaponType, stats }) => {
  const { columns, data } = prepareWeaponsData(weapons, stats, weaponType)

  return (
    <div>
      <table className="center">
        <thead>
          <tr>
            {columns.map((header, key) => (
              <th key={key}>{header.title}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.map((weapon, key) => (
            <tr
              key={`${weapon.type}${key}`}
              className={key % 2 ? 'even' : 'odd'}
            >
              {columns.map((column, key) => {
                if (column.field === 'icon') {
                  return (
                    <td key={key} className="image">
                      <img height={70} src={pick(weapon, column.field)} />
                    </td>
                  )
                }

                return (
                  <td key={key} width={column.width}>
                    {pick(weapon, column.field)}
                  </td>
                )
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default Weapons
