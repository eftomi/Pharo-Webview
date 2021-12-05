Class {
	#name : #BasicTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'webview'
	],
	#category : #'WebView-Tests'
}

{ #category : #running }
BasicTest >> setUp [
	super setUp.
	
	library := WebViewLibrary uniqueInstance.
]

{ #category : #tests }
BasicTest >> testCreateEvalDestroy [
	webview := library create.
	library eval: 'alert("Greetings from eval!")' on: webview.
	library run: webview.
	library terminate: webview.
	library destroy: webview.

]

{ #category : #tests }
BasicTest >> testCreateInitDestroy [
	webview := library create.
	library init: 'alert("Greetings from init!")' on: webview.
	library setTitleOf: webview to: 'Some title'.
	library navigate: webview toUrl: 'https://www.google.com'.
	library destroy: webview.

]

{ #category : #tests }
BasicTest >> testCreateNavigateDestroy [
	webview := library create.
	library setTitleOf: webview to: 'Some title'.
	library navigate: webview toUrl: 'https://www.google.com'.
	library destroy: webview.

]

{ #category : #tests }
BasicTest >> testCreateResizeDestroy [
	webview := library create.
	library setTitleOf: webview to: 'Some title'.
	library setSizeFor: webview width: 800 height: 500 hits: 3.
	library destroy: webview.

]

{ #category : #tests }
BasicTest >> testCreateRunTerminateDestroy [
	webview := library create.
	library run: webview.
	library terminate: webview.
	library destroy: webview.

]

{ #category : #tests }
BasicTest >> testCreateTitleDestroy [
	webview := library create.
	library setTitleOf: webview to: 'Some title'.
	library destroy: webview.

]
