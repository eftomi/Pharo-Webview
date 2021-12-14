Class {
	#name : #BaselineOfWebView,
	#superclass : #BaselineOf,
	#category : #BaselineOfWebView
}

{ #category : #baselines }
BaselineOfWebView >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
				"Packages"
				spec
					package: 'WebView';
					package: 'WebView-Core'  with: [ spec requires: #('WebView-Libraries') ];
					package: 'WebView-Libraries' with: [ spec requires: #('WebView-Core') ];
					package: 'WebView-Manifest'  with: [ spec requires: #('WebView-Core') ];
					package: 'WebView-Tests'  with: [ spec requires: #('WebView-Core') ]
			 ]
]
