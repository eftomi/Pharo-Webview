Class {
	#name : #WebViewCallback,
	#superclass : #Object,
	#instVars : [
		'nameInJS'
	],
	#classInstVars : [
		'uniqueInstance',
		'ffiCallback'
	],
	#category : #'WebView-Core'
}

{ #category : #accessing }
WebViewCallback class >> ffiCallback [

	^ ffiCallback
]

{ #category : #accessing }
WebViewCallback class >> ffiCallback: aFFICallback [

	ffiCallback := aFFICallback
]

{ #category : #accessing }
WebViewCallback class >> new [
	self error: 'Use #uniqueInstance'
]

{ #category : #accessing }
WebViewCallback class >> uniqueInstance [
	uniqueInstance ifNil: [ uniqueInstance := super new ].
	^ uniqueInstance
]

{ #category : #accessing }
WebViewCallback >> arguments [
	^ ExternalAddress new.
]

{ #category : #accessing }
WebViewCallback >> ffiCallback [
	^self class ffiCallback
]

{ #category : #initialization }
WebViewCallback >> initializeWithBlock: aBlock nameInJS: aString [
	nameInJS := aString.
	self class ffiCallback: (
		FFICallback
			signature: #(void (const char * seq, const char * req, void * arg))
			block: [ :seq :req :arg | 
				aBlock value: req fromCString
			]
	).

]

{ #category : #accessing }
WebViewCallback >> nameInJS [

	^ nameInJS
]
