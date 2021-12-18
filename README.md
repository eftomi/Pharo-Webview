# Pharo-Webview

Pharo-WebView is a package which implements a binding to webview dll library available at https://github.com/webview/webview in Pharo. Webview allows you to show HTML user interfaces in a native window, inject JavaScript code and HTML content into the page. It can render HTML originating via web requests or as a direct input.

IMPORTANT: Pharo-WebView was until now tested only on Windows 64-bit. Other platforms (Mac, Linux) should follow.

## Installation
You can load WebView package using Metacello:

```
Metacello new
  repository: 'github://eftomi/Pharo-WebView';
  baseline: 'WebView';
  load.
```

## Use

Public API and Key Messages:
- `open` - `WebView new open` opens a new window; create new WebView for each of the windows/browsers that you need to be displayed  
- `close` - closes the native window 
- `setTitleTo: aString` - sets window title
- `showContent: aString` - if aString is valid URL webview renders its content. aString could also be a html or other document; in this case use proper content types at the beginning, for html this is for instance `'data:text/html, <!doctype html><html><head>...'`
- `width: height: hints:` - sets the dimensions and native window type; see the method body for hints constants
- `evalJS:` and `injectJS:` - see the methods' body for description
- `registerCallback:` registers a WebViewCallback subclass

Besides the DLL mentioned above, this package also needs webview implementation for the specific platform. Please look at the above GitHub address for specifics about deployment & installation on end user machine. For MS Windows, place 32 or 64 bit versions of webview.dll and WebView2Loader.dll from https://github.com/webview/webview/tree/master/dll/ into the Pharo VM folder.

If you wish to expose a block of code in Pharo to be accessible from JavaScript code in webview as a function (like for instance `onclick="callPharo(args)"`), subclass WebViewCallback, make a uniqueInstance and set the block and its name in JavaScript (see comment in WebViewCallback class).
