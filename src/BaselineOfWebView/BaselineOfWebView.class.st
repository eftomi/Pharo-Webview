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
				spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
				
				"Packages"
				spec package: 'WebView' with: [ spec requires: #('NeoJSON') ].
"				spec package: 'WebView-Libs' with: [ spec requires: #('WebView') ].
				spec package: 'WebView-Core'  with: [ spec requires: #('WebView' 'WebView-Libs') ].
				spec package: 'WebView-Manifest'  with: [ spec requires: #('WebView' 'WebView-Core') ].
				spec package: 'WebView-Tests'  with: [ spec requires: #('WebView' 'WebView-Core' 'NeoJSON') ].
"				
				"Groups"
				spec group: 'default' with: #('WebView'). 
"				spec group: 'default' with: #('WebView' 'WebView-Core' 'WebView-Libs' 'WebView-Manifest' 'WebView-Tests'). "
			 ]
]
