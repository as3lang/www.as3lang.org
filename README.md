www.as3lang.org
===============

build a community web site about AS3 with AS3  
for the people  
for the community  
for the language  


sure, it starts slow with a simple "hello world"  
but if you follow the evolution of the source code  
during the next few weeks  
you will learn and see  
all the things that AS3 can do server side  
and maybe get inspired to build your own web site using AS3 :)﻿  


Why AS3lang ?
-------------

Here what we know
  - **AS1** JS like
  - **AS2** TypeScript/Dart/CoffeeScript like
  - **AS3** great or good enough
  - **AS4** will not happen

So yeah ActionScript 3.0 is what it is all about, but what else ?

Some people will tell you that AS3 is Flash and that "Flash is dead",
wether those people are haters, trolls or simply misinformed, one thing
is sure, "I think what we have here is a communication problem".

Unless you can sit with someone for few minutes and explain all the
differences between Flash as the Flash Player plugin for browsers,
Flash as the Flash Platform, FLash as the Adobe Flash CC IDE, etc.
it is just so easy to confuse anyone about it.

And it's nothing new, we already had the very same communication problem
with Flex: from Flex Builder the IDE, passing by the Flex SDK,
to the Flex framework, etc. you throw MXML in the lot and then rename
the whole thing to Apache Flex and then boom everyone is confused.

One possible alternative, or solution, is to simply talk about all that
from the programming language point of view.


How are we doing it ?
---------------------

We start from scratch, literaly nothing, and at every step we [publish a release](https://github.com/as3lang/www.as3lang.org/releases).

So far we have explored
  - how to build an ABC file that run under Apache as CGI
  - how to parse/interpret HTTP headers
  - how to read/write streams
  - how to deal with HTML templates
  - (more to come)

Sure, it is pretty simple, but I do believe showing step by step can help a lot.

But remember it is about building a community web site, and yeah it seems I'm only 1 guy here,
and so maybe you want to contribute, here few pointers :).

**1. spread the love**  
As any community the more people know about it the better and one good way to share the love for AS3 is to follow us on twitter [@as3lang](https://twitter.com/as3lang/), honestly seeing that a couple hundred people were interested in few weeks was very motivating, tell others but please don't spam them.

**2. test and experiment**  
Again it is really basic but just reporting a bug or something that does not work as it should work help tremendously, for each releases there are plenty of bugs to be found, it will help make the code better for everyone, [please do reports bugs in the bug tracker](https://github.com/as3lang/www.as3lang.org/issues) (did I mention it could get you some special badge on the community web site? oh well ...).

**3. suggestions and comments**  
There are many ways if not thousands way to build a community web site, my view is one of the first feature should be a "news system" where anyone can post news about AS3 and anyone else can vote plus or minus, a bit like hacker news or reddit, and so the good news with more vote come atop.

Ok it's not there yet, but once things get started maybe my focus will not be as good, so please do use the issues tracker to comments and suggest things, again for the good of the community.

**4. contributing code**  
Again different way to do that, maybe you have been toying with a fork of one of the release, maybe you started to write something that can help improve the whole thing, well that's the classic github way: fork, add your code, do a pull request.

I would only insist that you create an issue with the pull request and then the code is discussed there.

Another way, if you really want to go heavy on some code edit, is to request a committer status,
as you may have noticed this repository is synched from a private svn repository (not trying to hide anything but after many let down by different open source repos that have closed down now I host things myself), to do that again open an issue and discuss what kind of code you want to contribute.

**5. contributing design**  
I do what I can, in another galaxy I was a designer 20+ years ago, but yeah there are certainly big room for improvement. From designing a cool AS3 logo, to the design / layout of web pages, to the UX, etc. there are tons of things to work on.

Same, please do open an issue and let's talk about design on that issue.

Let me be a bit clearer, let's discuss about one design thing per issue.

**6. contributing content**  
Once we have few things in place like a news system, and/or a blog and/or a wiki kinda documentation system, that would be about publishing to it and this I guess anyone can do his/her part :).

Really it's about if you post something on twitter/google+/facebook or any other kind of group or forum, then also post on the news system to share the content with others sharing the same interests.

In the same idea, once there is a blog, it would be simply about writing a blog post, I guess it would work as creating a pull request and adding `title_of_my_post.md` or something like that.



All that said, I personally never built a community web site, my only rule is to do it using AS3 and I do hope some people will find soem time to help this and there :).



ActionScript 3.0
----------------

#### What is it ?

A programming language


#### What can we do with it ?

Build software in the large sense of the term.


#### Do I need to compile it ?

Yes, AS3 is in general compiled to bytecode and executed by a runtime.


#### What compilers are available ?

There are open source and commercial compilers.

The Apache Flex project provide open source compilers that you can find in the Apache Flex SDK.

Adobe provide 2 commercial compilers:
  - Adobe Flash CC (not free)
  - AIR SDK (free)


#### What runtimes are available ?

You have the Flash Player, a browser plugin which allow to execute SWF file embedded in HTML.

You have AIR (Adobe Integrated Runtime), with it you can publish executable for Windows, Mac OS X and Linux desktop, and you can also publish native mobile applications for iOS and Android.

You have also the open source project Redtamarin, those runtimes allow to produce command line executable,
server side programs and shell scripts that can run on Windows, Mac OS X and Linux.

You can also find third party commercial runtimes like Scaleform GFX, which allow to publish on console like Xbox and PlayStation, and as well on mobile for iOS and Android.


#### To Be Continued

To Be Continued



