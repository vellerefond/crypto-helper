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

    compute: (methodKindType, input, key) ->
        console.log methodKindType, input, key
        return undefined unless methodKindType
        methodKind = null
        methodType = methodKindType.replace /^[^-]+\-/, (match) ->
            methodKind = match.replace /\-+$/, ''
            ''
        switch methodKind
            when 'hash'
                unless key
                    return @computeHash methodType, input
                return @computeHashHMAC methodType, input, key

    computeHash: (hashType, input) ->
        'hash: ' + input

    computeHashHMAC: (hashType, input, key) ->
        'hmac: ' + input + ':' + key
