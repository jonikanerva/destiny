import { promises as fs } from 'fs'
import fetch from 'node-fetch'

import { config } from './config'

const getManifest = () =>
  fetch('https://www.bungie.net/Platform/Destiny2/Manifest/', {
    headers: { 'X-API-Key': config.bungieApiKey },
  }).then((res) => res.json())

const getContent = (path: string) => {
  console.log('Downloading: ', path)

  return fetch(`https://www.bungie.net${path}`)
    .then((res) => res.json())
    .then((json) => JSON.stringify(json, null, 2))
}

const storeToFile = (filename: string, data: string): Promise<void> =>
  fs.writeFile(`./data/json/${filename}.json`, data)

const storePath = ({
  name,
  path,
}: {
  name: string
  path: string
}): Promise<void> => getContent(path).then((data) => storeToFile(name, data))

const callInSequence = <T>(list: T[], fnc: (arg: T) => Promise<any>) =>
  list.reduce((memo, item) => memo.then(() => fnc(item)), Promise.resolve())

const dumpAll = () =>
  getManifest()
    .then(
      (manifest) => manifest?.Response?.jsonWorldComponentContentPaths?.en || {}
    )
    .then((paths: Record<string, string>) =>
      Object.entries(paths).map(([key, value]) => ({ name: key, path: value }))
    )
    .then((paths) => callInSequence(paths, storePath))
    .catch((error) => console.error(error))

dumpAll()
