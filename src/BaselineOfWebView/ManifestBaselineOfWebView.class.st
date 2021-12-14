"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestBaselineOfWebView,
	#superclass : #PackageManifest,
	#category : #'BaselineOfWebView-Manifest'
}

{ #category : #'code-critics' }
ManifestBaselineOfWebView class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#BaselineOfWebView #baseline: #false)) #'2021-12-14T20:22:42.747124+01:00') )
]
