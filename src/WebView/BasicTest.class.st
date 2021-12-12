Class {
	#name : #BasicTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'webview'
	],
	#category : #'WebView-Tests'
}

{ #category : #tests }
BasicTest >> testCallback [
	| cb1 cb2 html wv |
	cb1 := MyCallback1 uniqueInstance 
		initializeWithBlock: [ :req | 
			Transcript crShow: req.
			'Here is the message' ] 
		nameInJS: 'firstFunc'.
	cb2 := MyCallback2 uniqueInstance 
		initializeWithBlock: [ :req | 
			Transcript crShow: req ] 
		nameInJS: 'secondFunc'.
	
	html := 'data:text/html, 
	<!doctype html>
	<html>
		<head>
			<title>Krnek</title>
		</head>
		<body>
			<p>krnek</p>
			<button id="btn" onclick="
				firstFunc({''seq'': 1}, {''load'': ''Hello from firstFunc!''});
				secondFunc({''seq'': 1}, {''load'': ''Hello from secondFunc!''});
				">Doit</button>
		</body>
	</html>'.

	wv := WebView new open 
		registerCallback: cb1; 
		registerCallback: cb2.
	
	wv showContent: html.
]

{ #category : #tests }
BasicTest >> testCallback2 [
	| cb3 html wv |
	cb3 := MyCallback3 uniqueInstance 
		initializeWithBlock: [ :req | 
			Transcript crShow: req.
			'{}' ] 
		nameInJS: 'myFunc'.
	
	html := 'data:text/html, 
	<!doctype html>
	<html>
		<head>
			<title>Krnek</title>
		</head>
		<body>
			<p>krnek</p>
			<button id="btn" onclick="
				myFunc(3.14).then(function(rc) {console.log(rc)});
				">Doit</button>
		</body>
	</html>'.

	wv := WebView new open 
		registerCallback: cb3.
	
	wv showContent: html.
]
