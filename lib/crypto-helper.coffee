crypto = require 'crypto'
CryptoHelperView = require './crypto-helper-view'

module.exports =
    cryptoHelperView: null

    activate: (state) ->
        @cryptoHelperView = new CryptoHelperView @

    deactivate: ->
        @cryptoHelperView.destroy()

    serialize: ->
        cryptoHelperViewState: @cryptoHelperView.serialize()

    compute: (methodKindType, input, key, outputFormat) ->
        console.log methodKindType, input, key
        return undefined unless methodKindType
        methodKind = null
        methodType = methodKindType.replace /^[^-]+\-/, (match) ->
            methodKind = match.replace /\-+$/, ''
            ''
        switch methodKind
            when 'hash'
                unless key
                    return @computeHash methodType, input, outputFormat
                return @computeHashHMAC methodType, input, key, outputFormat

    computeHash: (hashType, input, outputFormat) ->
        return crypto.createHash(hashType).update(input, 'utf8').digest(outputFormat)

    computeHashHMAC: (hashType, input, key, outputFormat) ->
        'hmac: ' + input + ':' + key
