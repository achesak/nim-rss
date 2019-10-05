About
=====

nim-rss is a Nim module for working with RSS.

Installation
============

Add the following to your `{project}.nimble` file:

    requires "rss >= 1.1"

Usage
=====

`getRSS(url: string): RSS`
fetch and parse an RSS feed from a URL

`loadRSS(filename: string): RSS`
read and parse a local RSS file

`parseRSS(data: string): RSS`
parse RSS directly from a string

License
=======

nim-rss is released under the MIT Open Source License.
