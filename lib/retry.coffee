#{toArray} = require 'lodash'

module.exports = retry = (name, func)->
    ->
        args = arguments
        count = 0
        new Promise(
            (resolve, reject)->
                _ = ->
                    try
                        resolve await func.apply @, args
                    catch err
                        count += 1
                        console.warn "警报 : #{name} 失败 #{count} 次 ( #{err.message} ) ；三秒后重试"
                        setTimeout _, 3000
                _()
        )


retry.li = (name, li, func)->
    if typeof(li) == 'function'
        _get = ->
            return await li()
    else
        _get = ->
            return li

    new Promise(
        (resolve, reject)->
            _li = await _get()
            _ = (pos) ->
                console.log "\n** 开始 #{name}"
                func(_li[pos]).then(
                    ->
                        console.log "\n** 成功 #{name}"
                        resolve.apply @, arguments
                    (err)->
                        if err
                            console.error err
                        pos += 1
                        if pos < _li.length
                            _ pos
                        else
                            console.log "!! #{name} 失败，三秒后重试"
                            setTimeout(
                                ->
                                    _li = await _get()
                                    _ 0
                                3000
                            )
                )
            _(0)

    )

