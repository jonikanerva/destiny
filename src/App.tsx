import './App.css'

import React, { useState } from 'react'

import weaponData from '../data/weaponData.json'
import Weapons from './Weapons'

const weaponTypes = weaponData.map((weapon) => weapon.weaponType)

export type WeaponData = typeof weaponData

const App: React.FC = () => {
  const [weaponType, setWeaponType] = useState<string>(weaponTypes[0])

  return (
    <div className="appContent">
      <div className="weaponSelect">
        <label htmlFor="weaponType">Choose a weapon type:</label>
        <select
          name="weaponType"
          onChange={(e) => setWeaponType(e.target.value)}
        >
          {weaponTypes.map((type, key) => (
            <option key={key} value={type}>
              {type}
            </option>
          ))}
        </select>
      </div>
      <Weapons weaponData={weaponData} weaponType={weaponType} />
    </div>
  )
}
export default App
