// This is a custom-made hack over WebPack.

const chokidar = require('chokidar')
const webpack = require('webpack')
const sass = require('node-sass')
const CleanCSS = require('clean-css')
const fs = require('fs')

const webpackConf = require('./webpack.config.js')

const compiler = webpack(webpackConf(null, { mode: 'development' }))

const watcher = chokidar.watch([__dirname+'/../lib/hello2_web/**/*.css', __dirname+'/../lib/hello2_web/**/*.scss'], {
    ignored: /(^|[\/\\])\../, // ignore dotfiles
    persistent: true
  });

let paths = []
let cssTimeout = null

const scheduleCssChange = () => {
    if (cssTimeout !== null) {
        clearTimeout(cssTimeout)
        cssTimeout = setTimeout(handleCssChange, 500)
    } else {
        cssTimeout = setTimeout(handleCssChange, 0)
    }
}

const handleCssChange = () => {
    console.log('Building CSS from', paths)
    let full_scss = ''
    paths.forEach(path => {
        full_scss += fs.readFileSync(path) + '\n'
    })
    const scss_result = sass.renderSync({
        data: full_scss
    }).css.toString()
    const minified_result = new CleanCSS().minify(scss_result).styles
    const output_css_location = __dirname+'/../priv/static/css/app-components.css'
    console.log('Writing to', output_css_location)
    fs.writeFileSync(output_css_location, minified_result)
}

const log = console.log.bind(console)
watcher
  .on('add', path => { paths.push(path); scheduleCssChange() })
  .on('change', path => { scheduleCssChange() })
  .on('unlink', path => { paths = paths.filter(x => x !== path); scheduleCssChange() })

const watching = compiler.watch({
    // Example [watchOptions](/configuration/watch/#watchoptions)
    aggregateTimeout: 300,
    poll: undefined
}, (err, stats) => { // [Stats Object](#stats-object)
    // Print watch/build result here...
    console.log('Build finished')
    //console.log(stats);
});
