Suffered from permanent pain with Java, JSP, JEE, Python, PHP, Perl, Web Frameworks and a thousand other things, the decision was made to re-write [TinyCMS](https://codeberg.org/aggi/tinycms) web content management system from scratch to maintain tinfront.org website with.

Written in 3 days it is ~200 lines of POSIX shell script for the content management components, a few templates, a stylesheet and few minimal dependencies required which are implemented in C for template processing with [pp utility](https://adi.onl/pp.html) and markdown format conversion with [discount utility](http://www.pell.portland.or.us/~orc/Code/discount/)

Fast, simple, extensible to maintain an AoT rendered static site.
Dynamic session content processing with CGI is optional and remains disabled for security reasons.

TODO:
- RSS feeds
- Full-Text-Search

Please see [https://codeberg.org/aggi/tinycms](https://codeberg.org/aggi/tinycms) for further details and feel free to drop a note by navigating [contact](contact.html) section.
