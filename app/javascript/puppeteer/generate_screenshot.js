const puppeteer = require('puppeteer')
const argv = require('minimist')(process.argv.slice(2))

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

  // optional arguments we set defaults for
  /**
   * @fullPage {boolean} Determines if full page is captured or just viewport
   */
  if (!argv.fullPage || argv.fileName.fullPage === 0) {
    argv.fullPage = false
  }
  /**
   * @omitBackground {boolean} Determines if page bg is transparent or not
   */
  if (!argv.omitBackground || argv.omitBackground.length === 0) {
    argv.omitBackground = false
  }
  /**
   * @type {string} 'png' or 'jpeg'
   */
  if (!argv.type || argv.omitBackground.type.length === 0) {
    argv.type = 'png'
  }
  /**
   * @quality {integer} 0-100. For jpeg only.
   */
  if (!argv.quality || argv.omitBackground.quality.length === 0) {
    argv.quality = 100
  }

  const screenshotOptions = {
    path: argv.savePath + argv.fileName,
    fullPage: argv.fullPage,
    omitBackground: argv.omitBackground,
    type: argv.type
  }

  if (argv.type === 'jpg') {
    screenshotOptions.quality = argv.quality
  }

  /*
  clip: <Object> An object which specifies clipping region of the page. Should have the following fields:
      x: <number> x-coordinate of top-left corner of clip area
      y: <number> y-coordinate of top-left corner of clip area
      width: <number> width of clipping area
      height; <number> height of clipping area
  */
  /**
   * @clip {object} Determines clipping attributes
   */
  const clip = {
    /**
     * @x {integer}
     */
    x: '',
    /**
     * @y {integer}
     */
    y: '',
    /**
     * @height {integer}
     */
    height: '',
    /**
     * @width {integer}
     */
    width: ''
  }

  // validate clip values and add them if the clip is valid
  if (argv.clipX && Number.isInteger(argv.clipX)) {
    clip.x = argv.clipX
  }
  if (argv.clipY && Number.isInteger(argv.clipY)) {
    clip.y = argv.clipY
  }
  if (argv.clipHeight && Number.isInteger(argv.clipHeight)) {
    clip.height = argv.clipHeight
  }
  if (argv.clipWidth && Number.isInteger(argv.clipWidth)) {
    clip.width = argv.clipWidth
  }
  if (Number.isInteger(clip.x) && Number.isInteger(clip.y) && Number.isInteger(clip.height) && Number.isInteger(clip.width)) {
    screenshotOptions.clip = clip
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
