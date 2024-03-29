Class {
	#name : #BasicTest,
	#superclass : #TestCase,
	#category : #'WebView-Tests'
}

{ #category : #tests }
BasicTest >> testCallback [
	| html wv |

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

	wv := MyWebView uniqueInstance .
	wv showContent: html.
	wv registerCallbackBlock: 
		[ :args | args inspect ]
		nameInJS: 'myFunc'.
	wv run.

]

{ #category : #tests }
BasicTest >> testEvalJSWithCallback [
	| html wv |
	
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

	wv := WebView new.
	wv showContent: html.
	wv registerCallbackBlock: 
		[ :args | args inspect ]
		nameInJS: 'evalJSFunc'.
	wv ffiRun.

	2 seconds wait.

	wv evalJS: 'evalJSFunc(''Hey, do you see me?'')'.

]

{ #category : #tests }
BasicTest >> testShowContent [
	| wv |
	wv := MyWebView uniqueInstance .
	wv showContent: 'https://www.pharo.org/'.
	wv run.

]

{ #category : #tests }
BasicTest >> testTwoCallbacks [
	| html wv |

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
	
	wv := MyWebView uniqueInstance .
	wv showContent: html.

	wv registerCallbackBlock: 
		[ :args | args traceCr ]
		nameInJS: 'firstFunc'.

	wv registerCallbackBlock: 
		[ :args | args traceCr ]
		nameInJS: 'secondFunc'.
	
	wv showContent: html.
	wv run.

]
