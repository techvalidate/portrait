/* eslint no-console:0 */
const puppeteer = require('puppeteer')
const argv = require('minimist')(process.argv.slice(2))

render = (async() => {

  if (!argv.url || argv.url.length === 0) {
    console.log('url is a required argument')
    return false
  }
  if (!argv.savePath || argv.savePath.length === 0) {
    console.log('savePath is a required argument')
    return false
  }
  if (!argv.fileName || argv.fileName.length === 0) {
    console.log('fileName is a required argument')
    return false
  }

  const screenshotOptions = {
    path: argv.savePath + argv.fileName,
    fullPage: true,
    omitBackground: true,
    type: 'png'
  }

  try {
    const browser = await puppeteer.launch()
    const page = await browser.newPage()
    await page.goto(argv.url)
    await page.screenshot(screenshotOptions)
    await browser.close()
    console.log(`screenshot generated: ${screenshotOptions.path}`)
  } catch (err) {
    console.warn(err)
    process.exit()
  }
})()
