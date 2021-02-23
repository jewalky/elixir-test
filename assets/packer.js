// This is a custom-made hack over WebPack.

const chokidar = require('chokidar')
const webpack = require('webpack')
const sass = require('node-sass')
const CleanCSS = require('clean-css')
const fs = require('fs')

const webpackConf = require('./webpack.config.js')

const cssWatcher = chokidar.watch([__dirname+'/../lib/hello2_web/**/*.css', __dirname+'/../lib/hello2_web/**/*.scss'], {
    ignored: /(^|[\/\\])\../, // ignore dotfiles
    persistent: true
  });

const jsWatcher = chokidar.watch(__dirname+'/../lib/hello2_web/**/*.js', {
    ignored: /(^|[\/\\])\../, // ignore dotfiles
    persistent: true
  });

let cssPaths = []
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
    console.log('Building CSS from', cssPaths)
    let full_scss = ''
    cssPaths.forEach(path => {
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

let jsPaths = []
let jsTimeout = null

const scheduleJsChange = () => {
    if (jsTimeout !== null) {
        jsTimeout = setTimeout(handleJsChange, 500)
    } else {
        jsTimeout = setTimeout(handleJsChange, 0)
    }
}

const handleJsChange = () => {
    restartWebpackWatching(jsPaths)
}

cssWatcher
    .on('add', path => { cssPaths.push(path); scheduleCssChange() })
    .on('change', path => { scheduleCssChange() })
    .on('unlink', path => { cssPaths = cssPaths.filter(x => x !== path); scheduleCssChange() })

jsWatcher
    .on('add', path => { jsPaths.push(path); scheduleJsChange() })
    .on('unlink', path => { jsPaths.push(path); scheduleJsChange() })

let watching = null
let watchingIndex = 0

const restartWebpackWatching = (additionalPaths) => {
    const uIndex = ++watchingIndex
    const doWatch = () => {
        if (watchingIndex !== uIndex) {
            return
        }
        const compilerConf = webpackConf(null, { mode: 'development' })
        if (additionalPaths && additionalPaths.length) {
            compilerConf.entry['app-components'] = additionalPaths
        }
        const compiler = webpack(compilerConf)
        watching = compiler.watch({
            // Example [watchOptions](/configuration/watch/#watchoptions)
            aggregateTimeout: 300,
            poll: undefined
        }, (err, stats) => { // [Stats Object](#stats-object)
            // Print watch/build result here...
            console.log('Build finished')
            //console.log(stats);
        });
    }
    if (watching !== null) {
        console.log('Incompatible changes detected, restarting Webpack to adjust...')
        watching.close(() => doWatch())
    } else {
        console.log('Starting Webpack...')
        doWatch()
    }
}

scheduleJsChange()