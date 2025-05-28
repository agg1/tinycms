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
- [static linking](#Linking) support for all [userspace software components forked]() was confirmed
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
- To benefit from it's specific design principle as [single-pass compiler](https://en.wikipedia.org/wiki/One-pass_compiler) with [exemplary compile-time performance](https://bellard.org/tcc)
- Which furthermore extends portability requirements for the base sytem profile with both TinyCC and **optional** GCC/binutils later
- Although TinyCC chosen as main system compiler limits the available [kernel](#Kernel) and [libc](#Libc) options
- Flexibility with toolchain options available is increased because TinyCC verification too establishes a **[baseline](https://en.wikipedia.org/wiki/Baseline_configuration_management)** for any other hypothetical [system-ingegration](https://en.wikipedia.org/wiki/Integration_testing) [test-vector](https://en.wikipedia.org/wiki/Test_vector)

Mentioned approaches of tinyfront system and bootstrappable.org do not conflict with each other, but strictness of acceptance criteria varies slightly with either. Relying upon a clean bootstrapping chain implies some important [portability](#Portability-and-Test-Coverage) issues were coped with appropriately in any case. And with either approach gcc/binutils can be bootstrapped anyway.

# Portability and Test Coverage
To ensure system integration test-coverage of any test-vector a **complete** system must compile and boot with a "full source bootstrapping" workflow.
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
3. Mainline linux-5 kernel series introduced manadatory C11 features and version-bumped compiler requirements, which severly infringed compatibility even with GCC4 (non-c++)[^GCC-nocpp] further. To retain the test-vector intersecting GCC4 with linux5 versions including ARCH=x86_64 a patch was necessary available in the download section [linux-5.9.16-gcc47.patch](downloads/linux-5.9.16-gcc47.patch)
4. [Fiwix](https://fiwix.org) kernel which is written in 50000 lines of code only would be more elegant however this one hasn't got hardware support for USB/ethernet etc.; Fiwix kernel is required with and test-covered by bootstrappable.org project with TinyCC.
5. Untested and known for limited hardware support, focused on x86 mainly
6. Outside tinyfront project awareness of [toolchain issues among OpenBSD project](https://www.cambus.net/the-state-of-toolchains-in-openbsd) exists yet the transition towards [llvm/clang](https://llvm.org) and with it C++ was unavoidable. The status of ["Bringing PCC into The 21th century"](https://www.openbsd.org/papers/magnusson_pcc.pdf) remained [inconclusive ever since year 2007](https://lwn.net/Articles/255558/). Supporting a complete [OpenBSD](https://openbsd.org) kernel and base system compiled with TinyCC seems a feasible future prospect to expand coverage towards, which tinyfront system itself can be used for as initial buildhost once complete bootstrapping was covered with it, and a currently absent bootstrapping chain for OpenBSD could be re-established.
7. Other kernels are irrelevant with tinyfront system portability and compatibility.

[^GCC-nocpp]: GNU compiler switched to c++ implementation language internally itself which blocks bootstrapping of it at gcc-4.7.4 since any later version requires a c++ compiler.

Tinfyfront linux-2.4 kernel was forked for TinyCC toolchain support, with some patches applied to keep it up-to-date with some security and scalability extensions: [linux-tcc](https://codeberg.org/aggi/linux-tcc)
Linux-2.4 can be compiled with TinyCC either [AoT](https://en.wikipedia.org/wiki/Ahead-of-time_compilation) or [JiT](https://en.wikipedia.org/wiki/Just-in-time_compilation) with [tccboot](https://bellard.org/tcc/tccboot.html). Either AoT or JiT compilation of kernel rely upon [x86 16bit real-mode](https://en.wikipedia.org/wiki/Real_mode) bootcode support, which is dicussed separately in the [assembler section](#Assembler).

No other kernel version can fully intersect toolchain support for TinyCC. To ensure test-coverage with various other kernel versions GCC must be retained. Finally it is ARCH=x86 again and linux-2.4 kernel remaining *only* to ensure portability towards different toolchains.

# Libc
In principle [musl-libc](https://musl.libc.org) is portable towards many architectures and recent kernel versions with [decent reputation for it's size and standard-compliance](http://www.etalabs.net/compare_libcs.html). And the choice of [standard C-library](https://en.wikipedia.org/wiki/C_standard_library) is limited by the available linux-2.4 kernel and TinyCC toolchain combination already and any libc must be compatible with those. Since bootstrappable.org too had chosen musl-libc-1.1.24 version with an early bootstrapping stage and TinyCC involved in live-bootstrap, some related portability issues were coped with already:

&nbsp;		|musl-1.1.x		|musl-1.2.x	|newlib(3)	|glibc(4)	|
----------------|-----------------------|-------------------------------|---------------|
**TinyCC**	|***STATIC OK(1)***	|INCOMPLETE(2)	|OPTIONAL(3)	|IRRELEVANT	|
GCC4		|OK			|OK		|IRRELEVANT	|IRRELEVANT	|
GCC6		|OK			|OK		|IRRELEVANT	|IRRELEVANT	|

1. None of the [musl-libc]() versions mentions official support for linux-2.4 kernel [system call](https://en.wikipedia.org/wiki/System_call) [application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface) (ABI). musl-libc seems to rely upon [NPTL](https://en.wikipedia.org/wiki/NPTL) support from kernel, hence required [patches were rebased back onto linux-2.4](https://codeberg.org/aggi/linux-tcc/commit/75452534b84677468a6f6032096ad56ebb93024a) for threading support. Patching musl-libc for linux-2.4 syscall ABI required merely some headers removed for unsupported syscalls to prevent runtime ENOSYS errors and preventing userspace compile-time mis-leading header tests against musl-libc. **This patchset cannot be published because [tinyfront gitweb](src.html) is unavailable.**
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
&nbsp;		|x86 real-mode	|x86_32		|x86-64		|aarch32	|aarch64	| riscv-64	|
----------------|---------------|---------------|---------------|---------------|---------------|---------------|
**TinyCC**	|MISSING(1)	|OK(3)		|INCOMPLETE	|INCOMPLETE	|--		|OPEN(4)	|
as86(2)		|OK		|--		|--		|--		|--		|--		|
binutils(5)	|OK		|OK		|OK		|OK		|OK		|OK		|

1. [TinyCC does not support x86 real-mode assembler required for bootcode]() inside bootloader, kernel and tccboot.
2. As an alternative [as86 assembler](https://wiki.osdev.org/AS86) exists which a re-write of real-mode asm from [AT&T GAS syntax](https://tldp.org/HOWTO/Assembly-HOWTO/gas.html) into [Intel syntax](https://en.wikipedia.org/wiki/X86_assembly_language#Syntax) is necessary.
3. Inline assembly with linux-2.4 kernel and musl-libc and [syslinux-3.86 bootloader](https://wiki.syslinux.org) passed.
4. The status of riscv64 assembler with TinyCC was not investigated yet. Notable development activity exists for a long-term perspective.
5. [GNU binutils](https://www.gnu.org/software/binutils/) can be compiled/bootstrapped with TinyCC, which introduces a circular dependency then to support x86 real-mode bootcode because binutils were required **before** being bootstrapped themselves. bootstrappable.org however implemented various loaders and assemblers hence with their approach TinyCC and binutils may be emitted to proceed without a circular dependency.

# Boot Code
Tinyfront system relies upon X86 hardware supporting real-mode BIOS boot. Yet since Intel&reg; began phasing out real-mode boot with their latest [UEFI](https://en.wikipedia.org/wiki/UEFI_CSM#CSM_booting) this poses an unpreceeded risk for ***loss of [backwards compatibility](https://en.wikipedia.org/wiki/Backward_compatibility)*** preventing booting tinyfront system and threatening the **only** complete bootstrapping path to arrive at a bootable kernel that existed and was relied upon for any other system that got cross-compiled from some ARCH=x86 host.[^CSM-emulation]

[^CSM-emulation]: Chainloading a UEFI-shim payload which can emulate real-mode BIOS boot with [https://github.com/FlyGoat/csmwrap](https://github.com/FlyGoat/csmwrap) remains inconclusive if basic hardware initialization for Vesa-graphics, SATA/IDE disks and interoperatbility with Kernel were guaranteed to initialize hardware including APIC, USB on latest Intel&reg;.

Real-mode assembler for booloader, kernel and optional [tccboot](https://bellard.org/tcc/tccboot.html) JiT kernel compilation support binutils assembler introduces a gigantic circular dependency graph into tinyfront system. Currently at least binutils can be bootstrapped with TinyCC easily. AS86 would introduce a far less critical dependency graph and an option to re-integrate some real-mode assembler support. This too could cause a circular dependency, depending on when linux-2.4 booted into was necessary to proceed with bootstrapping, because 16bit real-mode asm bootcode is needed rather early during bootstrapping. To avoid binutils alltogether a re-write of related bootcode parts for AS86 syntax is reasonable to fully detangle from GNU toolchain and autotools. Interestingly, earlier kernel versions (linux-2.2?) implemented their 16bit real-mode asm bootcode parts with AS86 syntax. For earliest stages of bootstrapping it may not be necessary to rewrite bootcode because bootstrappable.org got a system integration to arrive at binutils and/or as86, depending on when a linux-2.4 kernel or tccboot were required and avoiding a circular dependency with these.

System integration issues and circular dependencies involved with firmware-development for [coreboot](https://www.coreboot.org) and [SeaBIOS](https://www.seabios.org/SeaBIOS) relying upon GNU toolchain are not covered and circular dependencies cannot be avoided without [considerations for choice of hardware](#Considerations-for-Choice-of-Hardware).

No other test-vector than i586-tinycc-linux2-musl.iso is investigated further, because no known option exists to avoid circular dependencies and other systems in question indirectly rely upon initial bootstrapping with x86 and cross compilation still.

# Cross Compilation
To produce i586-tinycc-linux2-musl.iso tinyfront system two options exist:

- Either with "full source bootstrapping" spawning the system from the bootstrappable.org dependency chain directly which was verified outside tinyfront project by bootstrappable.org having implemented the preceeding stage to provide TinyCC compiler runtime.
- And cross-compiling from any existing Linux operating system which some [gentoo](https://gentoo.org) driven one was chosen to gradually re-fine the system profile for compliance with acceptance criteria (static-linking, no-c++ etc.) since dependency tracking with gentoo tooling is superb.

&nbsp;				|TinyCC		|GCC	|
--------------------------------|---------------|-------|
Cross-Compiling BUILD!=TARGET	|**BUGS**(1)	|OK(2)	|
Canadian-Cross			|**BUGS**(1)	|OK(2)	|

1. Currently TinyCC support to emit [i586-tinycc-linux2-musl.iso](download.html) tinyfront system was hacked into [gentoo crossdev](https://wiki.gentoo.org/wiki/Crossdev) with some [crossbuild scripting](gitweb/crossbuild) and a forked portage tree (currently unavailable with tinyfront/gitweb). So far a BUILD=HOST=TARGET=x86 crossdev-setup to swap toolchain from GCC towards TinyCC was confirmed. TinyCC itself seems to be affected by [cross-compiliation issues when transitioning beyond different ARCH while cross-compiling]() which was dicussed at tinycc-devel mailing list.
2. Since TinyCC cross-compilation setups revealed bugs, it is possible to bootstrap GNU toolchain with TinyCC still and proceed with gcc thereafter to retain flexibility and test-coverage to transition towards any other TARGET=arm|riscv than ARCH=x86, which is a common approach and the reason why bootstrapping chain with ARCH=x86 must remain stable.

# System Integration Utilities
Since compatibility was prioritized with system integration most system integration tooling is covered by standardization and the system integration and build system tooling themselves must be covered by the complete [portability test-matrix](#Portability-and-Test-Coverage) both bootstrappable and self-hostn with the presence of a complete [bootstrapping chain](#Bootstrapping).

Most system integration and build-system tooling are covered by POSIX:

- [Makefiles](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html)
- [M4 macros](https://en.wikipedia.org/wiki/M4_(computer_language) for GNU Automake/Autoconf
- [Shell script](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)

However, [GNU autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html) and [gentoo portage](https://wiki.gentoo.org/wiki/Portage) relied upon with self-hosting system-integration of all test-vectors currently, dependency of [Perl](https://www.perl.org) and [Python](https://www.python.org) must be maintained for compliance with acceptance criteria too, even when these languages are **not** covered by POSIX standardization. To keep Perl and Python optional implies significant effort to re-write packaging, which is feasible and demonstrated with [Oasis Linux](https://github.com/oasislinux/oasis) for example which avoid autotools and with it Perl completely. And too gentoo tooling chosen to avoid any re-write of packaging may be replaced with an alternative such as [void xbps](https://docs.voidlinux.org/xbps/index.html) which would not depend on Python then. An extension beyond standardization with Perl/autotools and Python/portage is considered less severe than an otherwise urgent re-write build-system and packaging for [userspace](),because:

1. Python can be bootstrapped and remain self-hosting with TinyCC, then too **optional** Gentoo-tooling can be bootstrapped and remain self-hosting for all relevant test-vectors.
2. For GNU autotools a recent perl-5.36.0 version besides the older perl-5.8.6 passed with TinyCC toolchain, the latter required to cover bootstrapping and the former confirmed for cross-compilation for all relevant test-vectors.

With autotools/autoreconf/Perl and portage/Python mainline system-integration tooling is available, both bootstrappable and self-hosting. As a compromise these must remain an **optional extension beyond standardization with POSIX** and it is **not** considered a violation of standards with defined acceptance criteria then.

# Userspace Fork
With bootstrapping arriving at TinyCC compiler, a bootable kernel, and musl-libc patched for linux-2.4 system call ABI everything is prepared for a complete tinyfront userspace system profile:

- Sanitized from C++ and GNU toolchain (g++) build-time dependency fully detangled as optional dependency
- Remaining portable towards all relevant test-vectors with either GCC or TinyCC toolchain
- With full cross-compilation support of the complete profile with crossdev directly instead of [gentoo catalyst]()
- For either linux-2.4 or linux-5 system call ABI remaining flexible with [musl-libc](#Libc)
- static linking
- Including all required development utilities across all relevant test-vectors to remain self-hosting

For compliance with acceptance criteria and extended portability ~500 ebuilds were forked and kept in maintenance. Syncing against available portage tree was re-confirmed up until latest ~testing branch Feb/2025 for keeping 

See [profile.list](download.html) in the download section for an overview of all components retained with tinyfront system.

Forked portage tree: [tinyfront/gitweb](src.html).

Various sources of inspiration are mentioned in the [sources section](src.html).

- libressl
- netbsd-curses
- dvtm
- suckless goodies etc.
- scientific authoring
- multi-media fun

# Bootstrapping and Compilation Instructions
Tinyfront system integration was designed to simplify "full source bootstrapping" of a complete system from scratch to emit a final bootable ISO release fully automated with:

- [live-bootstrap]() scripting for bootstrapping
- and [crossbuild](src.html) scripting for kernel and userspace cross-compilation towards all relevant test-vectors (Unavailable tinyfront.org/gitweb)

Development and testing of individual software updates is possible with available system integration tooling to emit updates inegrated into subsequent production of bootable tinyfront ISO releases.

# Considerations for Choice of Hardware
Since ARCH=x86 remains the major test vector with TinyCC this implies choice of hardware made with it. Sufficient and affordable long term refurbished hardware supply with processing power is available:

- However portability towards linux-2.4 impacts support for USB, SATA, Ethernet, SMP must remain with it. In particular a backport for a commonly available usb-ethernet is required because no standard implementation for ethernet chips exists for dozens of different manufacturers.
- Some Libre Firmware options such as [Coreboot](https://www.coreboot.org) or [u-boot loader](https://www.u-boot.org) should exist even when those would clash with acceptance criteria by introducing circular dependencies into the build-time dependencies for firmware bootstrapping.
- Free/Open SoC designs for FPGA deployment should exist even when those would clash with acceptance criteria by introducing circular dependencies with hardware design and development utilities.
- For ARCH=x86 some interesting i486 SoC deployment onto FPGA was demonstrated already with [ao486 project](https://github.com/MiSTer-devel/ao486_MiSTer), which too got libre firmware support implemented. Depending on vendor chosen for hardware-development some of this is [free/opensource with Lattice-Semi](https://wiki.debian.org/FPGA/Lattice).
- Avoiding any circular dependency with hardware development tooling involved indicates a most severe regression of more than 40years back till [z80](https://en.wikipedia.org/wiki/Zilog_Z80) with [S-100 BUS](https://en.wikipedia.org/wiki/S-100_bus) 16bit systems predating the [original IBM PC](https://en.wikipedia.org/wiki/IBM_Personal_Computer) proprietary system.

For additional cross-compilation test-vectors towards ARCH=arm32/64 the [rock64 device](https://pine64.org/devices/rock64/) from pine64.org project was used with GNU toolchain, linux-5 kernel, and fully Libre u-boot loader firmware available.

Bootstrapping attempts outside X86 PC realm with both hardware development and software covered are leaving traces back until the early days of [Research Unix](https://en.wikipedia.org/wiki/Research_Unix) for example projects maintained until today at [MIT](https://en.wikipedia.org/wiki/MIT) to study ancient [PDP-11](https://en.wikipedia.org/wiki/PDP-11) of nowadays defunct [Digital Equipment Corporation](https://en.wikipedia.org/wiki/Digital_Equipment_Corporation) (DEC) running [xv6 teaching operating system](https://ocw.mit.edu/courses/6-828-operating-system-engineering-fall-2012/pages/study-materials).

# Installation Instructions
With a zero-config approach for a bootable live-system ISO release with read-only squashfs tinyfront system does not need any installation. The ISO image can easily be burned onto CD-ROM or the a hybrid-ISO disk-dumped onto USB flash memory.

# System Configuration
- networking setup
- default iptables
see [rc.tiny]()

