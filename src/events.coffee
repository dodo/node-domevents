{ EventEmitter } = require 'events'

# browser polyfills

addEventListener = (element, event, listener, useCapture) ->
    # html5
    if element?.addEventListener?
        element.addEventListener(event, listener, useCapture)
    # ie compatibility
    else if element?.attachEvent?
        element.attachEvent("on#{event}", listener)
    # old way
    else
        element?["on#{event}"] = listener

removeEventListener = (element, event, listener, useCapture) ->
    # html5
    if element?.removeEventListener?
        element.removeEventListener(event, listener, useCapture)
    # ie compatibility
    else if element?.detachEvent?
        element.detachEvent("on#{event}", listener)
    # old way
    else
        delete element?["on#{event}"]



class DomEventEmitter extends EventEmitter

    constructor: (@element = document, @useCapture = false) ->
        @_domevents = []

    addListener: (event) ->
        # only register once, broadcasting is done by EventEmitter
        unless @_domevents[event]?
            listener = @emit.bind(this, event)
            addEventListener(@element, event, listener, @useCapture)
            @_domevents[event] = listener
        super

    removeListener: (event) ->
        # only remove when last listener gets removed
        if @_domevents[event]? and @listeners(event).length is 1
            removeEventListener(@element,event,@_domevents[event],@useCapture)
        super

    removeAllListener: (event) ->
        # there will be none listeners left
        removeEventListener(@element, event, @_domevents[event], @useCapture)
        super

    on: @::addListener


# exports

module.exports = {
    EventEmitter:DomEventEmitter
}

( ->
    @DomEventEmitter = DomEventEmitter
).call window if process.title is 'browser'
