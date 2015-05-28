{ $, View } = require 'atom-space-pen-views'

module.exports =
class CryptoHelperView extends View
	@content: ->
		@div class: 'crypto-helper overlay from-top'

	initialize: (cryptoHelper) ->
		@cryptoHelper = @cryptoHelper or cryptoHelper

	getEntryView: () ->

	attach: (viewModeParameters, items) ->
		###
		@viewModeParameters = viewModeParameters
		@self = atom.workspace.addModalPanel item: @
		$content = $(atom.views.getView atom.workspace).find '.project-ring-file-select'
		unless @isInitialized
			$controls = $content.find('.controls')
			$controls.find('input:button.confirm').on 'click', => @confirmed()
			$controls.find('input:button.cancel').on 'click', => @destroy()
			$controls.find('input:button.select-all').on 'click', => @setAllEntriesSelected true
			$controls.find('input:button.deselect-all').on 'click', => @setAllEntriesSelected false
			@isInitialized = true
		$content.find('.controls .confirm').val @viewModeParameters.confirmValue
		$entries = $content.find('.entries').empty()
		unless items.length
			$entries.append ($ '<div>There are no files available for opening.</div>').addClass 'empty'
			return
		for { title, description, path } in items
			$entries.append @getEntryView title: title, description: description, path: path
		###

	destroy: ->
		@self.destroy()

	confirmed: ->
		###
		bufferPaths = []
		$(atom.views.getView atom.workspace).find('.project-ring-file-select .entries input:checkbox.checked').each (index, element) ->
				bufferPaths.push $(element).attr 'data-path'
		@destroy()
		@projectRing.handleProjectRingFileSelectViewSelection @viewModeParameters, bufferPaths
		###
