Class {
	#name : #WebViewLibraryUsingWorker,
	#superclass : #FFILibrary,
	#category : #'WebView-Libraries'
}

{ #category : #accessing }
WebViewLibraryUsingWorker class >> calloutAPIClass [
	^ TFCalloutAPI
]

{ #category : #accessing }
WebViewLibraryUsingWorker class >> runner [
	^ TFWorker default
]

{ #category : #accessing }
WebViewLibraryUsingWorker >> calloutAPIClass [
	^ TFCalloutAPI
]

{ #category : #'accessing - platform' }
WebViewLibraryUsingWorker >> macModuleName [
	^'libwebview.dylib'
]

{ #category : #accessing }
WebViewLibraryUsingWorker >> runner [
	^ TFWorker default
]

{ #category : #'accessing - platform' }
WebViewLibraryUsingWorker >> unixModuleName [
	^'libwebview.so.1'
]

{ #category : #'accessing - platform' }
WebViewLibraryUsingWorker >> win32ModuleName [
	^ 'webview.dll'
]
