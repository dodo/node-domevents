{ EventEmitter } = require 'events'

# browser polyfills

detectBrowser = (element) ->
    # html5
    return if element?.addEventListener?
        'html5'
    # ie compatibility
    else if element?.attachEvent?
        'ie'
    # old way
    else
        'on'

addEventListener = (element, event, listener, useCapture, mode) ->
    if mode is 'html5'
        element.addEventListener(event, listener, useCapture)
    else if mode is 'ie'
        element.attachEvent("on#{event}", listener)
    else if mode is 'on'
        element["on#{event}"] = listener
    else if mode is 'ext'
        event =  event.charAt(0).toUpperCase() + event.substr(1)
        console.log(event)
        element["on#{event}"].addListener(listener)

removeEventListener = (element, event, listener, useCapture, mode) ->
    if mode is 'html5'
        element.removeEventListener(event, listener, useCapture)
    else if mode is 'ie'
        element.detachEvent("on#{event}", listener)
    else if mode is 'on'
        delete element["on#{event}"]
    else if mode is 'ext'
        event =  event.charAt(0).toUpperCase() + event.substr(1)
        element["on#{event}"].removeListener(listener)



class DomEventEmitter extends EventEmitter

    constructor: (@element = document, @useCapture = false) ->
        @_domevents = []
        @setMode()

    setMode: (@mode) ->
        @mode ?= detectBrowser(@element)
        return this

    addListener: (event) ->
        # only register once, broadcasting is done by EventEmitter
        unless @_domevents[event]?
            listener = @emit.bind(this, event)
            addEventListener(@element, event, listener, @useCapture, @mode)
            @_domevents[event] = listener
        super

    removeListener: (event) ->
        # only remove when last listener gets removed
        if @_domevents[event]? and @listeners(event).length is 1
            removeEventListener(@element,event,@_domevents[event],@useCapture,@mode)
        super

    removeAllListener: (event) ->
        # there will be none listeners left
        removeEventListener(@element, event, @_domevents[event], @useCapture, @mode)
        super

    on: @::addListener


# exports

module.exports = {
    EventEmitter:DomEventEmitter
}

( ->
    @DomEventEmitter = DomEventEmitter
).call window if process.title is 'browser'
