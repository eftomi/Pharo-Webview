"
I represent a multiplatform WebView window which displays and runs html, css, and js content, just like a web browser, however without any other typical browser elements (back button, tabs etc.) I'm being controlled by the operating system directly, Pharo controls me indirectly.

Typically I should be subclassed as in

WebView subclass: #MyWebView 
...

and created as a singleton using MyWebView class>>#uniqueInstance. If you wish to expose a block of code in Pharo to be accessible from javascript code in webview as a function (like for instance onclick=""callPharo(args)""), use MyWebView>>#registerCallbackBlock:nameInJS:.

Public API and Key Messages

- showContent: aString - if aString is valid URL I display its content. aString could also be a html or other document; in this case use proper content types at the beginning, for html this is for instance 'data:text/html, <!doctype html><html><head>...'
- width: height: hints: - sets the dimensions and my window type; see the method body for hints constants
- setTitleTo: aString - sets window title
- evalJS: and injectJS: - see the methods' body for description
- registerCallbackBlock:nameInJS: registers a webwiew callback that can be called from javascript running in the webview, exposed as nameInJS function

I'm actually implemented by a DLL library (https://github.com/webview/webview) on MS Windows and as a shared objects library on Linux. Besides this, I also need webview implementation for the specific platform - Edge or Edge/Chrome on MS Windows and Gtk3 + Gtk-webkit2 on Linux. Please look at the above GitHub address for specifics about deployment & installation on end user machine.

Due to synchronization incompleteness of this wrapper and library and to avoid memory leaks the WebView ""session"" is typically done like

wv := MyWebView uniqueInstance.							""create unuqueInstance""
wv showContent: 'https://www.pharo.org/'.				""show some content""
wv run.															""important for Linux implementation, on MS Windows it has no visible effect""
wv showContent: 'https://www.pharo.org/'.				""show some other content""
...

<close webview window manually>

wv terminate.													""terminate run process""
MyWebView clearUniqueInstance.								""to make sure that non-existing webview (as external object) can be called""

(I'm actually a FFIOpaqueObject, hiding the FFI calls to webview.dll or webview.so)
"
Class {
	#name : #WebView,
	#superclass : #FFIOpaqueObject,
	#instVars : [
		'gtkProcess'
	],
	#classVars : [
		'WEBVIEW_HINT_FIXED',
		'WEBVIEW_HINT_MAX',
		'WEBVIEW_HINT_MIN',
		'WEBVIEW_HINT_NONE'
	],
	#classInstVars : [
		'uniqueInstance',
		'webViewCallbacks'
	],
	#category : #'WebView-Core'
}

