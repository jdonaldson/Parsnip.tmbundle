# Parsnip #

Parsnip is a Textmate bundle for creating snippets.  It relies on a subset of regular expression syntax in order to flexibly specify tab stops and default text.
## Intro ##
A simple parsnip looks like this:
`>/(\w+)/`

The bundle works by looking for a parsnip in a document or selected text. You insert the parsnip into your document:

	>/(\w)/
	x x
	y y
	z z
	
The parsnip bundle command (CTRL-COMMAND-P) will create the following snippet:

	x$1 x
	y$2 y
	z$3 z


In textmate, this will set up a sequence of tab stops ($1,$2,$3 will not show up in the output). It also removes the parsnip.

The basic premise is that tab stops will be set at regular expression group matches in the given lines.  By default, each line is a tab stop, and each matched group becomes another instance of the tab stop (this behavior can be changed).  For instance, the following selection:

	>/(\w)\s*(\w)/
	x x
	y y 
	z z

will produce


	x$1 x$1
	y$2 y$2 
	z$3 z$3


You can change the sequence of tab stops by adding another "stalk" to the parsnip:

	>>/(\w)\s*(\w)/
	x x
	y y 
	z z

will produce


	x$1 x$2
	y$1 y$2 
	z$1 z$2


You can also change the position of the tab stop by adding a "<" character to the end of the parsnip:

	>>/(\w)\s*(\w)/<
	x x
	y y 
	z z

will produce


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

==Demo==
As a final demonstration, consider the following selection:

	>/function\((\w),(\w),(\w)\)/>
	var f1 = function(x,y,z){...}
	var f2 = function(a,b,c){...}
	var f3 = function(d,e,f){...}

After processing with Parsnip, we can quickly add types to the arguments:


	var f1 = function(x:Float,y:Float,z:Float){...}
	var f2 = function(a:Int,b:Int,c:Int){...}
	var f3 = function(d:String,e:String,f:String){...

==Misc==
Note: It's possible to use extra forward slashes instead of angle brackets for the "stalks":
e.g. `///(\w)/`




