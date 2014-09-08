{View, EditorView} = require 'atom'
crypto = require 'crypto'

module.exports =
class CryptoHelperView extends View
    cryptoHelper: null

    input: null

    key: null

    method: null

    outputFormat: null

    result: null

    @content: ->
        @div class: 'crypto-helper overlay from-top', =>
            @select class: 'method', =>
                ###
                @option '--- Ciphers ---', { value: '' }
                crypto.getCiphers().forEach (cipher) =>
                    @option cipher, { value: 'cipher-' + cipher }
                ###
                @option '--- Hashes ---', value: ''
                crypto.getHashes().forEach (hash) =>
                    @option hash, value: 'hash-' + hash
            @select class: 'output-format', =>
                @option '--- Output Format ---', value: ''
                @option 'HEX', value: 'hex'
                @option 'Base64', value: 'base64'
            @subview 'input', new EditorView { mini: true, placeholderText: 'Input to compute...' }
            @subview 'key', new EditorView { mini: true, placeholderText: 'Key for computation...' }
            @div class: 'crypto-helper-result'
            @input { type: 'button', class: 'cancel', value: 'Close' }
            @input { type: 'button', class: 'confirm', value: 'Compute' }
            @input { type: 'button', class: 'clear', value: 'Clear' }

    initialize: (cryptoHelper) ->
        @cryptoHelper = cryptoHelper
        atom.workspaceView.command "crypto-helper:toggle", => @toggle()
        # @input.on 'core:confirm', => @confirmed()
        @input.on 'core:cancel', => @destroy()
        @key.on 'core:confirm', => @confirmed()
        @key.on 'core:cancel', => @destroy()
        setTimeout (
                =>
                    @method = atom.workspaceView.find '.crypto-helper > select.method' unless @list
                    @outputFormat = atom.workspaceView.find '.crypto-helper > select.output-format' unless @list
                    @result = atom.workspaceView.find '.crypto-helper-result' unless @result
                    (atom.workspaceView.find '.crypto-helper .confirm').on 'click', => @confirmed()
                    (atom.workspaceView.find '.crypto-helper .cancel').on 'click', => @destroy()
                    (atom.workspaceView.find '.crypto-helper .clear').on 'click', => @clear()
            ),
            0

    serialize: ->

    destroy: ->
        @detach()

    toggle: ->
        if @hasParent()
            @result.text ''
            @detach()
        else
            atom.workspaceView.append @
            @input.focus()

    confirmed: ->
        @result.text @cryptoHelper.compute @method.val(), @input.getText(), @key.getText(), @outputFormat.val()

    clear: ->
        @input.setText ''
        @key.setText ''
        @result.text ''
