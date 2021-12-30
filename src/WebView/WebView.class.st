"
I represent a multiplatform WebView window which displays and runs html, css, and js content, just like a web browser, however without any other typical browser elements (back button, tabs etc.) I'm being controlled by the operating system directly, Pharo controls me indirectly.

I'm standalone. If you wish to expose a block of code in Pharo to be accessible from javascript code in webview as a function (like for instance onclick=""callPharo(args)""), subclass WebViewCallback, make a uniqueInstance and set the block and its name in js (see comment in WebViewCallback).

Public API and Key Messages

- open - ""WebView new open"" opens a new window; create new WebView for each of the windows/browsers that you need to be displayed  
- close - closes the window 
- setTitleTo: aString - sets window title
- showContent: aString - if aString is valid URL I display its content. aString could also be a html or other document; in this case use proper content types at the beginning, for html this is for instance 'data:text/html, <!doctype html><html><head>...'
- width: height: hints: - sets the dimensions and my window type; see the method body for hints constants
- evalJS: and injectJS: - see the methods' body for description
- registerCallback: registers a WebViewCallback subclass

I'm actually implemented by a DLL library (https://github.com/webview/webview). Besides this DLL, I also need webview implementation for the specific platform. Please look at the above GitHub address for specifics about deployment & installation on end user machine.

(I'm actually a FFIOpaqueObject, hiding the FFI calls to webview.dll)
"
Class {
	#name : #WebView,
	#superclass : #FFIOpaqueObject,
	#instVars : [
		'webViewCallback',
		'gtkProcess'
	],
	#classVars : [
		'GtkProc',
		'WEBVIEW_HINT_FIXED',
		'WEBVIEW_HINT_MAX',
		'WEBVIEW_HINT_MIN',
		'WEBVIEW_HINT_NONE'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WebView-Core'
}

{ #category : #accessing }
WebView class >> uniqueInstance [ 
	uniqueInstance 
		ifNil: [ uniqueInstance := self new ffiCreate ]
		ifNotNil: [ uniqueInstance handle isNull ifTrue: [ uniqueInstance := self new ffiCreate ] ].
	^uniqueInstance
]

{ #category : #'instance creation' }
WebView >> destroy [
	Smalltalk os isWindows "hack, ffiDestroy doesn't work on Windows and Linux"
		ifTrue: [ ^ self ffiOSWindowsDestroyWindow: (self ffiGetWindow pinInMemory) ] 
		ifFalse: [ ^ self ffiDestroy ].
]

{ #category : #window }
WebView >> evalJS: aString [
"// Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
// the result of the expression is ignored. Use RPC bindings if you want to
// receive notifications about the results of the evaluation."
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
WebView >> ffiEventsPending [ 
	^ self ffiCall: #( int webview_events_pending(WebView *self)) 
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
	Smalltalk os isWindows ifTrue: [ ^ WebViewLibrary uniqueInstance ].
	Smalltalk os isLinux ifTrue: [ ^ WebViewLibraryUsingWorker uniqueInstance ].
	Smalltalk os isMacOSX ifTrue: [ ^ WebViewLibrary uniqueInstance ].
"	^ WebViewLibraryUsingWorker uniqueInstance."
]

{ #category : #'ffi-calls' }
WebView >> ffiNavigate: aString [
	^ self ffiCall: #(void webview_navigate(WebView *self, const char *aString))
]

{ #category : #'ffi-calls' }
WebView >> ffiOSWindowsDestroyWindow: hWnd [
	^self ffiCall: #(int DestroyWindow(ExternalAddress hWnd))  library: WinUser32.
]

{ #category : #'ffi-calls' }
WebView >> ffiOSWindowsIsWindowVisible: hWnd [
	^self ffiCall: #(bool IsWindowVisible(ExternalAddress hWnd))  library: WinUser32.
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
WebView >> ffiRunIteration [ 
	^ self ffiCall: #( void webview_run_iteration(WebView *self) )
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
	self ffiInit: aString.
]

{ #category : #registering }
WebView >> registerCallbackBlock: aBlock nameInJS: aString [
"// Binds a native C callback so that it will appear under the given name as a
// global JavaScript function. Internally it uses webview_init(). Callback
// receives a request string and a user-provided argument pointer. Request
// string is a JSON array of all the arguments passed to the JavaScript
// function."
	webViewCallback := self 
		newCallbackWithSignature: #(void (String seq, String req, void * arg)) 
		block: [ :seq :req :arg | 
				aBlock value: (NeoJSONObject fromString: req)].

	^ self ffiCallback: webViewCallback
	  	name: aString
	  	arguments: ExternalAddress new.
]

{ #category : #window }
WebView >> run [
	Smalltalk os isLinux ifTrue: [ 
		gtkProcess := [ self ffiRun ] forkAt: Processor lowestPriority named: 'WebView Main Loop'
 	].
	Smalltalk os isMacOSX ifTrue: [ 
		gtkProcess := [ self ffiRun ] forkAt: Processor lowestPriority named: 'WebView Main Loop'
 	].
]

{ #category : #window }
WebView >> setTitleTo: aString [
"// Updates the title of the native window."
	self ffiTitle: aString
]

{ #category : #window }
WebView >> showContent: aString [
"// Navigates webview to the given URL. URL may be a data URI, i.e.
// ""data:text/text,<html>...</html>"". It is often ok not to url-encode it
// properly, webview will re-encode it for you."
	self ffiNavigate: aString.
]

{ #category : #window }
WebView >> terminate [
	Smalltalk os isLinux ifTrue: [ 
		gtkProcess ifNotNil: [ gtkProcess terminate ]].
]

{ #category : #window }
WebView >> width: anIntegerWidth height: anIntegerHeight hits: anIntegerHints [
"// Window size hints
WEBVIEW_HINT_NONE 0  // Width and height are default size
WEBVIEW_HINT_MIN 1   // Width and height are minimum bounds
WEBVIEW_HINT_MAX 2   // Width and height are maximum bounds
WEBVIEW_HINT_FIXED 3 // Window size can not be changed by a user"
	self ffiWidth: anIntegerWidth 
		height: anIntegerHeight 
		hits: anIntegerHints.
]
