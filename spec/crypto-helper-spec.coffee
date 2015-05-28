{WorkspaceView} = require 'atom'
CryptoHelper = require '../lib/crypto-helper'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CryptoHelper", ->
  activationPromise = null

  beforeEach ->
	atom.workspaceView = new WorkspaceView
	activationPromise = atom.packages.activatePackage('crypto-helper')

  describe "when the crypto-helper:toggle event is triggered", ->
	it "attaches and then detaches the view", ->
	  expect(atom.workspaceView.find('.crypto-helper')).not.toExist()

	  # This is an activation event, triggering it will cause the package to be
	  # activated.
	  atom.workspaceView.trigger 'crypto-helper:toggle'

	  waitsForPromise ->
		activationPromise

	  runs ->
		expect(atom.workspaceView.find('.crypto-helper')).toExist()
		atom.workspaceView.trigger 'crypto-helper:toggle'
		expect(atom.workspaceView.find('.crypto-helper')).not.toExist()
