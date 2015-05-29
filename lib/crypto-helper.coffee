lib = require './crypto-helper-lib'

onConfigChanged = (value) ->
	lib.setOption @.toString(), value

getInput = ->
	editor = atom.workspace.getActiveEditor()
	return unless editor
	editor.getSelectedText() or editor.getText()

module.exports =
	config:
		turnOutputToUpperCase: { type: 'boolean', default: true, description: 'Turn output to upper case' }
		defaultOutputEncoding: { type: 'string', default: 'hex', enum: [ 'utf8', 'hex', 'base64' ], description: 'The default encoding of the result' }

	activate: (state) ->
		validConfigKeys = Object.keys @config
		configChanged = false
		cryptoHelperConfigurationSettings = atom.config.settings['crypto-helper'] or {}
		for confKey in Object.keys cryptoHelperConfigurationSettings
			unless confKey in validConfigKeys
				delete atom.config.settings['crypto-helper'][confKey]
				configChanged = true
		atom.config.save() if configChanged
		atom.config.observe 'crypto-helper.turnOutputToUpperCase', onConfigChanged.bind 'uc'
		atom.config.observe 'crypto-helper.defaultOutputEncoding', onConfigChanged.bind 'defOutEnc'
		atom.commands.add 'atom-workspace', 'crypto-helper:hash-sha512', => @hash 'sha512'
		atom.commands.add 'atom-workspace', 'crypto-helper:convert-to-base64', => @convert 'base64', 'to'
		atom.commands.add 'atom-workspace', 'crypto-helper:convert-from-base64', => @convert 'base64', 'from'
		window.l = lib # TODO: remove

	deactivate: ->
		@cryptoHelperView.destroy() if @cryptoHelperView

	serialize: ->

	loadCryptoHelperView: ->
		@cryptoHelperView = new (require './crypto-helper-view') @ unless @cryptoHelperView

	hash: (alg) ->
		return unless lib.isSupportedHashAlg(alg)
		input = getInput()
		return unless input
		hash = lib.hash.hash alg, input
		@loadCryptoHelperView()

	convert: (format, dir) ->
		return unless lib.isSupportedConversionFormat(format) and dir in [ 'to', 'from' ]
		input = getInput()
		return unless input
		result = lib.convert[dir]('base64', input)
		@loadCryptoHelperView()
