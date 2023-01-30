Class {
	#name : #BasicTest,
	#superclass : #TestCase,
	#category : #'WebView-Tests'
}

{ #category : #tests }
BasicTest >> testCallback [
	| html wv |

	html := '	<!doctype html>
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

	wv := WebView uniqueInstance .
	wv setHtmlContent: html.
	wv registerCallbackBlock: 
		[ :args | args inspect ]
		nameInJS: 'myFunc'.
	wv run.

]

{ #category : #tests }
BasicTest >> testEvalJSWithCallback [
	| html wv |
	
	html := '	<!doctype html>
	<html>
		<head>
			<title>Test</title>
		</head>
		<body>
			<p>This is some test with js evaluaton. We issue a callback, it should be visible in  			Transcript in two seconds</p>
		</body>
	</html>'.

	wv := WebView uniqueInstance .
	wv setHtmlContent: html.
	wv registerCallbackBlock: 
		[ :args | args inspect ]
		nameInJS: 'evalJSFunc'.

	2 seconds wait.

	wv evalJS: 'evalJSFunc(''Hey, do you see me?'')'.

]

{ #category : #tests }
BasicTest >> testSetTitle [
	| wv |
	wv := WebView uniqueInstance .
	wv navigateToURL: 'https://www.pharo.org/'.
	wv setTitleTo: 'Webview in Pharo!'.
	wv run.

]

{ #category : #tests }
BasicTest >> testTwoCallbacks [
	| html wv |

	html := '	<!doctype html>
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
	
	wv := WebView uniqueInstance .
	wv setHtmlContent: html.

	wv registerCallbackBlock: 
		[ :args | args traceCr ]
		nameInJS: 'firstFunc'.

	wv registerCallbackBlock: 
		[ :args | args traceCr ]
		nameInJS: 'secondFunc'.
	
	wv setHtmlContent: html.
	wv run.
]

{ #category : #tests }
BasicTest >> testVisitUrl [
	| wv |
	wv := WebView uniqueInstance .
	wv navigateToURL: 'https://www.pharo.org/'.
	wv run.


]
