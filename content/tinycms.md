Suffered from permanent pain with Java, JSP, JEE, Python, PHP, Perl, Web Frameworks and a thousand other things, the decision was made to re-write [TinyCMS](https://codeberg.org/aggi/tinycms) web content management system from scratch to maintain tinyfront.org website with.

Written in 3 days it is ~200 lines of POSIX shell script for the content management components, a few templates, a stylesheet and few minimal dependencies required which are implemented in C for template processing with [pp utility from mkws.sh project](https://adi.onl/pp.html). Markdown format conversion is possible with [discount utility](http://www.pell.portland.or.us/~orc/Code/discount/) that is too written in C and nothing else. By this TinyCMS extends the concept of static site generation with [mkws.sh](https://mkws.sh) towards web content management by associating navigation entities with content entities and supporting a few content entity format conversions.

Fast, simple, extensible to maintain AoT rendered static sites with a git-driven distributed workflow. Dynamic session content processing with CGI on the TinyCMS server host is optional and can remain completely disabled for security reasons. Instead TinyCMS integrates nicely with codeberg or github:

- to navigate and edit any content directly inside revision control system for example [tinycms.md](https://codeberg.org/aggi/tinycms/src/branch/master/content/tinycms.md)
- and too [RSS-feeds are exposed](https://codeberg.org/aggi/tinycms/rss/branch/master/content/tinycms.md) for content items to track updates

Please see [https://codeberg.org/aggi/tinycms](https://codeberg.org/aggi/tinycms) for further details and feel free to drop a note by navigating [contact](contact.html) section.
