"
I'm a FFILibrary which should point to webview.dll stored locally as other uFFI libraries. Look also https://github.com/webview/webview for the installation & deploy.
"
Class {
	#name : #WebViewLibrary,
	#superclass : #FFILibrary,
	#category : #'WebView-Libs'
}

{ #category : #'accessing - platform' }
WebViewLibrary >> win32ModuleName [
	^ 'webview.dll'
]
