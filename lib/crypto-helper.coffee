lib = require './crypto-helper-lib'

module.exports =
	activate: (state) ->

	deactivate: ->
		@cryptoHelperView.destroy() if @cryptoHelperView

	serialize: ->

	loadCryptoHelperView: ->
		@cryptoHelperView = new (require './crypto-helper-view') @ unless @cryptoHelperView

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
