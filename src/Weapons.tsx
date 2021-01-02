import './Weapons.css'

import React, { useMemo } from 'react'

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
    name: stat.name,
    type: 'number',
  }))
  const headers = [
    { name: 'image', type: 'image' },
    { name: 'name', type: 'text' },
    { name: 'tier', type: 'text' },
    ...statHeaders,
  ]

  const data = selectedWeapons.map((weapon) => {
    const statData = statColumns.map((stat) => ({
      [stat.hash]: getStatForWeapon(stat.hash, weapon.stats),
    }))

    return [
      { icon: `https://bungie.net${weapon.icon}` },
      { name: weapon.name },
      { tier: weapon.tierTypeName },
      ...statData,
    ]
  })

  return { headers, data }
}

const Weapons: React.FC<WeaponProps> = ({ weapons, weaponType, stats }) => {
  const selectedWeapons = weapons.filter(
    (weapon) => weapon.typeName === weaponType
  )
  const statColumns = weaponTypeStats(selectedWeapons, stats)

  const { headers, data } = useMemo(
    () => prepareWeaponsData(weapons, stats, weaponType),
    [weapons, stats, weaponType]
  )

  console.log('tällänen', headers, data)

  return (
    <div>
      <table className="center">
        <thead>
          <tr>
            <th></th>
            <th className="name">Name</th>
            <th className="tier">Tier</th>
            {statColumns.map((stat, key) => (
              <th key={key} className="stat">
                {stat.name}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {selectedWeapons.map((weapon, key) => (
            <tr
              key={`${weaponType}${key}`}
              className={key % 2 ? 'even' : 'odd'}
            >
              <td className="image">
                <img
                  src={`https://bungie.net${weapon.icon}`}
                  className="image"
                />
              </td>
              <td className="name">{weapon.name}</td>
              <td className={weapon.tierTypeName}>{weapon.tierTypeName}</td>
              {statColumns.map((stat, key) => (
                <td key={key} className="stat">
                  {getStatForWeapon(stat.hash, weapon.stats)}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default Weapons
