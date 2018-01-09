{shuffle} = require 'lodash'
retry = require './retry'
dns = require("dns-then")

DNS_SERVER = shuffle require('./dns.json')
dns.setServers DNS_SERVER

module.exports = exports = {
    dns:  dns

    txt : retry 'TXT 域名解析', (domain)->
        return (await dns.resolveTxt(domain))[0][0]

    txt_li : (domain)->
        return (await exports.txt(domain)).split(' ')
}

