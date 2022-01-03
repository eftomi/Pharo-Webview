Class {
	#name : #WebViewLibraryUsingWorker,
	#superclass : #WebViewLibrary,
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

{ #category : #accessing }
WebViewLibraryUsingWorker >> runner [
	^ TFWorker default.
]
