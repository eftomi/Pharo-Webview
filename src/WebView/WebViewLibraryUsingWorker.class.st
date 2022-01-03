Class {
	#name : #WebViewLibraryUsingWorker,
	#superclass : #WebViewLibrary,
	#category : #'WebView-Libraries'
}


{ #category : #accessing }
WebViewLibraryUsingWorker >> calloutAPIClass [
	^ TFCalloutAPI
]

{ #category : #accessing }
WebViewLibraryUsingWorker >> runner [
	^ TFWorker default.
]
