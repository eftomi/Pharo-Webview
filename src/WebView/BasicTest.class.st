Class {
	#name : #BasicTest,
	#superclass : #TestCase,
	#category : #'WebView-Tests'
}

{ #category : #tests }
BasicTest >> testCallback [
	| cb3 html wv |
	cb3 := MyCallback3 uniqueInstance 
		initializeWithBlock: [ :args | 
			args inspect ] 
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

{ #category : #tests }
BasicTest >> testEvalJSWithCallback [
	| cb1 html wv |
	cb1 := MyCallback1 uniqueInstance 
		initializeWithBlock: [ :args | 
			Transcript crShow: args ] 
		nameInJS: 'firstFunc'.
	
	html := 'data:text/html, 
	<!doctype html>
	<html>
		<head>
			<title>Test</title>
		</head>
		<body>
			<p>This is some test with js evaluaton. We issue a callback, it should be visible in  			Transcript in two seconds</p>
		</body>
	</html>'.

	wv := WebView new open 
		registerCallback: cb1.
	
	wv showContent: html.
	2 seconds wait.
	wv evalJS: 'firstFunc(''Hey, do you see me?'')'.

]

{ #category : #tests }
BasicTest >> testTwoCallbacks [
	| cb1 cb2 html wv |
	cb1 := MyCallback1 uniqueInstance 
		initializeWithBlock: [ :args | 
			Transcript crShow: args ] 
		nameInJS: 'firstFunc'.
	cb2 := MyCallback2 uniqueInstance 
		initializeWithBlock: [ :args | 
			Transcript crShow: args ] 
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
				firstFunc(''Hello from firstFunc!'');
				secondFunc({''load'': ''Hello from secondFunc!''});
				">Doit</button>
		</body>
	</html>'.

	wv := WebView new open 
		registerCallback: cb1; 
		registerCallback: cb2.
	
	wv showContent: html.
]
