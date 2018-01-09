{uniq} = require "lodash"

module.exports = (path_li ...)=>
    env_path = process.env.NODE_PATH

    path_li.concat(if env_path then env_path.split(":") else [])

    process.env.NODE_PATH = uniq(path_li).join(":")

    require('module').Module._initPaths()

