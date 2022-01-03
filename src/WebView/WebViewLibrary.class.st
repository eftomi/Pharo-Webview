"
I'm a FFILibrary which should point to webview.dll and webview.so stored locally as other uFFI libraries. Look also https://github.com/webview/webview for the installation & deploy.
"
Class {
	#name : #WebViewLibrary,
	#superclass : #FFILibrary,
	#category : #'WebView-Libraries'
}

{ #category : #'accessing - platform' }
WebViewLibrary >> macModuleName [
	^'libwebview.dylib'
]

{ #category : #'accessing - platform' }
WebViewLibrary >> unixModuleName [
	^'libwebview.so.1'
]

{ #category : #'accessing - platform' }
WebViewLibrary >> win32ModuleName [
	^ 'webview.dll'
]
