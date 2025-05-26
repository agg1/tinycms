# Summary
This developer manual documents the process of establishing and maintaining a **complete** mostly-GNU/POSIX operating system profile fully supported with TinyCC toolchain for tinyfront operating system (TOS). To accomplish this task a kernel, libc, development-utilities and software component portage-tree were fully forked. For sufficient test coverage and portability several system-deployment variants are kept in maintenance with a final operating system distribution
[i586-tinycc-linux2-musl.iso](download.html) being the major test-vector which specific **acceptence criteria** must be complied with.

# Acceptance Criteria
Given common definitions with:

- **Full standards compliance** which implies **all** components are covered by standardization
- Without an **extension beyond standardization** which may not necessarily *violate* any standard
- If any extension remained an **optional dependency** either build-time or run-time, direct or transitive
- And finally a **standard violation** exists if any extension got introduced as **mandatory dependency**.

In other words if any system cannot be compiled or booted without the presence of non-standard extensions then standards were **violated**, otherwise this might qualify merely as a less intrusive extension beyond standards or fully standards compliant still.

Relying on [OpenSource Software](https://en.wikipedia.org/wiki/Open-source_software) with permissive licensing is a necessitity but insufficient for full compliance, and **vendor-neutral** standards must be strictly distinguished from vendor specifications, for example:

- C language following ANSI/ISO C99 standard had proven decent, somewhat stable for 25years
- In comparison rust-lang follows a vendor specification but not any standard
- Although C++ language is standardized it introduces mandatory transitive dependencies towards components not covered by standardization

With tinyfront system *full standards compliance is not feasible* and extensions beyond standardization are not avoidable, but the system ***must not violate standards*** with given definition by introducing a mandatory extension beyond [POSIX](https://en.wikipedia.org/wiki/POSIX) or [ANSI/ISO C](https://en.wikipedia.org/wiki/ANSI_C) unnecessarily. Tinyfront system fights the battle against the malicious vendor strategy to ["Embrace, Extend, Extinguish"](https://en.wikipedia.org/wiki/Embrace,_extend,_and_extinguish) which almost always non-standardized mandatory extensions were utilized for in the tech industry dominated by hostile actors imposing their [anti-competitive](https://en.wikipedia.org/wiki/Anti-competitive) habits with vendor-specifications onto developers and users. Furthermore standardization itself is prone to infringement of **compatibility** and **interoperability** when following latest iterations with all features implemented (C++, C11), hence a conservative approach is reasonable to exclude various standard features since this does not necessarily violate a standard. Often an *incomplete* implementation of any standard is less severe than violating a standard with mandatory extensions.

Due to various interdependent issues involved with TOS in detail:

- first all c++ dependencies were sanitized from the dependency graph to keep those **optional**
- [cross-compilation](#Cross-Compilation) of the complete system profile was verified for all test-vectors
- [static linking](#Linking) support with [~500 software components forked]() was confirmed
- [slibtool](https://dev.midipix.org/cross/slibtool) had to be fully integrated into the build system
- with TinyCC a **complete** profile including development utilities was verified to compile and boot
- of cause [GCC](https://gcc.gnu.org/) can be retained to extend test-coverage
- but GNU toolchain will be fully optional since when recent versions transitioned to c++ internally

And by extending [portability](#Portability-and-Test-Coverage) back towards [linux2 syscall ABI](#Kernel) and [TinyCC](https://bellard.org/tcc) in [software engineering](https://en.wikipedia.org/wiki/Software_engineering#Criticism) terms:

- [Compatibility](https://en.wikipedia.org/wiki/Software_incompatibility) is prioritized over
- [Interoperability](https://en.wikipedia.org/wiki/Interoperability) which implied unstable non-standard components for latest feature creep

# Bootstrapping
A precise definition for "full source bootstrapping" is required and important terminology must not be confused for:

1. A **"source-based" workflow** with *full coverage beginning with a tiniest boot-seed* written in documented hex-code minimalist [asm](https://en.wikipedia.org/wiki/Assembly_language).
2. Then **["reproducibility" of binary artifacts](https://en.wikipedia.org/wiki/Reproducible_builds)** produced from source-code with any toolchain, btw. which can be achieved without source-based bootstrapping too, which is no major concern, but certainly a relevant criteria.
3. Furthermore **["circular dependency"](https://en.wikipedia.org/wiki/Circular_dependency)** graph by relying upon (binary) development utilities _before_ those could have been bootstrapped reliably themselves. This instead again is high priority to avoid any, initially at least by shrinking the size of dependency graphs of involved components, which is a gradual process to dissect and take down. TinyCC support is shrinking the size of an otherwise non-optional dependency graph of gcc/binutils alike. Because binary artifact "reproducibility" is a less critical concern when circular dependencies vanished, and trust into emitted binary artifacts can be fully derived from "full source bootstrapping".

Strict acceptence criteria for [system integration](https://en.wikipedia.org/wiki/System_integration) rely upon both hardware **and** software components documented and fully re-producible from schematics and source-code. Initially tinyfront system refers to software-context specifically down to most basic software components closest to hardware. Criteria for choice of hardware must be discussed separately. With [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping) in particular the development tools and the [software toolchain](https://en.wikipedia.org/wiki/Toolchain) which is mainly an assembler, compiler and linker required must comply with acceptance criteria themselves too. The project [bootstrappable.org](https://bootstrappable.org) is dedicated to this and describes in detail how a [GNU toolchain system](https://gnu.org) can be re-established beginning with some tiniest bootloader and assembler and the whole procedure for this documented with [live-bootstrap](https://github.com/fosslinux/live-bootstrap) sources. With such procedure a complicated dependency graph of the software supply chain is defined explicitely then for build-time and run-time dependencies, instead of trusting unverifiable binary artifact development utilities of unknown origin how these could ever have been produced in the beginning.[^Thompson-Hack]

[^Thompson-Hack]: [Ken Thompson Hack injects a virus into compiler whose source code thereafter contains no evidence](https://wiki.c2.com/?TheKenThompsonHack)

All test-vectors should have a complete bootstrapping path which so far was confirmed with ARCH=x86 only, and of cause the final system must be [self-hosting](https://en.wikipedia.org/wiki/Self-hosting_compilers)[^Self-Hosting] including all required [development utilities](#System-Integration-Utilities).

[^Self-Hosting]: A system-integration path being self-hosting without bootstrapping procedure disclosed then hides the early-stages when a virus may be injected into the toolchain with the Thompson-Hack and no traces of evidence remain within the source code available.

With tinyfront acceptance criteria both bootstrapping and self-hosting must be confirmed. Therefore tinyfront system will converge and fully re-integrate with a complete bootstrapping chain, with a slightly differing approach than bootsrappable.org:

- While bootstrappable.org confirmed the feasibility of bootstrapping gcc and binutils with TinyCC anyway
- Instead of bootstrapping TinyCC to compile a complete GNU toolchain early to spawn userspace components with
- TinyCC itself instead is used to compile the **complete** TOS system profile *before* gcc/binutils were available
- To benefit from it's specific design principle as single-pass compiler with superior compile-time performance
- Which furthermore extends portability requirements for the base sytem profile with both TinyCC and **optional** GCC/binutils later
- Although TinyCC chosen as main system compiler limits the available [kernel](#Kernel) and [libc](#Libc) options
- Flexibility with toolchain options available is increased because TinyCC verification too establishes a **[baseline](https://en.wikipedia.org/wiki/Baseline_configuration_management)** for any other hypothetical [system-ingegration](https://en.wikipedia.org/wiki/Integration_testing) [test-vector](https://en.wikipedia.org/wiki/Test_vector)

Mentioned approaches of tinyfront system and bootstrappable.org do not conflict with each other, but strictness of acceptance criteria varies slightly with either. Relying upon a clean bootstrapping chain implies some important [portability](#Portability-and-Test-Coverage) issues were coped with appropriately in any case. And with either approach gcc/binutils can be bootstrapped anyway.

# Portability and Test Coverage
To ensure system integration test-coverage of any test-vector a **complete** system must compile and boot.
Meanwhile then portability and bootstrapping **with** and **of** any component such as:

- Assembler
- Compiler
- Libc
- Kernel
- etc.

must not be confused. For example GNU Compiler (GCC) is recognized for it's support of many architectures, but GCC itself is not easily bootstrapped. Although GCC ensures portability and cross-compilation towards many [architectures](#Architectures), for bootstrapping GCC itself TinyCC was required which currently limits the portability of GCC with this procedure to ARCH=x86. Furthermore only a [linux-2.4](#Kernel) can be supported with both GCC **and** TinyCC toolchain, but this linux-2.4 kernel version itself again was not portable to various [architectures](#Architectures) with TinyCC other than ARCH=x86 again.

The multi-dimensional test-case matrix expands to rather many test-cases which cannot be all verified individually. Hence careful choices to prioritize test-cases to limit their total amount was necessary to cover as many other indirectly related ones. The choice of TinyCC toolchain as major test-vector merely is the result of intersecting all options against acceptance criteria. Supporting a complete tinyfront operating system release with [i586-tinycc-linux2-musl.iso](download.html) then imposes practical limitations, but test coverage against acceptance criteria and bootstrapping intersects far more test-cases with it than using GNU toolchain to emit any distribution for a dozen different architectures with hundreds of "different" distributions following a fast-paced release-cycle to integrate latest kernels and compiler versions would.

Limitations of portability and conflicts with [acceptance criteria](#Acceptance-Criteria) are mentioned for individual combinations in the following chapters.

# Architectures
&nbsp;		|**x86/32**	|x86/64		|aarch32	|aarch64	|riscv64	|other(4)	|
----------------|---------------|---------------|---------------|---------------|---------------|----------------
GCC4		|OK		|OK		|OK		|--		|--		|IRRELEVANT	|
GCC6		|OK		|OK		|OK		|OK		|UNKNOWN	|IRRELEVANT	|
**TinyCC(1)**	|**OK**		|INCOMPLETE	|INCOMPLETE	|INCOMPLETE	|OPEN(3)	|IRRELEVANT	|
cproc/qbe(2)	|--		|PARTIAL(2)	|--		|--		|--		|IRRELEVANT	|

1. A complete mostly-POSIX base system profile fully supported with TinyCC establishes a **baseline** for any other OS|ARCH|CC variant (for example bsd|riscv|cproc etc), since i386-tcc partially covers relevant issues for any other such approach such as sanitizing the profile from c++. Obviously TinyCC alone cannot retain full test-coverage hence portability towards and with GCC is retained too.
2. [Oasis-Linux](https://github.com/oasislinux/oasis) supports a userspace with cproc compiler but kernel/bootloader require additional gcc/binutils to retain a complete system still.
3. Notable development efforts for RISCV64 is relevant for a long term perspective since Intel&reg; obsoleted their own x86 real-mode support required for both booting tinyfront system with and most important ARCH=x86 was the basis for any bootstrapping to begin with. Furthermore currently no other than ARCH=x86 got a somewhat clean and verified bootstrapping dependency chain implemented with [live-bootstrap](https://github.com/fosslinux/live-bootstrap) and a cross-compilation from any HOST=x86 towards another TARGET possible if that was not fully covered by [bootstrappable.org](https://bootstrappable.org) yet.
4. Other architectures are irrelevant with tinyfront system portability and compatibility.

Currently It is ARCH=x86 *only* which intersects to cover all test-cases for different toolchains still.

# Kernel
&nbsp;		|**linux2.4**	|linux5			|fiwix		|minix/hurd(5)	|OpenBSD	|other(7)	|
----------------|---------------|-----------------------|---------------|---------------|--------------------------------
**TinyCC**	|**OK(1)**	|**FAILED(2)**		|OK(4)		|--		|**?**		|IRRELEVANT	|
GCC4		|OK/all-arch	|PATCHED/all-arch(3)OK	|IRRELEVANT	|--		|--		|IRRELEVANT	|
GCC6		|OK/all-arch	|OK/all-arch		|IRRELEVANT	|--		|--		|IRRELEVANT	|
(PCC)		|--		|--			|--		|--		|OBSOLETE(6)	|IRRELEVANT	|

1. Linux-2.4 advantages are its relatively lower amount of total lines-of-code, sufficient hardware support for USB, SATA, Ethernet, ARCH=X86 tested for stability for decades and long term refurbished hardware supply and processing power available.
2. A last known approach to compile/link any later kernel version with TinyCC was documented for [linux-4.6 by SUSE toolchain maintainer susematz](https://github.com/torvalds/linux/compare/master...susematz:linux:tcc46) which did not fully pass (gcc -S missing, linker-script support missing). 
3. Mainline linux-5 kernel series introduced manadatory C11 features and version-bumped compiler requirements, which severly infringed compatibility even with GCC4 (non-c++) further. To retain the test-vector intersecting of GCC4 with linux5 versions and other architectures a patch was necessary available in the download section [linux-5.9.16-gcc47.patch](downloads/linux-5.9.16-gcc47.patch)
4. [Fiwix](https://fiwix.org) kernel which is written in 50000 lines of code only would be more elegant however this one hasn't got hardware support for USB/ethernet etc.; Fiwix kernel is required with and test-covered by bootstrappable.org project with TinyCC.
5. Untested and known for limited hardware support, focused on x86 mainly
6. Outside tinyfront project awareness of [toolchain issues among OpenBSD project](https://www.cambus.net/the-state-of-toolchains-in-openbsd) exists yet the transition towards [llvm/clang](https://llvm.org) and with it C++ was not avoidable with it. The status of ["Bringing PCC into The 21th century"](https://www.openbsd.org/papers/magnusson_pcc.pdf) remained [inconclusive ever since year 2007](https://lwn.net/Articles/255558/). Supporting a complete [OpenBSD](https://openbsd.org) kernel and base system compiled with TinyCC seems a feasible future prospect to expand coverage towards, which tinyfront system itself can be used for as initial buildhost once complete bootstrapping was covered with it, and a currently absent bootstrapping chain for OpenBSD could be re-established.
7. Other kernels are irrelevant with tinyfront system portability and compatibility.

Tinfyfront linux-2.4 kernel was forked for TinyCC toolchain support, with some patches applied to keep it up-to-date with some security and scalability extensions: [linux-tcc](https://codeberg.org/aggi/linux-tcc)

No other kernel version can fully intersect toolchain support for TinyCC. To ensure test-coverage with various other kernel versions GCC must be retained. Finally it is ARCH=x86 again and linux-2.4 kernel remaining *only* to ensure portability towards different toolchains.

# Libc
In principle [musl-libc](https://musl.libc.org) is portable towards many architectures and recent kernel versions with [decent reputation for it's size and standard-compliance](http://www.etalabs.net/compare_libcs.html). And the choice of [standard C-library](https://en.wikipedia.org/wiki/C_standard_library) is limited by the available linux-2.4 kernel and TinyCC toolchain combination already and any libc must be compatible with those. Since bootstrappable.org too had chosen musl-libc-1.1.24 version with an early bootstrapping stage and TinyCC involved in live-bootstrap, some related portability issues were coped with already:

&nbsp;		|musl-1.1.x		|musl-1.2.x	|newlib(3)	|glibc(4)	|
----------------|-----------------------|-------------------------------|---------------|
**TinyCC**	|***STATIC OK(1)***	|INCOMPLETE(2)	|OPTIONAL(3)	|IRRELEVANT	|
GCC4		|OK			|OK		|IRRELEVANT	|IRRELEVANT	|
GCC6		|OK			|OK		|IRRELEVANT	|IRRELEVANT	|

1. None of the [musl-libc]() versions mentions official support for linux-2 kernel [system call](https://en.wikipedia.org/wiki/System_call) [application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface) (ABI). musl-libc seems to rely upon [NPTL](https://en.wikipedia.org/wiki/NPTL) support from kernel, hence required [patches were rebased back onto linux-2.4]() for threading support. Patching musl-libc for linux2 syscall ABI required merely some headers removed for unsupported syscalls to prevent runtime ENOSYS errors and preventing userspace compile-time mis-leading header tests against musl-libc.
2. musl-1.2.x version is used with GCC test-vectors without priority for TinyCC support since musl-1.1.24 is mostly stabilized against linux-2.4 syscall ABI.
3. [Newlib libc]() was chosen by [fiwix.org operating system](https://fiwix.org) and portability tested there. Although newlib can be considered as an alternative option for tinyfront it is not necessary because the test-vector is covered by fiwix.org already.
4. Supporting [GNU glibc](https://www.gnu.org/software/libc) with TinyCC seems unrealistic and system support with glibc is test-covered by hundreds of distributions for the sake of joy of millions of users and developers already.

Keeping musl-libc portable towards either linux-2.4 or linux5 with full cross-compilation support is the major criteria for a complete userspace including all required development utilities remaining portable with most test-vectors too. Libc compatibility for various [kernels](#Kernel) and [architectures](#Architectures) is not investigated further.

TODO:

- header review for clashes between linux-2.4 and musl-libc with u64/__u64/uint64, off_t, loff_t, wchar_t definitions
- cross-check KERNEL_STRICT_NAMES definition
- verification of tinycc headers involved against linux-2.4 and musl-libc
- 32bit timestamp limitations with filesystem calls (stat etc)
- 64bit at block layer (losetup/loopdev for example)
- LARGEFILE_OFFSET definition
- backup of any data persisted with tinyfront system is recommended

# Linking
musl-libc libc.so dynamic loader crashes when compiled/linked with tcc

&nbsp;		|dynamic		|static		|
----------------|-----------------------|---------------|
**TinyCC**	|***FAILED(1)***	|***OK(2)***	|
GCC		|OK			|IRRELEVANT	|

1. Dynamic linking support is test-covered with GCC sufficiently. With TinyCC however an unresolved problem causes [musl-libc dynamic loader libc.so segfault]() and **optional** dynamic linking support cannot be offered yet.
2. As a consequence static linking must be supported with **all** [userspace system components](). By coincidence static linking is a suitable option with tinyfront system and too enforces the relevant test-vector being **fully** covered which rarely ever was among hundreds of "distributions" elsewhere (except Oasis Linux for example)

Finally a complete test-vector got intersected for [i586-tinycc-linux2-musl.iso](download.html) completely statically linked with TinyCC.

# Assembler
X86 real-mode assembler for booloader, kernel bootcode, and [tccboot]()

&nbsp;		|x86 real-mode	|x86_32		|x86-64		|aarch32	|aarch64	| riscv-64	|
----------------|---------------|---------------|---------------|---------------|---------------|---------------|
**TinyCC**	|MISSING(1)	|OK(3)		|INCOMPLETE	|INCOMPLETE	|--		|OPEN(4)	|
as86(2)		|OK		|--		|--		|--		|--		|--		|
binutils(5)	|OK		|OK		|OK		|OK		|OK		|OK		|

1.
It may not be necessary to rewrite linux/tccboot code for hex2/hex0 because
bootstrappable.org got a system integration to arrive at binutils and/or as86.
It would just be a little easier if a capable linux-2.4 kernel could be booted
earlier without relying on gcc and/or binutils.
2.
Although as86 would introduce a far less critical dependency graph, it too could cause a circular dependency against tcc, depending on when linux-2.4 booted into was necessary to proceed with bootstrapping, because 16bit real-mode asm bootcode is needed rather early during bootstrapping. For example by a feasible re-write of linux2 bootcode.S things for as86 syntax instead of GNU GAS which would introduce binutils for 16bit real-mode asm still.
3.
4.
5.

https://en.wikipedia.org/wiki/Backward_compatibility
So far i could only abandon gcc mandatory dependency for kernel and a complete
user-space of ~500 builds.

With regards to bootloaders, you wouldn't have a kernel and various utilities to
process 16bit real-mode assembly. tinycc itself wouldn't support 16bit real-mode
asm processing, yet tinycc would NOT be available during bootstrapping at the
stage 16bit x86 asm had to be processed already.

A few notes should be summarized:
- .code16 sections and 16bit real-mode support are mostly abandoned with tcc
- release-tag release_0_9_25 retained 16bit real-mode asm support iirc
- release_0_9_26 already had deactived it with #ifdefs
- finally https://repo.or.cz/tinycc.git/commitdiff/55bd08c5 removed it

With consequences to critical system components such as:
- x86 kernel and loaders including tccboot itself rely upon 16bit real-mode asm
- real-mode asm may be crucial to "kernel bootstrapping" that bootstrappable.org considers unresolved
- interestingly, earlier kernel versions (2.2 iirc) implemented their 16bit real-mode asm bootcode parts with another syntax than GNU gas one
- binutils-as introduce a gigantic dependency graph

I do not see a realistic chance to salvage 16bit real-mode support with tinycc myself; and FYI bootstrappable.org chose a different approach to implement x86 bootcode with their hex0 languages and loaders.

Currently, i could merely confirm binutils can be compiled/bootstrapped with tcc for this. Too linux-2.4 compiles and boots supported with tcc, and the binutil for 16bit asm. The linux-tcc repository is available at:

# Cross-Compilation
&nbsp;					|TinyCC		|GCC	|
----------------------------------------|---------------|-------|
Cross-Compiling beyond different ARCH	|**BUGS**(1)	|OK(2)	|
Canadian-Cross				|**BUGS**(1)	|OK(2)	|

1. i386-tcc produced mis-compiled binaries when residing on some arm/arm64 host it's tricky, because i spawned an aarch32 userspace atop an aarch64 kernel/uboot which got a 32bit binary compat layer (different to x86) although i ensured i386-tcc (which is an ARM EABI binary) picked up correct headers for target x86/linux2 _only_ it's miss-compiling x86 binaries; native x86 host needed with it so, either when compiling tcc itself it got confused over the aarch64/aarch32 situation (it's configured for --cpu=arm userspace explicitely though) or it's the foreign ARCH transition itself; can't test it on some full aarch64 currently, because compilation times are too excessive
2. Since TinyCC cross-compilation setups revealed bugs, it is possible to bootstrap gcc/binutils still and proceed with gcc thereafter to contain test-coverage towards other targets.

# System Integration Utilities
Since compatibility was prioritized with system integration of TOS most system integration are covered by standardization the system integration and build system tooling itself is covered by the complete [portability test-matrix](#Portability-and-Test-Coverage) and the presence of a complete [bootstrapping chain]() was confirmed by the feasibility of spawning TOS from [live-bootstrap project]().

bootstrappable and next self-hosting against _all_ involved test vectors

1. python can be bootstrapped and remain self-hosting with i386-tcc
2. and optional gentoo-tooling can remain self-hosting with i386-tcc
3. and publication would not be blocked by an urgent re-write of packaging of ~500builds maintained with portage currently, because python/portage are unblocked for extensive testing against i386-tcc now.

1. A recent perl-5.36.0 version
2. besides the older perl-5.8.6 passed with i386-tcc already too
3. the  latter supported with tcc and bootstrapping
4. the former supported with tcc _and_ cross-compilation beyond different ARCH

With autotools/autoreconf and python/ portage the major system-integration tooling is available, both with bootstrapping and self-hosting.

[crossdev]()

# Portage Fork for Support of a Complete mostly-POSIX base sytem profile
Fully supporting tcc with crossdev/portage was a hell of a hackjob.

kernel fork yet, well then of cause linux2 is "useless", if noone got a capable
libc for it driven by tinycc, to spawn those ~500 most recent up-to-date
software components confirmed with tinycc including development utilities atop.

removed all direct and transitive c++ dependencies static linking, and a few patches here and there for linux2 syscall abi compat and tinycc static linking.
ebuilds are sourced from freely available portage tree and were last synced to latest ~testing branch Feb/2025

see [profile.list]()

# Bootstrapping and Compilation Instructions
[live-bootstrap]() scripting to automate bootstrapping
[crossbuild]() scripting to automate (Unavailable tinyfront.org/gitweb)

# Installation Instructions
With a zero-config approach for a bootable live-system ISO with read-only squashfs Tinfront OS does not need any installation. The ISO image can easily be burned onto CD-ROM or the the hybrid-ISO disk-dumped onto USB flash memory.

# Configuration and System Administration
- networking setup
- default iptables
see [rc.tiny]()

# Additional TOS Features
- libressl
- dvtm
- netbsd-curses
- suckless goodies etc.
- scientific authoring
- multi-media fun

# Considerations for Choice of Hardware
- distinguish requirements for software-runtime
- and hardware development itself
- including compliance with acceptance criteria for hardware chose
- which indicates a most severe regression of more than 40years back till z80 era 16bit systems
