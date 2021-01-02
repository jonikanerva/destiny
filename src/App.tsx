import './App.css'

import React, { useState } from 'react'

import { Stats } from '../data/processManifest'
import statsJson from '../data/stats.json'
import weapons from '../data/weapons.json'
import Weapons from './Weapons'

const stats = new Map<number, Stats>()
const weaponTypes = [
  ...new Set(weapons.map((weapon) => weapon.typeName)),
].sort()

statsJson.forEach((stat) => {
  stats.set(stat.hash, stat)
})

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
      <Weapons weapons={weapons} weaponType={weaponType} stats={stats} />
    </div>
  )
}
export default App
