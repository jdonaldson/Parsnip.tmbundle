# Parsnip#

Parsnip is a Textmate bundle for creating [snippets](http://manual.macromates.com/en/snippets).  It relies on [regular expression syntax](http://www.regular-expressions.info/reference.html) in order to flexibly specify tab stops and default text.  It also has the ability to intelligently space and code, or to easily pass portions of the document through a script.

	
## Intelligent Spacing ##
The main benefit of intelligent spacing comes when you want to align variables, values, and comments in code:

	var  x = 4; // a comment goes here
	var y = 20000; // another comment
	var foobar = 'sadfasdfasdf'; // one more comment

After parsing this section with Parsnip's pattern match column spacing (CONTROL+COMMAND+SPACE), we have:

	var x      = 4;              // a comment goes here 
	var y      = 20000;          // another comment     
	var foobar = 'sadfasdfasdf'; // one more comment

Note: comments are excluded from the column spacing, and this technique only works for languages that have double forward slash comments, and will not work with any inline comments.


## Using parsnips ##

While Parsnip (uppercase) is the bundle, a *parsnip* is actually a special sequence of characters, which is essentially a modified regex. A simple parsnip looks like this:
`>/(\w+)/`
*I thought it looked a bit like a [parsnip](http://en.wikipedia.org/wiki/Parsnip)... you may have to use your imagination a little.*

The bundle works by looking for a parsnip in a document or selected text. You type the parsnip directly into your document:

	>/(\w)/
	x x
	y y
	z z
	
The parsnip bundle command (CTRL-COMMAND-P) will create the following snippet:

	x$1 x
	y$2 y
	z$3 z


In TextMate, this will set up a sequence of tab stops ($1,$2,$3 indicates stop location, and will not show up in the output). It also removes the parsnip.

The basic premise is that tab stops will be set at regular expression group matches in the given lines.  By default, each line is a tab stop, and each matched group becomes another instance of the tab stop (this behavior can be changed, see below).  For instance, the following selection:

	>/(\w)\s*(\w)/
	x x
	y y 
	z z

will produce


	x$1 x$1
	y$2 y$2 
	z$3 z$3

## Changing the tab stop sequence ##
You can change the sequence of tab stops by adding another "stem" to the parsnip:

	>>/(\w)\s*(\w)/
	x x
	y y 
	z z

will produce


	x$1 x$2
	y$1 y$2 
	z$1 z$2


## Changing the insertion behavior at tab stops ##
You can also change the insert location of the tab stop by adding a "<" character to the end of the parsnip:

	>>/(\w)\s*(\w)/<
	x x
	y y 
	z z

This puts the tab stop *before* the matching group:


	$1x $2x
	$1y $2y 
	$1z $2z

You can set the tab stop to replace the current match with a "=" character at the end:

	>>/(\w)\s*(\w)/=
	x x
	y y 
	z z

will produce


	${1:x} ${2:x}
	${1:y} ${2:y} 
	${1:z} ${2:z}

## Demo ##
As a final demonstration, consider the following selection:

	>/function\((\w),(\w),(\w)\)/>
	var f1 = function(x,y,z){...}
	var f2 = function(a,b,c){...}
	var f3 = function(d,e,f){...}

After processing with Parsnip, we can quickly add types to the arguments:


	var f1 = function(x:Float,y:Float,z:Float){...}
	var f2 = function(a:Int,b:Int,c:Int){...}
	var f3 = function(d:String,e:String,f:String){...


## Misc. ##
Note: It's possible to use extra forward slashes instead of angle brackets for the "stalks" (e.g. `//(\w)/` instead of `>/(\w)/`).  This makes them just a bit easier to type out.


## Parscript ##
Parscript is very similar to the default TextMate command Text->Filter-Through-Command menu item.  I find writing special formatting commands, etc. in the document itself feels more natural than using a separate popup window.


As an example, consider a long string of text, such as a copyright notice: 


	Copyright (c) 2011, Some Guy. Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met.  

First, we add a small snippet at the top of the line.  The command "fmt 72" is applied to the string, which attempts to insert hard line breaks at 72 character intervals:

	>/fmt 72/
	Copyright (c) 2011, Some guy. Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met.  

(Any command can be used.  However, the selected text is always replaced with the stdout from the command result.  If the command produces no output, then the selected text/document buffer will be erased.  Take care to use the appropriate script commands, and be ready to undo any mistakes).

So, when we invoke the parscript command (CONTROL+COMMAND+S):
	
	Copyright (c) 2011, Some guy. Redistribution and use in source and binary forms,
 	with or without modification, are permitted provided that the following conditions
 	are met.

We can see the output.  Maybe we want to do something further to dress the comment up as the file header:

	>/(\w)/<
	Copyright (c) 2011, Some guy. Redistribution and use in source and binary forms,
	with or without modification, are permitted provided that the following conditions
	are met.
	 
Now we use the parsnip command (CONTROL+COMMAND+P) and we can type in some leading characters (just typing in " * " once)
	
	 * Copyright (c) 2011, Some guy. Redistribution and use in source and binary forms,
	 * with or without modification, are permitted provided that the following conditions
	 * are met.

And finally adding in some inline comment terminators:

	/*
	 * Copyright (c) 2011, Some guy. Redistribution and use in source and binary forms,
	 * with or without modification, are permitted provided that the following conditions
	 * are met.
	 */

