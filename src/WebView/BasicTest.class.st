Class {
	#name : #BasicTest,
	#superclass : #TestCase,
	#category : #'WebView-Tests'
}

{ #category : #tests }
BasicTest >> testCallback [
	| cb1 cb2 html wv |
	cb1 := MyCallback1 uniqueInstance 
		initializeWithBlock: [ :req | 
			Transcript crShow: req ] 
		nameInJS: 'firstFunc'.
	cb2 := MyCallback2 uniqueInstance 
		initializeWithBlock: [ :req | 
			Transcript crShow: req ] 
		nameInJS: 'secondFunc'.
	
	html := 'data:text/html, 
	<!doctype html>
	<html>
		<head>
			<title>Test</title>
		</head>
		<body>
			<p>This is some test</p>
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
			((NeoJSONReader fromString: '[3.14]') at: 1) inspect ] 
		nameInJS: 'myFunc'.
	
	html := 'data:text/html, 
	<!doctype html>
	<html>
		<head>
			<title>Test</title>
		</head>
		<body>
			<p>This should run the inspector on 3.14</p>
			<button id="btn" onclick="
				myFunc(3.14);
				">Doit</button>
		</body>
	</html>'.

	wv := WebView new open 
		registerCallback: cb3.
	
	wv showContent: html.
]
