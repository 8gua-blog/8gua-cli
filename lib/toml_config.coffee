path = require 'path'
toml = require 'toml'
tomlify = require('tomlify-j0.4')
fs = require 'fs-extra'


module.exports = (path)->
    new TomlConfig(path)

class TomlConfig
    constructor:(path)->
        @path = path
        @_str = undefined
        @_obj = undefined

    reload : (option)->
        @_str = undefined
        @_obj = undefined
        return @read(option)

    read : (option)->
        option = option or {}
        config = {}
        path = @path

        if not @_str
            try
                @_str = fs.readFileSync(path, 'utf-8')
            catch
                @_str = ''
            @_obj = config = toml.parse(@_str)
        else
            config = @_obj

        write = false
        for k,v of option
            if k not of config
                config[k] = v
                write = true

        if write
            @write(config)

        return config

    add : (obj)->
        _obj = (@_obj or @read())
        for k,v of obj
            if k of _obj
                Object.assign(_obj[k], v)
            else
                _obj[k] = v
        @write _obj

    set : (obj, value)->
        if typeof(obj) == 'string'
            _ = {}
            _[obj] = value
            obj = _
        @write({
            ... (@_obj or @read())
            ... obj
        })

    write : (config)->
        toml_str = tomlify.toToml(config,  {space: 0})
        if toml_str != @_str
            @_str = toml_str
            @_obj = config
            fs.writeFileSync(@path, toml_str)

