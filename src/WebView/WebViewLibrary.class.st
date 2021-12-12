Class {
	#name : #WebViewLibrary,
	#superclass : #FFILibrary,
	#classVars : [
		'WEBVIEW_HINT_FIXED',
		'WEBVIEW_HINT_MAX',
		'WEBVIEW_HINT_MIN',
		'WEBVIEW_HINT_NONE'
	],
	#category : #'WebView-Libraries'
}

{ #category : #initialization }
WebViewLibrary class >> initialize [
	WEBVIEW_HINT_NONE := 0.
	WEBVIEW_HINT_MIN := 1.
	WEBVIEW_HINT_MAX := 2.
	WEBVIEW_HINT_FIXED := 3.
]

{ #category : #'accessing - platform' }
WebViewLibrary >> win32ModuleName [
	^ 'webview.dll'
]
