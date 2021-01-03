import './Weapons.css'

import React, { useState } from 'react'
import { WeaponData } from './App'

interface WeaponProps {
  weaponData: WeaponData
  weaponType: string
}

const sortNumeric = (field: string, direction = 'asc') => (
  a: Record<string, number>,
  b: Record<string, number>
) => {
  const multiply = direction === 'desc' ? -1 : 1

  return a[field] > b[field]
    ? -1 * multiply
    : b[field] > a[field]
    ? 1 * multiply
    : 0
}

const pickWeapon = (weapons: WeaponData, type: string): Record<string, any> =>
  weapons.filter((weapon) => weapon.weaponType === type)[0]

const Weapons: React.FC<WeaponProps> = ({ weaponData, weaponType }) => {
  const { columns, data } = pickWeapon(weaponData, weaponType)
  const [sort, setSort] = useState<string>('')
  const [sortDirection, setSortDirection] = useState<string>('asc')

  if (columns === undefined || data === undefined) {
    return <div>No data..</div>
  }

  const sortClick = (field: string) => {
    const next = sortDirection === 'asc' ? 'desc' : 'asc'
    const direction = field !== sort ? 'asc' : next

    setSort(field)
    setSortDirection(direction)
  }

  return (
    <div>
      <table className="center">
        <thead>
          <tr>
            {columns.map((header: any, key: number) => {
              const onClick = header.sortable
                ? () => sortClick(header.field)
                : undefined
              return (
                <th key={key} onClick={onClick}>
                  {header.title}
                </th>
              )
            })}
          </tr>
        </thead>
        <tbody>
          {data
            .sort(sortNumeric(sort, sortDirection))
            .map((weapon: any, key: number) => (
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
