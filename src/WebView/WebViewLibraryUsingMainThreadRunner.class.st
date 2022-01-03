Class {
	#name : #WebViewLibraryUsingMainThreadRunner,
	#superclass : #WebViewLibrary,
	#category : #'WebView-Libraries'
}

{ #category : #accessing }
WebViewLibraryUsingMainThreadRunner >> calloutAPIClass [
	^ TFCalloutAPI
]

{ #category : #accessing }
WebViewLibraryUsingMainThreadRunner >> runner [
	^ TFMainThreadRunner uniqueInstance .
]
