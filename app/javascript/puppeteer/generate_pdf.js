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

  const pdfOptions = {
    path: argv.savePath + argv.fileName
  }


  try {
    const browser = await puppeteer.launch()
    const page = await browser.newPage()
    page.emulateMedia('screen')
    await page.goto(argv.url)

    if (argv.selector && argv.selector.length > 0) {
      const selector = argv.selector
      const rect = await page.evaluate((selector) => {
        const element = document.querySelector(selector)
        if (!element) {
          return null
        }
        const { x, y, width, height } = element.getBoundingClientRect()
        return { left: x, top: y, width, height, id: element.id }
      }, selector)
      if (rect !== null) {
        pdfOptions.width = rect.width
        pdfOptions.height = rect.height + 30
      } else {
        pdfOptions.format = 'Letter'
      }
    } else {
      pdfOptions.format = 'Letter'
    }

    await page.pdf(pdfOptions)
    await browser.close()
  } catch (err) {
    console.warn(err)
    process.exit()
  }
})()
