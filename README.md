# Pharo-Webview

Pharo-WebView is a package which implements a binding to webview dll library available at https://github.com/webview/webview in Pharo. Webview allows you to show HTML user interfaces in a native window, inject JavaScript code and HTML content into the page. It can render HTML originating via web requests or as a direct input.

IMPORTANT: Pharo-WebView was until now tested on Windows 10 64-bit and Linux (Ubuntu Desktop 20.04.3 LTS) 64-bit. On Linux, Pharo-WebView must be run on headless VM, webview library is available as libs/webview.so file in this repository. Due to some open issues (like, for instance, https://github.com/webview/webview/issues/588), the need to redefine some of the library's functionalities to properly manage (create, destroy) external objects when controlling WebView interactively from Pharo, and MacOS/Cocoa specific implementation in this library I decided to continue the work with similarly lightweight and stable libraries, like for instance https://www.tryphotino.io/. Feel free to experiment and create pull requests. There's also a MacOS version of webview library (webview.dylib) available in libs directory.

## Installation
You can load WebView package using Metacello:

```
Metacello new
  repository: 'github://eftomi/Pharo-WebView';
  baseline: 'WebView';
  load.
```

## Use

Typically a WebView object should be subclassed as in

```
WebView subclass: #MyWebView 
...
```

and created as a singleton using MyWebView class>>#uniqueInstance. If you wish to expose a block of code in Pharo to be accessible from javascript code in webview as a function (like for instance onclick="callPharo(args)"), use MyWebView>>#registerCallbackBlock:nameInJS:.

Public API and Key Messages

- showContent: aString - if aString is valid URL, webview displays its content. aString could also be a html or other document; in this case use proper content types at the beginning, for html this is for instance 'data:text/html, <!doctype html><html><head>...'
- width: height: hints: - sets the dimensions and the window type; see the method body for hints constants
- setTitleTo: aString - sets window title
- evalJS: and injectJS: - see the methods' body for description
- registerCallbackBlock:nameInJS: registers a webwiew callback that can be called from javascript running in the webview, exposed as nameInJS function.

WebView is actually a FFIOpaqueObject implemented by a DLL library (https://github.com/webview/webview) on MS Windows and as a SO (shared objects) library on Linux. Besides this, it also needs webview implementation for the specific platform - Edge or Edge/Chrome on MS Windows and Gtk3 + Gtk-webkit2 on Linux. Please look at the above GitHub address for specifics about deployment & installation on end user machine. 

However, you can find webview.so (Linux/Ubuntu) and webview.dylib (MacOS) libraries in libs directory in this repository. These two libraries were compiled by gcc as:

```c++ webview.cc -fPIC -shared -o libwebview.so `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0` ``` (on Linux)

```c++ -dynamiclib webview.cc -std=c++11 -framework WebKit -o libwebview.dylib ``` (on MacOS, purely experimental)

Due to synchronization incompleteness of this wrapper and library and to avoid memory leaks, the WebView "session" is typically done like

```
wv := MyWebView uniqueInstance.	  "create unuqueInstance"
wv showContent: 'https://www.pharo.org/'.	  "show some content"
wv run.	  "important for Linux implementation, on MS Windows it has no visible effect"
wv showContent: 'https://pharo.org/community'.	  "show some other content"
...

<close webview window manually>

wv terminate.	  "terminate run process"
MyWebView clearUniqueInstance.  "to make sure that non-existing webview (as external object) cannot be called"
```
