import './Weapons.css'

import React from 'react'
import { WeaponData } from './App'

interface WeaponProps {
  weaponData: WeaponData
  weaponType: string
}

const pickWeapon = (weapons: WeaponData, type: string): Record<string, any> =>
  weapons.filter((weapon) => weapon.weaponType === type)[0]

const Weapons: React.FC<WeaponProps> = ({ weaponData, weaponType }) => {
  const { columns, data } = pickWeapon(weaponData, weaponType)

  if (columns === undefined || data === undefined) {
    return <div>No data..</div>
  }

  return (
    <div>
      <table className="center">
        <thead>
          <tr>
            {columns.map((header: any, key: number) => (
              <th key={key}>{header.title}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.map((weapon: any, key: number) => (
            <tr
              key={`${weapon.type}${key}`}
              className={key % 2 ? 'even' : 'odd'}
            >
              {columns.map((column: any, key: number) => {
                if (column.field === 'icon') {
                  return (
                    <td key={key} className="image">
                      <img height={70} src={weapon[column.field]} />
                    </td>
                  )
                }

                return (
                  <td key={key} width={column.width}>
                    {weapon[column.field]}
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
