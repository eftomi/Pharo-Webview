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
				"Dependencies"
				
				self neoJSON: spec.
				
				"Packages"
				spec
					package: 'WebView';
					package: 'WebView-Core'  with: [ spec requires: #('WebView' 'WebView-Libraries') ];
					package: 'WebView-Libraries' with: [ spec requires: #('WebView') ];
					package: 'WebView-Manifest'  with: [ spec requires: #('WebView' 'WebView-Core') ];
					package: 'WebView-Tests'  with: [ spec requires: #('WebView' 'WebView-Core' 'NeoJSON') ].
				
				"Groups"
				spec
					group: 'default' with: #('WebView-Core' 'WebView-Libraries' 'WebView-Manifest' 'WebView-Tests'). 
			 ]
]

{ #category : #baselines }
BaselineOfWebView >> neoJSON: spec [
	spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
]
