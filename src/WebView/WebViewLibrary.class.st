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

{ #category : #'as yet unclassified' }
WebViewLibrary >> create [
	^ self ffiCall: #( void * webview_create(0, NULL) )
]

{ #category : #'as yet unclassified' }
WebViewLibrary >> destroy: webview [
	^ self ffiCall: #( void webview_destroy(void * webview) )
]

{ #category : #'as yet unclassified' }
WebViewLibrary >> eval: aString on: webview [
	^ self ffiCall: #( void webview_eval(void * webview, const char * aString) )
]

{ #category : #'as yet unclassified' }
WebViewLibrary >> init: aString on: webview [
	^ self ffiCall: #( void webview_init(void * webview, const char * aString) )
]

{ #category : #'as yet unclassified' }
WebViewLibrary >> navigate: webview toUrl: aString [
	^ self ffiCall: #(void webview_navigate(void * webview, const char *aString))
]

{ #category : #running }
WebViewLibrary >> run: webview [ 
	^ self ffiCall: #( void webview_run(void * webview) )
]

{ #category : #initialization }
WebViewLibrary >> setSizeFor: webview width: anIntegerWidth height: anIntegerHeight hits: anIntegerHints [
	^ self ffiCall: #(void webview_set_size
		(void * webview, int anIntegerWidth, int anIntegerHeight, int anIntegerHints))
]

{ #category : #initialization }
WebViewLibrary >> setTitleOf: webview to: aString [
	^ self ffiCall: #( void webview_set_title(void * webview, const char *aString) )
]

{ #category : #'ffi-calls' }
WebViewLibrary >> terminate: webview [
	^ self ffiCall: #( void webview_terminate(void * webview) )
]

{ #category : #'accessing - platform' }
WebViewLibrary >> win32ModuleName [
	^ 'webview.dll'
]
