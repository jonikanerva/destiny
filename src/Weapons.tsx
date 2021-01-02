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

const getStatForWeapon = (
  statHash: number,
  stats: WeaponStats[]
): number | undefined => {
  const stat = stats.filter((stat) => stat.statHash === statHash)

  return stat[0] ? stat[0].value : undefined
}

const Weapons: React.FC<WeaponProps> = ({ weapons, weaponType, stats }) => {
  const selectedWeapons = weapons.filter(
    (weapon) => weapon.typeName === weaponType
  )
  const statColumns = weaponTypeStats(selectedWeapons, stats)

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
