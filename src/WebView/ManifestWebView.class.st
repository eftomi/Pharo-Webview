"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestWebView,
	#superclass : #PackageManifest,
	#category : #'WebView-Manifest'
}

{ #category : #'code-critics' }
ManifestWebView class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#WebViewCallback #initialize #false)) #'2021-12-12T12:14:53.773822+01:00') #(#(#RGMethodDefinition #(#WebViewCallback #initializeWithBlock: #false)) #'2021-12-12T12:24:39.843269+01:00') #(#(#RGMethodDefinition #(#BasicTest #testCallback #false)) #'2021-12-12T18:08:37.843028+01:00') #(#(#RGMethodDefinition #(#BasicTest #testCallback2 #false)) #'2021-12-12T18:29:02.867321+01:00') )
]

{ #category : #'code-critics' }
ManifestWebView class >> ruleLiteralArrayContainsCommaRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#WebViewCallback #initialize #false)) #'2021-12-12T12:14:49.224485+01:00') #(#(#RGMethodDefinition #(#WebViewCallback #initializeWithBlock: #false)) #'2021-12-12T12:24:35.906454+01:00') #(#(#RGMethodDefinition #(#WebViewCallback #initializeWithBlock:nameInJS: #false)) #'2021-12-12T16:15:40.518301+01:00') )
]

{ #category : #'code-critics' }
ManifestWebView class >> ruleReVariableAssignedLiteralRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#WebView)) #'2021-12-12T18:53:30.481196+01:00') )
]

{ #category : #'code-critics' }
ManifestWebView class >> ruleSendsDifferentSuperRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#WebViewCallback #initializeWithBlock: #false)) #'2021-12-12T12:24:32.091553+01:00') )
]
