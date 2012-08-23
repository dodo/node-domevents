[![build status](https://secure.travis-ci.org/dodo/node-domevents.png)](http://travis-ci.org/dodo/node-domevents)
# [domevents](https://github.com/dodo/node-domevents)

This Package provides the EventEmitter API for [DOM Events](http://www.w3.org/TR/DOM-Level-2-Events/events.html).

## usage

```javascript
DomEventEmitter = require('domevents').EventEmitter; // if you have a require available
DomEventEmitter = window.DomEventEmitter; // if you are in the browser

var div = new DomEventEmitter(document.getElementById('div'), false);
div.on('click', function (event) {
    /* do something here */
});
```

First argument is the element from which you want to receive the events (defaults to `document`).

Second argument is the [`useCapture`](http://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-Registration-interfaces) argument of the normal [DOM API](http://www.w3.org/TR/DOM-Level-3-Events/#event-flow).