{ #category : #accessing }
WebView class >> clearUniqueInstance [
	uniqueInstance := nil.
	webViewCallbacks := nil.
]

{ #category : #finalization }
WebView class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	'finalizeResourceData je bil klican' traceCr .
	self uniqueInstance ffiDestroy.
	handle free.
	handle beNull
]

{ #category : #accessing }
WebView class >> uniqueInstance [ 
"check also if a window is closed/destroyed, use:
- windows: self ffiOSWindowsIsWindowVisible: self ffiGetWindow
- linux:
- macos:
If it is closed/destroyed, create new uniqueInstance"

	uniqueInstance 
		ifNil: [ uniqueInstance := self new ffiCreate ]
		ifNotNil: [ uniqueInstance handle isNull ifTrue: [ uniqueInstance := self new ffiCreate ] ].
	^uniqueInstance 
]

{ #category : #accessing }
WebView class >> webViewCallbacks [
	webViewCallbacks ifNil: [ webViewCallbacks := Dictionary new ].
	^ webViewCallbacks
]

{ #category : #'instance creation' }
WebView >> destroy [
	Smalltalk os isWindows "hack on MS Windows, ffiDestroy doesn't work on Windows and Linux"
		ifTrue: [ ^ self ffiOSWindowsDestroyWindow: self ffiGetWindow ] 
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
WebView >> ffiBindCallback: aFFICallback named: aString arguments: aByteString [
	^ self ffiCall: #(void webview_bind(WebView *self, const char * aString,
                              FFICallback aFFICallback, void * aByteString))

"// Binds a native C callback so that it will appear under the given name as a
// global JavaScript function. Internally it uses webview_init(). Callback
// receives a request string and a user-provided argument pointer. Request
// string is a JSON array of all the arguments passed to the JavaScript
// function.
WEBVIEW_API void webview_bind(webview_t w, const char *name,
                              void (*fn)(const char *seq, const char *req,
                                         void *arg),
                              void *arg);"
]

{ #category : #'ffi-calls' }
WebView >> ffiCreate [
	^ self ffiCall: #( WebView * webview_create(0, NULL) )
	
"// Creates a new webview instance. If debug is non-zero - developer tools will
// be enabled (if the platform supports them). Window parameter can be a
// pointer to the native window handle. If it's non-null - then child WebView
// is embedded into the given parent window. Otherwise a new window is created.
// Depending on the platform, a GtkWindow, NSWindow or HWND pointer can be
// passed here. Returns null on failure. Creation can fail for various reasons
// such as when required runtime dependencies are missing or when window creation
// fails.
WEBVIEW_API webview_t webview_create(int debug, void *window);"
]

{ #category : #'ffi-calls' }
WebView >> ffiDestroy [
	^ self ffiCall: #( void webview_destroy(WebView *self) )
	
"// Destroys a webview and closes the native window.
WEBVIEW_API void webview_destroy(webview_t w);"
]

{ #category : #'ffi-calls' }
WebView >> ffiEval: aString [
	^ self ffiCall: #( void webview_eval(WebView *self, char * aString) )
	
"// Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
// the result of the expression is ignored. Use RPC bindings if you want to
// receive notifications about the results of the evaluation.
WEBVIEW_API void webview_eval(webview_t w, const char *js);"
]

{ #category : #'ffi-calls' }
WebView >> ffiEventsPending [ 
	^ self ffiCall: #( int webview_events_pending(WebView *self)) 
]

{ #category : #'ffi-calls' }
WebView >> ffiGetWindow [
	^self ffiCall: #( void * webview_get_window(WebView *self) )
	
"// Returns a native window handle pointer. When using GTK backend the pointer
// is GtkWindow pointer, when using Cocoa backend the pointer is NSWindow
// pointer, when using Win32 backend the pointer is HWND pointer.
WEBVIEW_API void *webview_get_window(webview_t w);"
]

{ #category : #'ffi-calls' }
WebView >> ffiInit: aString [
	^ self ffiCall: #( void webview_init(WebView *self, const char * aString) )
	
"// Injects JavaScript code at the initialization of the new page. Every time
// the webview will open a the new page - this initialization code will be
// executed. It is guaranteed that code is executed before window.onload.
WEBVIEW_API void webview_init(webview_t w, const char *js);"
]

{ #category : #accessing }
WebView >> ffiLibrary [
	Smalltalk os isWindows ifTrue: [ ^ WebViewLibrary uniqueInstance ].
"	Smalltalk os isWindows ifTrue: [ ^ WebViewLibraryUsingWorker uniqueInstance ]."
	Smalltalk os isLinux ifTrue: [ ^ WebViewLibraryUsingWorker uniqueInstance ].
	Smalltalk os isMacOSX ifTrue: [ ^ WebViewLibraryUsingMainThreadRunner uniqueInstance ].

]

{ #category : #'ffi-calls' }
WebView >> ffiNavigateToUrl: aString [
	^ self ffiCall: #(void webview_navigate(WebView *self, const char *aString))
	
"// Navigates webview to the given URL. URL may be a properly encoded data URI.
// Examples:
// webview_navigate(w, ""https://github.com/webview/webview"");
// webview_navigate(w, ""data:text/html,%3Ch1%3EHello%3C%2Fh1%3E"");
// webview_navigate(w, ""data:text/html;base64,PGgxPkhlbGxvPC9oMT4="");
WEBVIEW_API void webview_navigate(webview_t w, const char *url);"
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

"// Allows to return a value from the native binding. Original request pointer
// must be provided to help internal RPC engine match requests with responses.
// If status is zero - result is expected to be a valid JSON result value.
// If status is not zero - result is an error JSON object.
WEBVIEW_API void webview_return(webview_t w, const char *seq, int status,
                                const char *result);"
]

{ #category : #'ffi-calls' }
WebView >> ffiRun [
	^ self ffiCall: #( void webview_run(WebView *self) )

"NOT TO BE EXECUTED ON WINDOWS, BECAUSE WEBVIEW USES PHARO'S MESSAGE LOOP"

"// Runs the main loop until it's terminated. After this function exits - you
// must destroy the webview.
WEBVIEW_API void webview_run(webview_t w);"
]

{ #category : #'ffi-calls' }
WebView >> ffiRunIteration [ 
	^ self ffiCall: #( void webview_run_iteration(WebView *self) )
]

{ #category : #'ffi-calls' }
WebView >> ffiTerminate [
	^ self ffiCall: #( void webview_terminate(WebView *self) )
	
"// Stops the main loop. It is safe to call this function from another other
// background thread.
WEBVIEW_API void webview_terminate(webview_t w);"
]

{ #category : #'ffi-calls' }
WebView >> ffiTitle: aString [
	^ self ffiCall: #( void webview_set_title(WebView *self, const char *aString) )
	
"// Updates the title of the native window. Must be called from the UI thread.
WEBVIEW_API void webview_set_title(webview_t w, const char *title);"
]

{ #category : #'ffi-calls' }
WebView >> ffiWidth: anIntegerWidth height: anIntegerHeight hints: anIntegerHints [
	^ self ffiCall: #(void webview_set_size
		(WebView *self, int anIntegerWidth, int anIntegerHeight, int anIntegerHints))
		
	
"// Window size hints
#define WEBVIEW_HINT_NONE 0  // Width and height are default size
#define WEBVIEW_HINT_MIN 1   // Width and height are minimum bounds
#define WEBVIEW_HINT_MAX 2   // Width and height are maximum bounds
#define WEBVIEW_HINT_FIXED 3 // Window size can not be changed by a user
// Updates native window size. See WEBVIEW_HINT constants.
WEBVIEW_API void webview_set_size(webview_t w, int width, int height,
                                  int hints);
"
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

{ #category : #window }
WebView >> navigateToURL: arg1 [

	self ffiNavigateToUrl: arg1
]

{ #category : #registering }
WebView >> registerCallbackBlock: aBlock nameInJS: aString [
"// Binds a native C callback so that it will appear under the given name as a
// global JavaScript function. Internally it uses webview_init(). Callback
// receives a request string and a user-provided argument pointer. Request
// string is a JSON array of all the arguments passed to the JavaScript
// function."
	| aWebViewCallback |
	aWebViewCallback := self 
		newCallbackWithSignature: #(void (String seq, String req, void * arg)) 
		block: [ :seq :req :arg | 
				aBlock value: (NeoJSONObject fromString: req)].

	self class webViewCallbacks at: aString put: aWebViewCallback.

	^ self ffiBindCallback: aWebViewCallback
	  	named: aString
	  	arguments: ExternalAddress new.
]

{ #category : #window }
WebView >> run [
	Smalltalk os isLinux ifTrue: [ 
		gtkProcess := [ self ffiRun ] forkAt: Processor lowestPriority named: 'WebView Main Loop'
 	].

]

{ #category : #window }
WebView >> setHtmlContent: aString [
"// Navigates webview to the given URL. URL may be a data URI, i.e.
// ""data:text/text,<html>...</html>"". It is often ok not to url-encode it
// properly, webview will re-encode it for you."
	self ffiSetHtmlTo: aString.
]

{ #category : #window }
WebView >> setTitleTo: aString [
"// Updates the title of the native window."
	self ffiTitle: aString
]

{ #category : #window }
WebView >> terminate [
	Smalltalk os isLinux ifTrue: [ 
		gtkProcess ifNotNil: [ gtkProcess terminate ]].
]

{ #category : #window }
WebView >> width: anIntegerWidth height: anIntegerHeight hints: anIntegerHints [
"// Window size hints
WEBVIEW_HINT_NONE 0  // Width and height are default size
WEBVIEW_HINT_MIN 1   // Width and height are minimum bounds
WEBVIEW_HINT_MAX 2   // Width and height are maximum bounds
WEBVIEW_HINT_FIXED 3 // Window size can not be changed by a user"
	self ffiWidth: anIntegerWidth 
		height: anIntegerHeight 
		hints: anIntegerHints.
]
