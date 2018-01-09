rp = require 'request-promise-native'
retry = require './retry'
coffeescript = require 'coffeescript'
dns = require './dns.coffee'
fs = require 'fs-extra'
path = require 'path'
require_from_string = require('require-from-string')

toml_config = require('./toml_config_8gua')

CONFIG_DEFAULT = require('./config_default')


require('./init_path')(
    path.resolve(__dirname, "../node_modules")
)

module.exports = ->
    CONFIG = toml_config.read CONFIG_DEFAULT
    cli_path = path.join(CONFIG.ROOT, 'cli')
    gua_path = path.join(cli_path, '8gua/boot/8gua.coffee')
    try
        gua = require gua_path
    catch err
        if await fs.pathExists(path.join(cli_path,'.git'))
            console.error(err)
            log = "启动失败，尝试重新初始化"
            await fs.remove(cli_path)
            process.chdir(__dirname)
        else
            log = "首次启动，尝试初始化"

        console.warn log

        retry.li(
            "获取引导脚本"
            ->
                await dns.txt_li("cli-boot."+CONFIG.HOST)
            (url)->
                rp(url)
        ).then (coffee)->
            js = coffeescript.compile coffee
            require_from_string(js)(
                module.exports
            )
        return
    gua()


