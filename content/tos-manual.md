# Summary
Beginning with the definition of **acceptance criteria** and priority for toolchain portability set this developer manual documents the process of establishing and maintaining a **complete** mostly-GNU/POSIX operating system profile fully supported with TinyCC toolchain for the tinyfront operating system (TOS). To accomplish this task kernel, libc, development-utilities and software component portage-tree were fully forked. For sufficient test coverage and portability several system-deployment variants are kept in maintenance with a final operating system distribution
[i586-tinycc-linux2-musl.iso](download.html) being the major test-vector. [Compilation of a complete operating system release significantly extends test-coverage](https://lists.gnu.org/archive/html/tinycc-devel/2025-05/msg00002.html) for TinyCC toolchain itself.

# Acceptance Criteria
Given common definitions to agree upon:

- **Full standards compliance** implies **all** components are covered by standardization
- without an **extension beyond standardization** which may not necessarily *violate* any standard
- if any extension remained an **optional dependency** either build-time or run-time, direct or transitive
- and finally a **standard violation** exists if any extension got introduced as **mandatory dependency**.

In other words if any system cannot be compiled or booted without the presence of non-standard extensions then standards were **violated**, otherwise this might qualify merely as a less intrusive extension beyond standards or fully standards compliant still.

Relying on [OpenSource Software](https://en.wikipedia.org/wiki/Open-source_software) with permissive licensing is a necessitity but **insufficient for full compliance**, and **vendor-neutral** standards must be strictly distinguished from vendor specifications, for example:

- C language following ANSI/ISO C99 standard had proven decent, somewhat stable for >25years.
- In comparison rust-lang follows a vendor specification but not any standard.[^rust-nostandard]
- Although C++ language is standardized it introduces mandatory transitive dependencies towards components not covered by standardization always.

[^rust-nostandard]: [Without any vendor-neutral standard followed development cannot agree upon a common baseline of which releases or versions of rustc could compile itself self-hosting](https://blog.rust-lang.org/inside-rust/2025/05/29/redesigning-the-initial-bootstrap-sequence)

With tinyfront system *full standards compliance is not feasible* and extensions beyond standardization are unavoidable, but the system ***must not violate standards*** with given definition by introducing a mandatory extension beyond [POSIX](https://en.wikipedia.org/wiki/POSIX) or [ANSI/ISO C](https://en.wikipedia.org/wiki/ANSI_C) unnecessarily. Tinyfront system fights the battle against the malicious vendor strategy to ["Embrace, Extend, Extinguish"](https://en.wikipedia.org/wiki/Embrace,_extend,_and_extinguish) which almost always non-standardized mandatory extensions were utilized for in the tech industry dominated by hostile actors imposing their [anti-competitive](https://en.wikipedia.org/wiki/Anti-competitive) habits with vendor-specifications onto developers and millions of users. Furthermore standardization itself is prone to infringement of **compatibility** and **interoperability** when following latest iterations with all features implemented (C++, C11), hence a conservative approach is reasonable to exclude various standard features since this does not necessarily violate standards. Often *incomplete* implementations of standards is less severe than violating a standard with mandatory extensions.

By extending [portability](#Portability-and-Test-Coverage) back towards [linux-2.4 syscall ABI](#Kernel) with [TinyCC toolchain](https://bellard.org/tcc) in [software engineering](https://en.wikipedia.org/wiki/Software_engineering#Criticism) terms:

- [Compatibility](https://en.wikipedia.org/wiki/Computer_compatibility) is prioritized over
- [Interoperability](https://en.wikipedia.org/wiki/Interoperability) which implied unstable non-standard components for latest feature creep

Due to various interdependent issues involved with tinyfront system acceptance criteria in detail:

- First all C++ dependencies were sanitized from the dependency graph to keep them **optional**
- Then a **complete** system profile including development utilities was verified to compile and boot with TinyCC toolchain instead of GNU toolchain
- [cross-compilation](#Cross-Compilation) of the complete system profile was verified for all test-vectors
- [static linking](#Linking) support for all [userspace software components forked](#Userspace-Fork) was confirmed
- [slibtool](https://dev.midipix.org/cross/slibtool) had to be fully integrated into the build system
- of cause [GCC](https://gcc.gnu.org) C and C++ compilers can be retained to extend test-coverage
- but GNU toolchain (and llvm/clang) will be fully optional with tinyfront system

Because since when GNU compiler switched to C++ implementation language internally itself and related [discussions summarized at https://lwn.net/Articles/542457](https://lwn.net/Articles/542457) focus on "benefits" of C++ implementation, without recognizing the long-term impact this had onto bootstrapping of GNU toolchain itself and the hindrance C++ was for **vendor-neutral toolchain portability**. Since then bootstrapping GCC remains blocked at gcc-4.7.4 since any later version requires a C++ compiler. Furthermore gcc-4.7.4 must be kept in maintenance and testing indefinitely since it is this version which permits the transition from C to C++. [GNU](https://gnu.org) and [FSF](https://fsf.org) projects obsoleted this compiler version long time ago without any further support provided, in parallel to various important architectures (aarch64!, riscv64) available with later compiler versions only which enforces a toolchain upgrade in violation of acceptance criteria. Any system which requires a recent GNU compiler or llvm/clang compiler version then locked into a transitive dependency towards C++ always, even if software itself was not written in C++ but C only! [^GNU-features]

[^GNU-features]: "In GNU utils, incompatible features and extensions are a feature, not a bug." [harmful.cat-v.org](http://harmful.cat-v.org/software/GNU)

![GCC Lines-of-Code](files/gcc-lines-of-code.webp)
<div class=item-footer>GCC Soars Past 14.5 Million Lines Of Code - <a href='https://www.phoronix.com/news/MTg3OTQ'>phoronix.com</a></div>

# Bootstrapping
A precise definition for "full source bootstrapping" is required and important terminology must not be confused for:

1. A **"source-based" workflow** with *full coverage beginning with a tiniest boot-seed* written in documented hex-code minimalist [asm](https://en.wikipedia.org/wiki/Assembly_language).
2. Then **["reproducibility" of binary artifacts](https://en.wikipedia.org/wiki/Reproducible_builds)** compiled from source-code into machine-code with any toolchain, btw. which can be achieved without source-based bootstrapping too, which is no major concern, but certainly a relevant criteria.
3. Furthermore **["circular dependency"](https://en.wikipedia.org/wiki/Circular_dependency)** graph by relying upon (binary) development utilities _before_ those could have been bootstrapped reliably themselves. This instead again is high priority to avoid any, initially at least by shrinking the size of dependency graphs of involved components, which is a gradual process to dissect and take down. TinyCC support is shrinking the size of an otherwise non-optional dependency graph of gcc/binutils alike. Binary artifact "reproducibility" is a less critical concern when circular dependencies vanished, and trust into emitted binary artifacts can be fully derived from "full source bootstrapping".

Strict acceptence criteria for [system integration](https://en.wikipedia.org/wiki/System_integration) rely upon both hardware **and** software components documented and fully re-producible from schematics and source-code. Initially tinyfront system refers to software-context specifically down to most basic software components closest to hardware. [Criteria for choice of hardware](#Considerations-for-Choice-of-Hardware) must be discussed separately. With [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping) in particular the development tools and the [software toolchain](https://en.wikipedia.org/wiki/Toolchain) which is mainly an assembler, compiler and linker required must comply with acceptance criteria themselves too. The project [bootstrappable.org](https://bootstrappable.org) is dedicated to this and describes in detail how a [GNU toolchain system](https://gnu.org) can be re-established beginning with some tiniest bootloader and assembler and the whole procedure for this documented with [live-bootstrap](https://github.com/fosslinux/live-bootstrap) sources. With such procedure a complicated dependency graph of the software supply chain is defined explicitely then for build-time and run-time dependencies, instead of trusting unverifiable binary artifact development utilities of unknown origin how these could ever have been produced in the beginning.[^Thompson-Hack]

[^Thompson-Hack]: [Ken Thompson Hack injects a virus into compiler whose source code thereafter contains no evidence](https://wiki.c2.com/?TheKenThompsonHack)

All test-vectors should have a complete bootstrapping path which so far was confirmed with ARCH=x86 only, and of cause the final system must be [self-hosting](https://en.wikipedia.org/wiki/Self-hosting_%28compilers%29)[^Self-Hosting] including all required [development utilities](#Development-Utilities). With tinyfront acceptance criteria both bootstrapping and self-hosting must be confirmed. Therefore tinyfront system will converge and fully re-integrate with a complete bootstrapping chain, with a slightly different approach:

- While bootstrappable.org confirmed the feasibility of bootstrapping gcc and binutils themselves with TinyCC
- TinyCC itself instead is used to compile the **complete** tinyfront system profile *before* gcc/binutils were available to do so
- To benefit from the specific design principle as [single-pass compiler](https://en.wikipedia.org/wiki/One-pass_compiler) with [exemplary compile-time performance](https://bellard.org/tcc)[^cpp-singlepass]
- Which furthermore extends portability requirements for the base sytem profile with both TinyCC and **optional** GCC/binutils later
- Although TinyCC chosen as main system compiler limits the available [kernel](#Kernel) and [libc](#Libc) options
- Flexibility with toolchain options available is increased because TinyCC verification too establishes a **[baseline](https://en.wikipedia.org/wiki/Baseline_%28configuration_management%29)** for any other hypothetical [system-ingegration](https://en.wikipedia.org/wiki/Integration_testing) [test-vector](https://en.wikipedia.org/wiki/Test_vector)

[^Self-Hosting]: A system-integration path being self-hosting without bootstrapping procedure disclosed then hides the early-stages when a virus may be injected into the toolchain with the Thompson-Hack and no traces of evidence remain within the source code available.

[^cpp-singlepass]: It is unknown if a compiler can be implemented as single-pass design for and with C++, and this could explain the [abysmal compile-time performance and memory usage](https://www.google.com/search?q=g%2B%2B+memory+usage) of C++ compilers.

Menioned approaches of tinyfront system and bootstrappable.org do not conflict with each other, but strictness of acceptance criteria varies slightly with either. Relying upon a clean bootstrapping chain implies some important [software portability](https://en.wikipedia.org/wiki/Software_portability#Source_code_portability) issues were coped with appropriately in any case. And with either approach gcc/binutils can be bootstrapped, with bootstrappable.org this being mandatory, and with a complete tinyfront system profile GNU toolchain remaining optional.

# Portability and Test Coverage
To ensure system integration test-coverage of any test-vector a **complete** system must compile and boot with a "full source bootstrapping" workflow.
Meanwhile then portability and bootstrapping **with** and **of** any component such as:

- Assembler
- Compiler
- Libc
- Kernel
- etc.

must not be confused. For example GNU Compiler (GCC) is recognized for it's support of many architectures, but GCC itself is not easily bootstrapped. Because GCC ensures portability and cross-compilation towards many [architectures](#Architectures), for bootstrapping GCC itself TinyCC was required which currently limits the portability of GCC with this procedure to ARCH=x86. Furthermore only a [linux-2.4](#Kernel) can be supported with both GCC **and** TinyCC toolchain by tinyfront system, and this linux-2.4 kernel version itself again was not portable to various architectures with TinyCC other than ARCH=x86 again.

The multi-dimensional test-case matrix expands to rather many test-cases which cannot be all verified individually. Hence careful choices to prioritize test-cases to limit their total amount was necessary to cover as many other indirectly related ones. And the choice of TinyCC toolchain as major test-vector merely is the result of intersecting all options against acceptance criteria. Supporting a complete tinyfront operating system release with [i586-tinycc-linux2-musl.iso](download.html) then imposes practical limitations, but test coverage against acceptance criteria and bootstrapping intersects far more test-cases with TinyCC than using GNU toolchain only ever did in recent decades with a dozen different architectures and hundreds of "different" distributions following a fast-paced release-cycle to integrate latest kernels and compiler versions.

Limitations of portability and conflicts with [acceptance criteria](#Acceptance-Criteria) are mentioned for individual combinations in the following chapters.

# Architectures
&nbsp;		|**x86/32**	|x86/64		|aarch32	|aarch64	|riscv64	|other(4)	|
----------------|---------------|---------------|---------------|---------------|---------------|----------------
GCC4		|OK		|OK		|OK		|--		|--		|IRRELEVANT	|
GCC6		|OK		|OK		|OK		|OK		|UNKNOWN	|IRRELEVANT	|
**TinyCC(1)**	|**OK**		|INCOMPLETE	|INCOMPLETE	|INCOMPLETE	|OPEN(3)	|IRRELEVANT	|
cproc/qbe(2)	|--		|PARTIAL(2)	|--		|--		|--		|IRRELEVANT	|
PCC(5)		|--		|--		|--		|--		|--		|--		|
SCC(6)		|--		|--		|--		|--		|--		|--		|

1. A complete mostly-POSIX base system profile fully supported with TinyCC establishes a **baseline** for other variants (cproc, PCC, SCC), since i386-tcc partially covers relevant issues for any other such approach such as sanitizing the profile from c++. Obviously TinyCC alone cannot retain full test-coverage hence portability towards and with GCC is retained too.[^tinycc-regressions]
2. [Oasis-Linux](https://github.com/oasislinux/oasis) supports a userspace with [cproc compiler](https://sr.ht/~mcf/cproc) but kernel/bootloader require additional gcc/binutils to retain a complete system still.
3. Notable development efforts for RISCV64 is relevant for a long term perspective since Intel&reg; obsoleted their own X86 real-mode support required for both booting tinyfront system with and most important ARCH=x86 was the basis for any bootstrapping to begin with. Furthermore currently no other than ARCH=x86 got a somewhat clean and verified bootstrapping dependency chain implemented with [live-bootstrap](https://github.com/fosslinux/live-bootstrap) and a cross-compilation from any HOST=x86 towards another TARGET possible if that was not fully covered by [bootstrappable.org](https://bootstrappable.org) yet.
4. Other architectures are irrelevant with tinyfront system portability and compatibility.
5. No complete system integration is known to exist with [Portable C Compiler](https://en.wikipedia.org/wiki/Portable_C_Compiler) toolchain.
6. No complete system integration is known to exist with [Simple C Compiler](http://www.simple-cc.org) toolchain.

[^tinycc-regressions]: [Regression testing with a complete i586-tinycc-linux2-musl.iso distribution](https://lists.gnu.org/archive/html/tinycc-devel/2024-11/msg00016.html)

As a consequence it is ARCH=x86 *only* which intersects to cover all test-cases for different toolchains including TinyCC.

# Kernel
&nbsp;		|**linux-2.4**	|linux-5		|fiwix		|minix/hurd(5)	|OpenBSD	|other(7)	|
----------------|---------------|-----------------------|---------------|---------------|--------------------------------
**TinyCC**	|**OK(1)**	|**FAILED(2)**		|OK(4)		|--		|***?***	|IRRELEVANT	|
GCC4		|OK		|PATCHED/all-arch(3)	|IRRELEVANT	|--		|--		|IRRELEVANT	|
GCC6		|OK		|OK/all-arch		|IRRELEVANT	|--		|--		|IRRELEVANT	|
(PCC)		|--		|--			|--		|--		|OBSOLETE(6)	|IRRELEVANT	|

1. Linux-2.4 kernel advantages are its relatively lower amount of total lines-of-code, sufficient hardware support for USB, SATA, Ethernet, ARCH=x86 tested for stability for decades and long term refurbished hardware supply and processing power available.
2. A last known approach to compile/link any later kernel version with TinyCC was documented for [linux-4.6 by SUSE toolchain maintainer susematz](https://github.com/torvalds/linux/compare/master...susematz:linux:tcc46) which did not fully pass (gcc -S missing, linker-script support missing).
3. Mainline linux-5 kernel series introduced manadatory C11 features and version-bumped compiler requirements, which severly infringed compatibility even with GCC4 (non-c++) further. To retain the test-vector intersecting GCC4 with linux5 versions including ARCH=x86_64 a patch was necessary available in the download section [linux-5.9.16-gcc47.patch](downloads/linux-5.9.16-gcc47.patch)
4. [Fiwix](https://fiwix.org) kernel which is written in 50000 lines of code only would be more elegant however this one hasn't got hardware support for USB/ethernet etc.; Fiwix kernel is required with and test-covered by bootstrappable.org project with TinyCC.
5. Untested and known for limited hardware support, focused on X86 mainly
6. Outside tinyfront project awareness of [toolchain issues among OpenBSD project](https://www.cambus.net/the-state-of-toolchains-in-openbsd) exists yet the transition towards [llvm/clang](https://llvm.org) and with it C++ was unavoidable. The status of ["Bringing PCC into The 21th century"](https://www.openbsd.org/papers/magnusson_pcc.pdf) remained [inconclusive ever since year 2007](https://lwn.net/Articles/255558/). Supporting a complete [OpenBSD](https://openbsd.org) kernel and base system compiled with TinyCC seems a feasible future prospect to expand coverage towards, which tinyfront system itself can be used for as initial buildhost once complete bootstrapping was covered with it, and a currently absent bootstrapping chain for OpenBSD could be re-established.
7. Other kernels are irrelevant with tinyfront system portability and compatibility.

***A corner stone in the history of Linux was marked in August 2020 irreversible for future generations*** when [Linux-5.8 and later versions locked into mandatory transitive C++ dependency](https://origin.kernel.org/doc/html/v5.8/process/changes.html?highlight=gcc) inside toolchain with **minimum** compiler-version bumped beyond gcc-4.7.4 towards gcc-4.9 unnecessarily, which supports mostly useless C11 feature creep for [generic preprocessor macros](https://en.cppreference.com/w/c/language/generic.html) inside [kernel](downloads/linux-5.9.16-gcc47.patch) then.

![Linux Lines-of-Code](files/Linux_Kernel_Sizes_Graph.png)
<div class=item-footer>Linux Lines-of-Code - <a href='https://en.wikipedia.org/wiki/Linux_kernel#/media/File:Linux_Kernel_Sizes_Graph.png'>wikipedia</a></div>

In contrast to the fact outspoken by Maestro Torvalds himself long before which shall be cited completely for the sake of it because it is unknown how this problem could have escaped attention of the entire industry without ringing alarm bells:

	--------------------------------------------------------------------------------
	From: Linus Torvalds <torvalds <at> linux-foundation.org>
	Subject: Re: [RFC] Convert builin-mailinfo.c to use The Better String Library.
	Newsgroups: gmane.comp.version-control.git
	Date: 2007-09-06 17:50:28 GMT (2 years, 14 weeks, 16 hours and 36 minutes ago)
	
	On Wed, 5 Sep 2007, Dmitry Kakurin wrote:
	>
	> When I first looked at Git source code two things struck me as odd:
	> 1. Pure C as opposed to C++. No idea why. Please don't talk about portability,
	> it's BS.
	
	*YOU* are full of bullshit.
	
	C++ is a horrible language. It's made more horrible by the fact that a lot
	of substandard programmers use it, to the point where it's much much
	easier to generate total and utter crap with it. Quite frankly, even if
	the choice of C were to do *nothing* but keep the C++ programmers out,
	that in itself would be a huge reason to use C.
	
	In other words: the choice of C is the only sane choice. I know Miles
	Bader jokingly said "to piss you off", but it's actually true. I've come
	to the conclusion that any programmer that would prefer the project to be
	in C++ over C is likely a programmer that I really *would* prefer to piss
	off, so that he doesn't come and screw up any project I'm involved with.
	
	C++ leads to really really bad design choices. You invariably start using
	the "nice" library features of the language like STL and Boost and other
	total and utter crap, that may "help" you program, but causes:
	
	 - infinite amounts of pain when they don't work (and anybody who tells me
	   that STL and especially Boost are stable and portable is just so full
	   of BS that it's not even funny)
	
	 - inefficient abstracted programming models where two years down the road
	   you notice that some abstraction wasn't very efficient, but now all
	   your code depends on all the nice object models around it, and you
	   cannot fix it without rewriting your app.
	
	In other words, the only way to do good, efficient, and system-level and
	portable C++ ends up to limit yourself to all the things that are
	basically available in C. And limiting your project to C means that people
	don't screw that up, and also means that you get a lot of programmers that
	do actually understand low-level issues and don't screw things up with any
	idiotic "object model" crap.
	
	So I'm sorry, but for something like git, where efficiency was a primary
	objective, the "advantages" of C++ is just a huge mistake. The fact that
	we also piss off people who cannot see that is just a big additional
	advantage.
	
	If you want a VCS that is written in C++, go play with Monotone. Really.
	They use a "real database". They use "nice object-oriented libraries".
	They use "nice C++ abstractions". And quite frankly, as a result of all
	these design decisions that sound so appealing to some CS people, the end
	result is a horrible and unmaintainable mess.
	
	But I'm sure you'd like it more than git.

	        Linus
	--------------------------------------------------------------------------------
	From: Linus Torvalds
	Subject: Re: Compiling C++ kernel module + Makefile
	Date: Mon, 19 Jan 2004 22:46:23 -0800 (PST)
	
	
	On Tue, 20 Jan 2004, Robin Rosenberg wrote:
	>
	> This is the "We've always used COBOL^H^H^H^H" argument.
	
	In fact, in Linux we did try C++ once already, back in 1992.
	
	It sucks. Trust me - writing kernel code in C++ is a BLOODY STUPID IDEA.
	
	The fact is, C++ compilers are not trustworthy. They were even worse in
	1992, but some fundamental facts haven't changed:
	
	 - the whole C++ exception handling thing is fundamentally broken. It's
	   _especially_ broken for kernels.
	 - any compiler or language that likes to hide things like memory
	   allocations behind your back just isn't a good choice for a kernel.
	 - you can write object-oriented code (useful for filesystems etc) in C,
	   _without_ the crap that is C++.
	
	In general, I'd say that anybody who designs his kernel modules for C++ is
	either
	 (a) looking for problems
	 (b) a C++ bigot that can't see what he is writing is really just C anyway
	 (c) was given an assignment in CS class to do so.
	
	Feel free to make up (d).
	
	        Linus
	--------------------------------------------------------------------------------

As a consequence linux-2.4 kernel must be forked for TinyCC toolchain support, with some patches applied to keep it up-to-date with some security and scalability extensions: [linux-tcc](https://codeberg.org/aggi/linux-tcc)
This kernel can be compiled with TinyCC either [AoT](https://en.wikipedia.org/wiki/Ahead-of-time_compilation), or [JiT](https://en.wikipedia.org/wiki/Just-in-time_compilation) with [tccboot](https://bellard.org/tcc/tccboot.html). Both AoT or a JiT compiled kernel relies upon [X86 16bit real-mode](https://en.wikipedia.org/wiki/Real_mode) for initial [bootcode](#Boot-Code), which is dicussed separately in the [assembler section](#Assembler).

To ensure test-coverage with various other kernel versions and architectures GCC must be retained as it was shown with bootstrappable.org kernel bootstrapping procedure. For tinyfront system finally it is ARCH=x86 again intersecting with linux-2.4 kernel remaining *only* to ensure portability towards different toolchains with TinyCC.

# Libc
The choice of [standard C-library](https://en.wikipedia.org/wiki/C_standard_library) is limited by the available linux-2.4 kernel and TinyCC toolchain combination already. In principle [musl-libc](https://musl.libc.org) is portable towards many architectures and recent kernel versions with [decent reputation for it's size and standard-compliance](https://www.etalabs.net/compare_libcs.html).
Since bootstrappable.org too had chosen musl-libc-1.1.24 version with an early bootstrapping stage and TinyCC involved in live-bootstrap, some related portability issues were coped with already:

&nbsp;		|musl-1.1.x		|musl-1.2.x	|newlib(3)	|glibc(4)	|
----------------|-----------------------|-------------------------------|---------------|
**TinyCC**	|***STATIC OK(1)***	|INCOMPLETE(2)	|OPTIONAL(3)	|IRRELEVANT	|
GCC4		|OK			|OK		|IRRELEVANT	|IRRELEVANT	|
GCC6		|OK			|OK		|IRRELEVANT	|IRRELEVANT	|

1. None of the [musl-libc versions](https://wiki.musl-libc.org/supported-platforms) mentions official support for linux-2.4 kernel [system call](https://en.wikipedia.org/wiki/System_call) [application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface) (ABI) with multi-threading, which seems to rely upon [NPTL](https://en.wikipedia.org/wiki/NPTL). Required [patches were rebased back onto linux-2.4](https://codeberg.org/aggi/linux-tcc/commit/75452534b84677468a6f6032096ad56ebb93024a). Further patching for linux-2.4 syscall ABI involved merely some headers removed for unsupported syscalls to prevent runtime ENOSYS errors and avoiding userspace compile-time mis-leading header tests against musl-libc.
2. musl-1.2.x version is used with GCC test-vectors without priority for TinyCC support since musl-1.1.24 is mostly stabilized for linux-2.4 syscall ABI.
3. [Newlib from IBM/RedHat](https://sourceware.org/newlib) was chosen by [fiwix.org operating system](https://fiwix.org) and portability tested there. Although newlib can be considered as an alternative option for tinyfront it is not necessary because the test-vector is covered by fiwix.org already.
4. Supporting [GNU libc](https://www.gnu.org/software/libc) with TinyCC seems unrealistic and glibc is test-covered by hundreds of distributions for the sake of joy of millions of users and developers.

Keeping musl-libc portable for both linux-2.4 and linux-5 with full cross-compilation support is the major criteria for a complete userspace including development utilities remaining with all relevant test-vectors. Libc compatibility with various other [kernels](#Kernel) and [architectures](#Architectures) is not investigated further.

TODO:

- header review for clashes between linux-2.4 and musl-libc with u64/__u64/uint64, off_t, loff_t, wchar_t definitions
- cross-check KERNEL_STRICT_NAMES definition
- verification of tinycc headers involved against linux-2.4 and musl-libc
- 32bit timestamp limitations with filesystem calls (stat etc)
- 64bit at block layer (losetup/loopdev for example)
- LARGEFILE_OFFSET definition
- backup of any data persisted with tinyfront system is recommended

# Linking
&nbsp;		|dynamic		|static		|
----------------|-----------------------|---------------|
**TinyCC**	|***FAILED(1)***	|***OK(2)***	|
GCC		|OK			|IRRELEVANT	|

1. Dynamic-linking[^dynamic-linking] support is test-covered with GCC sufficiently. With TinyCC however an unresolved problem causes [musl-libc dynamic loader libc.so segfault](https://lists.gnu.org/archive/html/tinycc-devel/2024-11/msg00043.html) and **optional** dynamic linking support cannot be offered yet.
2. As a consequence static-linking must be supported with **all** [userspace system components](#Userspace-Fork) for TinyCC. By coincidence static-linking is a suitable option with tinyfront system which too enforces this test-vector variable being **fully** covered which it rarely ever was among hundreds of "distributions" elsewhere (except Oasis Linux for example, tinyfront system, and 9front.org)

[^dynamic-linking]: "I tend to think the drawbacks of dynamic linking outweigh the advantages for many applications." John Carmack [harmful.cat-v.org](https://harmful.cat-v.org/software/dynamic-linking)

Finally a complete test-vector got intersected for [i586-tinycc-linux2-musl.iso](download.html) completely statically linked with TinyCC.

# Assembler
&nbsp;		|x86 real-mode	|x86_32		|x86-64		|aarch32(6)	|aarch64	| riscv-64	|
----------------|---------------|---------------|---------------|---------------|---------------|---------------|
**TinyCC**	|**MISSING(1)**	|**OK(3)**	|INCOMPLETE	|INCOMPLETE	|--		|OPEN(4)	|
AS86(2)		|**(OK)**	|--		|--		|--		|--		|--		|
Binutils	|OK(5)		|OK		|OK		|OK		|OK		|OK		|

1. [Regression in TinyCC X86 assembly/pre-processor parser](https://lists.gnu.org/archive/html/tinycc-devel/2024-11/msg00020.html) noticed. [Principle issues with X86 16bit real-mode assembly](https://lists.gnu.org/archive/html/tinycc-devel/2024-11/msg00055.html) exist. TinyCC itself cannot support X86 real-mode assembler required for bootloader, kernel and tccboot.
2. As an alternative [AS86 assembler](https://wiki.osdev.org/AS86) exists which a re-write of real-mode asm from [AT&T GAS syntax](https://tldp.org/HOWTO/Assembly-HOWTO/gas.html) to [Intel syntax](https://en.wikipedia.org/wiki/X86_assembly_language#Syntax) is necessary with.
3. Inline assembly inside linux-2.4 kernel, musl-libc and [syslinux-3.86 bootloader](https://wiki.syslinux.org) passed.
4. The status of riscv64 assembler with TinyCC was not investigated yet. Notable development activity exists for a long-term perspective.
5. [GNU binutils](https://www.gnu.org/software/binutils/) can be compiled/bootstrapped with TinyCC, which introduces a circular dependency because binutils were required **before** bootstrapping of them was possible. Bootstrappable.org however implemented various loaders and assemblers (stage0-posix.hex) and with this approach TinyCC and binutils can be emitted to proceed without a circular dependency.
6. [arm-tcc compilation error while processing inline assembly](https://lists.gnu.org/archive/html/tinycc-devel/2025-05/msg00003.html)

# Boot Code
Tinyfront system and too bootstrappable.org rely upon [X86](https://en.wikipedia.org/wiki/X86) hardware introduced in 1978 ever since then supporting real-mode [IBM-PC BIOS](https://en.wikipedia.org/wiki/BIOS) boot! Since [Intel&reg; began phasing out real-mode boot](https://www.anandtech.com/show/12068/intel-to-remove-bios-support-from-uefi-by-2020) with their latest [UEFI](https://en.wikipedia.org/wiki/UEFI_CSM#CSM_booting) this poses an unpreceeded risk for **loss of [backward compatibility](https://en.wikipedia.org/wiki/Backward_compatibility)** preventing tinyfront system boot and threatening the **only** complete bootstrapping path to arrive at a bootable kernel that existed with bootstrappable.org and was relied upon for any other system that got cross-compiled from some ARCH=x86 host.[^CSM-emulation]

[^CSM-emulation]: Chainloading a UEFI-shim payload which can emulate real-mode BIOS boot with [https://github.com/FlyGoat/csmwrap](https://github.com/FlyGoat/csmwrap) remains inconclusive if basic hardware initialization for Vesa-graphics, SATA/IDE disks and interoperatbility with kernel were guaranteed to initialize hardware including APIC, USB on latest Intel&reg; with their own [CSM vendor-specification efi-compatibility-support-module-specification-v098.pdf](https://www.intel.com/content/dam/www/public/us/en/documents/reference-guides/efi-compatibility-support-module-specification-v098.pdf)

Binutils assembler introduced a gigantic circular dependency graph into tinyfront system for real-mode asm of booloader, kernel and optional [tccboot](https://bellard.org/tcc/tccboot.html) JiT kernel compilation support. Currently at least binutils can be bootstrapped to remain self-hosting with TinyCC easily. AS86 would introduce a far less critical dependency graph. Depending on when linux-2.4 booted into was necessary to proceed with bootstrapping a 16bit real-mode bootcode assembler is needed rather early during bootstrapping. For earliest stages of bootstrapping it may not be necessary to rewrite bootcode because bootstrappable.org got a system integration with their custom loaders/hex-assemblers to arrive at binutils and/or AS86.

Further system integration issues and circular dependencies involved with firmware-development and deployment of [Coreboot](https://www.coreboot.org) and [SeaBIOS](https://www.seabios.org/SeaBIOS) relying upon GNU toolchain are not covered and circular dependencies cannot be avoided without [considerations for choice of hardware](#Considerations-for-Choice-of-Hardware).

No other test-vector than i586-tinycc-linux2-musl.iso is investigated further, because no known option exists to avoid circular dependencies and other systems in question indirectly rely upon initial bootstrapping with X86 and cross compilation still.

# Cross Compilation
To produce i586-tinycc-linux2-musl.iso tinyfront system two options exist:

- Either with "full source bootstrapping" spawning the system from the bootstrappable.org dependency chain directly which was verified outside tinyfront project by bootstrappable.org having implemented the preceeding stage to provide TinyCC compiler runtime. Feasibility of spawning [gentoo tooling](https://gentoo.org) was confirmed.
- And cross-compiling from any existing Linux operating system which gentoo tooling was chosen for dependency-tracking and gradually re-fining the system profile for compliance with acceptance criteria. Problems introduced with Python dependency are discussed in the following [development utilities chapter](#Development-Utilities).

&nbsp;				|TinyCC		|GCC	|
--------------------------------|---------------|-------|
Cross-Compiling BUILD!=TARGET	|**BUGS**(1)	|OK(2)	|
Canadian-Cross			|**BUGS**(1)	|OK(2)	|

1. Currently TinyCC support to emit [i586-tinycc-linux2-musl.iso](download.html) tinyfront system was hacked into [gentoo crossdev](https://wiki.gentoo.org/wiki/Crossdev) with some [crossbuild scripting](src.html#gitweb.md) and a forked portage tree. So far a BUILD=HOST=TARGET=x86 crossdev-setup to swap toolchain from GCC towards TinyCC was confirmed. TinyCC itself seems to be affected by [mis-compiled binaries with i386-tcc for TARGET=x86 on BUILD=arm host](https://lists.gnu.org/archive/html/tinycc-devel/2025-05/msg00000.html).
2. It is possible to bootstrap GNU toolchain with TinyCC still to retain flexibility and test-coverage for any other TARGET than ARCH=x86, which cross-compilation is a common approach for and the reason why bootstrapping chain with ARCH=x86 build-host must remain stable.

# Development Utilities
System integration and build system tooling must be covered in the complete [portability test-matrix](#Portability-and-Test-Coverage) with a complete [bootstrapping chain](#Bootstrapping) and self-hosting.

Since compatibility was prioritized most build system development tools are covered by POSIX standardization:

- [Makefiles](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html)
- [M4 macros](https://en.wikipedia.org/wiki/M4_%28computer_language%29) for GNU Automake/Autoconf
- [Shell script](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)

However, [GNU autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) and [gentoo portage](https://wiki.gentoo.org/wiki/Portage) relied upon with self-hosting system-integration of all test-vectors currently, the dependencies of [Perl](https://www.perl.org) and [Python](https://www.python.org) must be maintained for compliance with acceptance criteria too, even when these languages are **not** covered by POSIX standardization.
To keep Perl and Python optional implies significant effort for re-writing packaging, which is feasible and demonstrated with [Oasis Linux](https://github.com/oasislinux/oasis) for example which avoid autotools and with it Perl completely. Gentoo tooling can be replaced with an alternative [void xbps](https://docs.voidlinux.org/xbps/index.html) to abandon Python then. An extension beyond standardization with Perl/autotools and Python/portage is considered less severe than an otherwise urgent re-write of build-system and packaging for the [userspace fork](#Userspace-Fork), because:

1. Python can be bootstrapped and remain self-hosting with TinyCC, then too **optional** Gentoo-tooling can be bootstrapped and remain self-hosting for all relevant test-vectors.
2. For GNU autotools a recent perl-5.36.0 version besides the older perl-5.8.6 passed with TinyCC toolchain, the latter required to cover bootstrapping and the former confirmed for cross-compilation for all relevant test-vectors.

With autotools/autoreconf/Perl and portage/Python mainline system-integration tooling is available, both [bootstrappable](https://en.wikipedia.org/wiki/Bootstrappable_builds) and [self-hosting](https://en.wikipedia.org/wiki/Self-hosting_%28compilers%29). As a compromise these must remain an **optional extension beyond standardization with POSIX** and it is **not** considered a violation of standards with defined acceptance criteria then.

An alternative [POSIX make](https://frippery.org/make) implementation exists to replace [GNU make](https://www.gnu.org/software/make) with. Other [BSD make](https://wiki.netbsd.org/tutorials/bsd_make) or [9front mk](https://man.9front.org/1/mk) peculiarities are not investigated. [CMake](https://cmake.org) generator must be avoided because it is implemented in C++ itself and by this blocks vendor-neutral toolchain portability.

# Userspace Fork
With bootstrapping arriving at TinyCC compiler, bootable kernel, and musl-libc patched for linux-2.4 system call ABI everything is prepared for tinyfront userspace components:

- Sanitized from C++ and GNU toolchain (g++) build-time dependency fully detangled as optional dependency
- Remaining portable towards all relevant test-vectors with either GCC or TinyCC toolchain
- With full cross-compilation support of the complete profile
- For either linux-2.4 or linux-5 system call ABI remaining flexible with [musl-libc](#Libc)
- static linking
- Including all required development utilities across all relevant test-vectors to remain self-hosting

With linux-2.4 some components had to be backtracked and bisected for compatibility accross 20years with sources salvaged from [various archives](src.html#code-diverse.md).

For compliance with acceptance criteria and extended portability ~500 ebuilds were forked and kept in maintenance. Syncing against available portage tree was re-confirmed up until latest ~testing branch Feb/2025 with the forked portage tree containing hundreds of patches at [tinyfront/gitweb](src.html#gitweb.md).

Various additional features are:

- libressl
- netbsd-curses
- dvtm, vis-editor
- suckless goodies etc.
- scientific authoring
- multi-media fun

See [tinyfront-profile.list](downloads/tinyfront-profile.list) in the download section for an overview of all components retained with tinyfront system.

# Bootstrapping and Compilation Instructions
Tinyfront system integration was designed to simplify ["full source bootstrapping"](#Acceptance-Criteria) of a complete system from scratch to emit a final bootable [CD ISO](https://en.wikipedia.org/wiki/ISO_9660) release fully automated with:

- [live-bootstrap](https://github.com/fosslinux/live-bootstrap) scripting
- and [crossbuild](src.html#gitweb.md) scripting for kernel and userspace cross-compilation towards all relevant test-vectors

Development and testing of individual software updates is possible with the [system integration tooling](#Development-Utilities) to integrate updates into subsequent release builds of bootable tinyfront ISOs.

# Considerations for Choice of Hardware
Since ARCH=x86 remains the major test vector with TinyCC this implies choice of hardware made with it. Sufficient and affordable long term refurbished hardware supply with processing power is available:

- However portability towards linux-2.4 impacts support for USB, SATA, Ethernet, SMP must remain with it. In particular a backport for a commonly available usb-ethernet is required because no standard implementation for ethernet chips exists for dozens of different manufacturers.
- Some Libre Firmware options such as [Coreboot](https://www.coreboot.org) or [U-Boot Loader](https://www.u-boot.org) should exist even when those would clash with acceptance criteria by introducing circular dependencies into the build-time dependencies for firmware bootstrapping.
- Free/Open SoC designs for FPGA deployment should exist even when those would clash with acceptance criteria by introducing circular dependencies with hardware design and development utilities.
- For ARCH=x86 some interesting i486 SoC deployment onto FPGA was demonstrated already with [ao486 project](https://github.com/MiSTer-devel/ao486_MiSTer), which too got libre firmware support implemented. Depending on vendor chosen for hardware-development some of this is [free/opensource with Lattice-Semi](https://wiki.debian.org/FPGA/Lattice).
- Avoiding any circular dependency with hardware development tooling involved indicates a most severe regression of more than 40years back till [z80](https://en.wikipedia.org/wiki/Zilog_Z80) with [S-100 BUS](https://en.wikipedia.org/wiki/S-100_bus) 16bit systems predating the [original IBM PC](https://en.wikipedia.org/wiki/IBM_Personal_Computer) proprietary system.

For additional cross-compilation test-vectors towards ARCH=arm32/64 the [rock64 device](https://pine64.org/devices/rock64) from pine64.org project was used with GNU toolchain, linux-5 kernel, and fully "libre" u-boot loader firmware available.

Bootstrapping attempts outside X86 PC realm with both hardware development and software covered are leaving traces back until the early days of [Research Unix](https://en.wikipedia.org/wiki/Research_Unix) for example projects maintained until today at [MIT](https://en.wikipedia.org/wiki/MIT) to study ancient [PDP-11](https://en.wikipedia.org/wiki/PDP-11) of nowadays defunct [Digital Equipment Corporation](https://en.wikipedia.org/wiki/Digital_Equipment_Corporation) (DEC) running [xv6 teaching operating system](https://ocw.mit.edu/courses/6-828-operating-system-engineering-fall-2012/pages/study-materials).

# Installation Instructions
With a zero-config approach for a bootable live-system ISO release with read-only squashfs tinyfront system does not need any installation. The ISO image can easily be burned onto CD-ROM or [real-mode bootable hybrid-ISO filesystem](https://en.wikipedia.org/wiki/Hybrid_CD) disk-dumped onto USB flash memory.

# System Configuration
see [rc.tiny](src.html#gitweb.md):
- IPv4 networking setup
- [scrambled ssh](projects.html#scram.md)
- [scrambled loopdev partitions](projects.html#scram.md)

