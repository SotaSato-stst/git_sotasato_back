/** @type {import('vls').VeturConfig} */
module.exports = {
  projects: [
    './web_front',
    {
      root: './web_front',
      package: './web_front/package.json',
      tsconfig: './web_front/tsconfig.json',
    }
  ]
}
