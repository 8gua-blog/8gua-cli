{ spawn } = require('child_process')

module.exports = (cmd, options)->
    console.log "\n$ #{cmd}\n"
    new Promise(
        (resolve, reject)->
            cmd = cmd.split(' ')
            ls = spawn(cmd.shift(), cmd, options)
            ls.stdout.pipe(process.stdout)
            ls.stderr.pipe(process.stderr)
            # ls.stdout.on('data', (data) =>
            #     console.log("#{data}")
            # )

            # ls.on(
            #     'error'
            #     ->
            #         reject -1
            # )
            ls.on(
                'close'
                 (code) =>
                    if code
                        reject(code)
                    else
                        resolve()
            )
    )

