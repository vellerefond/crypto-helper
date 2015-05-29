crypto = require 'crypto'

hashAlgs = [ 'md5', 'sha', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'whirlpool' ]
convFmts = [ 'base64' ]
options = new Map([ [ 'uc', true ], [ 'defInEnc', 'utf8' ], [ 'defOutEnc', 'hex' ] ])
convHelpers =
	base64: (input, dir) ->
		return unless dir in [ 'to', 'from' ]
		result = undefined
		switch dir
			when 'to' then result = new Buffer(input, 'utf8').toString 'base64'
			when 'from' then result = new Buffer(input, 'base64').toString()
			else
		result

module.exports = Object.freeze
	getSupportedHashAlgs: ->
		algs = []
		algs.push alg for alg in hashAlgs
		algs

	isSupportedHashAlg: (alg) ->
		alg in hashAlgs

	getSupportedConversionFormats: ->
		formats = []
		formats.push format for format in convFmts
		formats

	isSupportedConversionFormat: (format) ->
		format in convFmts

	setOption: (key, value) ->
		return unless options.has(key) and typeof value isnt 'undefined'
		options.set key, value
		undefined

	getOption: (key) ->
		return options.get key

	hash: Object.freeze
		hash: (alg, input, inEnc, outEnc) ->
			inEnc = if typeof inEnc is 'string' then inEnc else options.get 'defInEnc'
			outEnc = if typeof outEnc is 'string' then outEnc else options.get 'defOutEnc'
			res = crypto.Hash(alg).update(input, inEnc).digest outEnc
			res = res.toUpperCase() if options.get('uc') and outEnc isnt 'bin'
			res

		md5: (input, inEnc, outEnc) ->
			@hash 'md5', input, inEnc, outEnc

		sha: (input, inEnc, outEnc) ->
			@hash 'sha', input, inEnc, outEnc

		sha1: (input, inEnc, outEnc) ->
			@hash 'sha1', input, inEnc, outEnc

		sha224: (input, inEnc, outEnc) ->
			@hash 'sha224', input, inEnc, outEnc

		sha256: (input, inEnc, outEnc) ->
			@hash 'sha256', input, inEnc, outEnc

		sha384: (input, inEnc, outEnc) ->
			@hash 'sha384', input, inEnc, outEnc

		sha512: (input, inEnc, outEnc) ->
			@hash 'sha512', input, inEnc, outEnc

		whirlpool: (input, inEnc, outEnc) ->
			@hash 'whirlpool', input, inEnc, outEnc

	convert: Object.freeze
		to: (format, input, inEnc, outEnc) ->
			return unless format in Object.keys convHelpers
			convHelpers[format](input, 'to', inEnc, outEnc)

		from: (format, input, inEnc, outEnc) ->
			return unless format in Object.keys convHelpers
			convHelpers[format](input, 'from', inEnc, outEnc)
