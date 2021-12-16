Class {
	#name : #WinUser32,
	#superclass : #FFILibrary,
	#category : #'WebView-Libs'
}

{ #category : #'accessing - platform' }
WinUser32 >> win32ModuleName [
	^ 'User32.dll'
]
