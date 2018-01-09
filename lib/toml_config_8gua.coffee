toml_config = require('./toml_config')

os = require 'os'
path = require 'path'

HOME = os.homedir()

module.exports = toml_config(
    path.join(HOME,'.8gua.toml')
)

