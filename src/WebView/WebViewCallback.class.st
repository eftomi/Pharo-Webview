"
I'm a webview callback, I represent a Pharo code block exposed to be called as a javascript function from corresponding WebView. A block of code gets one argument (like [ :arg | ]) which is a NeoJSONObject with input arguments which are coming from javascript call. I cannot return any value from the block - use other ways to send data to WebView, like its methods evalJS: and injectJS:, setting new content with showContent:, or expose Web API from Pharo.

I'm useless without corresponding WebView. When you create me like this:

WebViewCallback subclass: #MyCallback1
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'SomePackage'
	
cb := MyCallback uniqueInstance 
   initializeWithBlock: [ :args | Transcript crShow: args asString ] 
   nameInJS: 'myFunc'.

you have to register me with a WebView:

wv := WebView new open 
	registerCallback: cb; 

So, you have to subclass me, then create a uniqueInstance of my new subclass, and set the block and the JS name with initializeWithBlock: nameInJS:. You can then call me with javascript from webview window with e.g. myFunc('first', 'second', 3.14) and you will get an Array of these three items in [ :args | ] block.

Public API and Key Messages

- initializeWithBlock: aBlock nameInJS: aString - a method to set the block of code and the name under which I will be visible from javascript as a function; aBlock gets one argument as NeoJSONObject from javascript call 
- nameInJS - returns my name (alias) in javascript
- ffiCallback - returns the actual FFICallback object that I create behind the scenes 

For an example, please see BasicTest>>testCallback in WebView-Tests package.

"
Class {
	#name : #WebViewCallback,
	#superclass : #Object,
	#instVars : [
		'nameInJS'
	],
	#classInstVars : [
		'uniqueInstance',
		'ffiCallback'
	],
	#category : #'WebView-Core'
}

{ #category : #accessing }
WebViewCallback class >> calloutAPIClass [
	^ TFCalloutAPI
]

{ #category : #accessing }
WebViewCallback class >> ffiCallback [

	^ ffiCallback
]

{ #category : #accessing }
WebViewCallback class >> ffiCallback: aFFICallback [

	ffiCallback := aFFICallback
]

{ #category : #accessing }
WebViewCallback class >> new [
	self error: 'Use #uniqueInstance'
]

{ #category : #accessing }
WebViewCallback class >> uniqueInstance [
	uniqueInstance ifNil: [ uniqueInstance := super new ].
	^ uniqueInstance
]

{ #category : #private }
WebViewCallback >> arguments [
	^ ExternalAddress new.
]

{ #category : #accessing }
WebViewCallback >> ffiCallback [
	^self class ffiCallback
]

{ #category : #initialization }
WebViewCallback >> initializeWithBlock: aBlock nameInJS: aString [
	nameInJS := aString.
	self class ffiCallback: (
		FFICallback
			signature: #(void (String seq, String req, void * arg))
			block: [ :seq :req :arg | 
				aBlock value: (NeoJSONObject fromString: req)
			]
	).

]

{ #category : #accessing }
WebViewCallback >> nameInJS [

	^ nameInJS
]
