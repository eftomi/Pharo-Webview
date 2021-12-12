Class {
	#name : #WebView,
	#superclass : #FFIOpaqueObject,
	#classVars : [
		'WEBVIEW_HINT_FIXED',
		'WEBVIEW_HINT_MAX',
		'WEBVIEW_HINT_MIN',
		'WEBVIEW_HINT_NONE'
	],
	#classInstVars : [
		'webviews'
	],
	#category : #'WebView-Core'
}

{ #category : #initialization }
WebView class >> initialize [
	webviews := OrderedCollection new.
]

{ #category : #'instance creation' }
WebView >> close [
	self isNull 
		ifFalse: [ self ffiDestroy ]
]

{ #category : #'instance creation' }
WebView >> ensureOpen [
	self isNull 
		ifTrue: [ ^ self ffiCreate ]
		ifFalse: [ ^ self ]
]

{ #category : #window }
WebView >> evalJS: aString [
"// Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
// the result of the expression is ignored. Use RPC bindings if you want to
// receive notifications about the results of the evaluation."
	self ensureOpen.
	self ffiEval: aString.
]

{ #category : #'ffi-calls' }
WebView >> ffiCallback: aFFICallback name: aString arguments: aByteString [
	^ self ffiCall: #(void webview_bind(WebView *self, const char * aString,
                              FFICallback aFFICallback, void * aByteString))
]

{ #category : #'ffi-calls' }
WebView >> ffiCreate [
	^ self ffiCall: #( WebView * webview_create(0, NULL) )
]

{ #category : #'ffi-calls' }
WebView >> ffiDestroy [
	^ self ffiCall: #( void webview_destroy(WebView *self) )
]

{ #category : #'ffi-calls' }
WebView >> ffiEval: aString [
	^ self ffiCall: #( void webview_eval(WebView *self, const char * aString) )
]

{ #category : #'ffi-calls' }
WebView >> ffiGetWindow [
	^self ffiCall: #( void *webview_get_window(WebView *self) )
]

{ #category : #'ffi-calls' }
WebView >> ffiInit: aString [
	^ self ffiCall: #( void webview_init(WebView *self, const char * aString) )
]

{ #category : #accessing }
WebView >> ffiLibrary [
	^ WebViewLibrary
]

{ #category : #'ffi-calls' }
WebView >> ffiNavigate: aString [
	^ self ffiCall: #(void webview_navigate(WebView *self, const char *aString))
]

{ #category : #'ffi-calls' }
WebView >> ffiReturnSeq: aStringSeq status: anInteger result: aStringResult [
	self ffiCall: #( void webview_return(WebWiew *self, const char *aStringSeq, int anInteger,
                                const char *aStringResult) )
]

{ #category : #'ffi-calls' }
WebView >> ffiRun [
	^ self ffiCall: #( void webview_run(WebView *self) )
]

{ #category : #'ffi-calls' }
WebView >> ffiTerminate [
	^ self ffiCall: #( void webview_terminate(WebView *self) )
]

{ #category : #'ffi-calls' }
WebView >> ffiTitle: aString [
	^ self ffiCall: #( void webview_set_title(WebView *self, const char *aString) )
]

{ #category : #'ffi-calls' }
WebView >> ffiWidth: anIntegerWidth height: anIntegerHeight hits: anIntegerHints [
	^ self ffiCall: #(void webview_set_size
		(WebView *self, int anIntegerWidth, int anIntegerHeight, int anIntegerHints))
]

{ #category : #'ffi-calls' }
WebView >> initialize [
	super initialize.
	WEBVIEW_HINT_NONE := 0.
	WEBVIEW_HINT_MIN := 1.
	WEBVIEW_HINT_MAX := 2.
	WEBVIEW_HINT_FIXED := 3.
	
	
]

{ #category : #window }
WebView >> injectJS: aString [
"// Injects JavaScript code at the initialization of the new page. Every time
// the webview will open a the new page - this initialization code will be
// executed. It is guaranteed that code is executed before window.onload."
	self ensureOpen.
	self ffiInit: aString.
]

{ #category : #'instance creation' }
WebView >> open [
	self isNull 
		ifTrue: [ ^ self ffiCreate ]
		ifFalse: [ ^ self ]
]

{ #category : #registering }
WebView >> registerCallback: aWebViewCallback [
"// Binds a native C callback so that it will appear under the given name as a
// global JavaScript function. Internally it uses webview_init(). Callback
// receives a request string and a user-provided argument pointer. Request
// string is a JSON array of all the arguments passed to the JavaScript
// function."
	self ensureOpen.
	^ self ffiCallback: aWebViewCallback ffiCallback
	  name: aWebViewCallback nameInJS
	  arguments: aWebViewCallback arguments.
]

{ #category : #window }
WebView >> setTitleTo: aString [
"// Updates the title of the native window."
	self ensureOpen.
	self ffiTitle: aString
]

{ #category : #window }
WebView >> showContent: aString [
"// Navigates webview to the given URL. URL may be a data URI, i.e.
// ""data:text/text,<html>...</html>"". It is often ok not to url-encode it
// properly, webview will re-encode it for you."
	self ensureOpen.
	self ffiNavigate: aString.
]

{ #category : #window }
WebView >> width: anIntegerWidth height: anIntegerHeight hits: anIntegerHints [
"// Window size hints
WEBVIEW_HINT_NONE 0  // Width and height are default size
WEBVIEW_HINT_MIN 1   // Width and height are minimum bounds
WEBVIEW_HINT_MAX 2   // Width and height are maximum bounds
WEBVIEW_HINT_FIXED 3 // Window size can not be changed by a user"
	self ensureOpen.
	self ffiWidth: anIntegerWidth 
		height: anIntegerHeight 
		hits: anIntegerHints.
]
