const puppeteer = require('puppeteer'); // eslint-disable-line semi
const argv = require('minimist')(process.argv.slice(2));

(async() => {
  // Required arguments
  /**
   * @url {string} full url to the page we are capturing
   */
  // url:
  if (!argv.url || argv.url.length === 0) {
    console.log('url is a required argument')
    return false
  }
  /**
   * @savePath {string} the full path we are saving the file to
   */
  if (!argv.savePath || argv.savePath.length === 0) {
    console.log('savePath is a required argument')
    return false
  }
  /**
   * @fileName {string} the name of the file to save as
   */
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
    await page.goto(argv.url, { waitUntil: 'networkidle' })
    // page.pdf() is currently supported only in headless mode.
    // @see https://bugs.chromium.org/p/chromium/issues/detail?id=753118
    await page.pdf(pdfOptions)

    await browser.close()
    console.log(`pdf generated: ${pdfOptions.path}`)
  } catch (err) {
    console.warn(err)
    process.exit()
  }
})()
