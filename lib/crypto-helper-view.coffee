{View, EditorView} = require 'atom'
crypto = require 'crypto'

module.exports =
class CryptoHelperView extends View
    cryptoHelper: null

    input: null

    key: null

    list: null

    result: null

    @content: ->
        @div class: 'crypto-helper overlay from-top', =>
            @select =>
                ###
                @option '--- Ciphers ---', { value: '' }
                crypto.getCiphers().forEach (cipher) =>
                    @option cipher, { value: 'cipher-' + cipher }
                ###
                @option '--- Hashes ---', value: ''
                crypto.getHashes().forEach (hash) =>
                    @option hash, value: 'hash-' + hash
            @subview 'input', new EditorView { mini: true, placeholderText: 'Input to compute...' }
            @subview 'key', new EditorView { mini: true, placeholderText: 'Key for computation...' }
            @div class: 'crypto-helper-result'
            @input { type: 'button', class: 'cancel', value: 'Close' }
            @input { type: 'button', class: 'confirm', value: 'Compute' }

    initialize: (cryptoHelper) ->
        @cryptoHelper = cryptoHelper
        atom.workspaceView.command "crypto-helper:toggle", => @toggle()
        # @input.on 'core:confirm', => @confirmed()
        @input.on 'core:cancel', => @destroy()
        @key.on 'core:confirm', => @confirmed()
        @key.on 'core:cancel', => @destroy()
        setTimeout (
                =>
                    @list = atom.workspaceView.find '.crypto-helper > select' unless @list
                    @result = atom.workspaceView.find '.crypto-helper-result' unless @result
                    (atom.workspaceView.find '.crypto-helper .confirm').on 'click', => @confirmed()
                    (atom.workspaceView.find '.crypto-helper .cancel').on 'click', => @destroy()
            ),
            0

    serialize: ->

    destroy: ->
        @detach()

    toggle: ->
        if @hasParent()
            @input.setText ''
            @key.setText ''
            @result.text ''
            @detach()
        else
            atom.workspaceView.append @
            @input.focus()

    confirmed: ->
        result = @cryptoHelper.compute @list.val(), @input.getText(), @key.getText()
        return unless result
        @result.text result
