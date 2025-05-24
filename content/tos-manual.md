This developer manual documents the process of establishing and maintaining a **complete** mostly-GNU/POSIX operating system profile fully supported with TinyCC toolchain for tinyfront operating system (TOS). To accomplish this task a kernel, libc, development-utilities and software component portage-tree were fully forked. For sufficient test coverage and portability several system-deployment variants are kept in maintenance with the a final operating system distribution [i586-tinycc-linux2-musl.iso](download.html) which specific **acceptence criteria** must be complied with.

#Acceptance Criteria
Given common defintions with:
- **full standards compliance** which implies **all** components are covered by standardization
- without an **extension beyond standardization** which may not necessarily *violate* any standard
- if any extension remained an **optional dependency** either build-time or run-time, direct or transitive
- and finally a **standard violation** exists if any extension got introduced as **mandatory dependency**.

In other words if any system cannot be compiled or booted without the presence of non-standard extensions then standards were **violated**, otherwise this might qualify merely as a less intrusive extension beyond standards or fully standards compliant still.

With tinyfront system full standards compliance is not feasible and extensions beyond standardization are not avoidable, but the system **must not violate standards** with given definition by introducing a mandatory extension beyond [POSIX](https://en.wikipedia.org/wiki/POSIX) or [ANSI/ISO C](https://en.wikipedia.org/wiki/ANSI_C) unnecessarily. Tinyfront system fights the battle against the malicious vendor strategy of ["Embrace, Extend, Extinguish "](https://en.wikipedia.org/wiki/Embrace,_extend,_and_extinguish) which almost always non-standardized mandatory extensions were utilized for in the tech industry dominated by hostile actors imposing their anti-competitive strategies onto developers and users.

Due to various interdependent issues involved with the tinyfront operating system (TOS) in detail:
- first all c++ dependencies were sanitized from the dependency graph
- portability towards both linux2 and linux5 system call ABI was re-established with latest software component versions
- static linking support with [~500 software components forked]() was confirmed
- [slibtool]() had to be fully integrated into the build system
- [cross-compilation]() of the complete system profile were verified against various test-vectors
- besides TinyCC of cause too **optional** [GCC](https://gcc.gnu.org/) support was retained for extending test-coverage

By extending [portability](#Portability-and-Test-Coverage) back towards [linux2 system call ABI](#Kernel) and [TinyCC](https://bellard.org/tcc) in software engineering terms:
- [compatibility](https://en.wikipedia.org/wiki/Software_incompatibility) is prioritized over
- [interoperability](https://en.wikipedia.org/wiki/Interoperability) (which often implied unstable non-standard components for latest feature creep)

#Bootstrapping
Strict acceptence criteria for system integration rely upon both hardware **and** software components being documented and fully re-producible from schematics and source-code. Initially tinyfront system refers to software-context specifically down to most basic software components closest to hardware. Criteria for choice of hardware must be discussed separately. Relying on [OpenSource Software]() with permissive licensing is a necessitity but insufficient for full compliance. With [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping) in particular the development tools and the [software toolchain](https://en.wikipedia.org/wiki/Toolchain) which is mainly an assembler, compiler and linker required must comply with acceptance criteria themselves too. The project [bootstrappable.org](https://bootstrappable.org) is dedicated to this and describes in detail how a [GNU toolchain system](https://gnu.org) can be re-established beginning with some tiniest bootloader and assembler and the whole procedure for this being document with sources [live-bootstrap](https://github.com/fosslinux/live-bootstrap). With such a process a complicated denpendency graph of the software supply chains are introduced for build-time and run-time dependencies.

With this a precise definition for "full source bootstrapping" is required and important terminology must not be confused for:
(1) Fully "source-based" workflow including full coverage beginning with a tiniest boot-seed.
(2) Then "reproducibility" of binary artifacts produced from source-code with any toolchain, btw which can be achieved without source-based bootstrapping too, which is no major concern, but certainly a relevant criteria.
(3) Furthermore "circular dependency" graph, that might be introduced with relying upon (binary) development utilities _before_ those could have been bootstrapped reliably themselves. This instead again is high priority to avoid any, initially at least by shrinking the size of dependency graphs of involved components, which is a gradual process to dissect and take down the circular dependency. Because binary artifact "reproducibility" is a less critical concern when circular dependencies vanished, and trust into emitted binary artifacts can be fully derived from "full source bootstrapping".

TOS will converge and fully re-integrate with a complete bootstrapping chain.

system integration path for, well, bootstrapping, with the loaders/kernels/tools
that are needed. While I too intend to maintain a complete distribution that can
be driven by an alternative toolchain that tinycc offers.
Those approaches do not conflict with each other, but strictness of acceptance
criteria varies slightly with either approach.

https://en.wikipedia.org/wiki/Backward_compatibility
For example by a feasible re-write of linux2 bootcode.S things for as86 syntax instead of GNU GAS which would introduce binutils for 16bit real-mode asm still.
TinyCC support is shrinking the size of an otherwise non-optional dependency graph of gcc/binutils alike.

Furthermore relying upon a clean bootstrapping chain implies some important [portability](#Portability-and-Test-Coverage) issues were coped with appropriately.

> A conflicting interest of mine with bootstrappable is some other.
> I rather keep going with TinyCC, hence linux2 kernel (which was worth another
> discussion). Finally this is what i think, a little more effort rather was
> invested into TinyCC for testing and maintenance than GCC that boostrappable/
> GNU/linux are entangled with (or llvm,rust,c++ whatever).
> Nope, it is bootstrappable.org who solved those problems, not me.
> I follow a different approach at a later stage of bootstrapping than them;
> By trying to avoid mandatory gcc and binutils dependencies, etc.
> The principle idea is, to have a complete(!) tcc-linux distribution before
> gcc/binutils were available, with tinycc as system compiler instead,
> which then can spawn a complete GNU toolchain optionally.
> bootstrappable solved the bootstrapping issue towards a gnu/gcc/linux, but
> noone got a complete tcc-linux system including "kernel bootstrapping" ready.
> You can't boot any system without some seed/loader; bootstrappable.org initial
> seed is <256 bytes in size with commented hex/opcodes. They don't pretend to
> providing source, they actually do.

> Nope, it is bootstrappable.org who solved those problems, not me.
> I follow a different approach at a later stage of bootstrapping than them;
> By trying to avoid mandatory gcc and binutils dependencies, etc.
> The principle idea is, to have a complete(!) tcc-linux distribution before
> gcc/binutils were available, with tinycc as system compiler instead,
> which then can spawn a complete GNU toolchain optionally.
> bootstrappable solved the bootstrapping issue towards a gnu/gcc/linux, but
> noone got a complete tcc-linux system including "kernel bootstrapping" ready.

#Portability and Test Coverage
to regularly compile/link/boot linux-2.4 x86
hence i'm glad i retained portability with gcc4|gcc6 too
#Architectures
&nbsp;		|**x86/32**	|x86/64		|aarch32	|aarch64	|riscv64	|
----------------|---------------|---------------|---------------|---------------|---------------|
GCC4		|OK		|OK		|OK		|--		|--		|
GCC6		|OK		|OK		|OK		|OK		|UNKNOWN	|
**TinyCC(*1)**	|**OK**		|INCOMPLETE	|INCOMPLETE	|INCOMPLETE	|OPEN(*3)	|
cproc/qbe(*2)	|--		|PARTIAL(*3)	|--		|--		|--		|

(*1) A complete mostly-POSIX base system profile fully supported with TinyCC establishes a **baseline** for any other OS|ARCH|CC variant (for example bsd|riscv|cproc etc), since i386-tcc partially covers relevant issues for any other such approach such as sanitizing the profile from c++.

Furthermore i keep test-coverage for some other
ARCH|CC|cross-compilation variants with CC=gcc4|tcc ARCH=arm,x86 and crossdev
some of which is not relevant to tinycc-devel, but important to be retained
with the test-setup because i386-tcc alone can't provide full test-coverage yet.

(*2) [Oasis-Linux]() userspace with cproc and kernel/bootloader with gcc/binutils

(*3) Notable development efforts for RISCV64 which is relevant for a long term perspective since Intel&reg; obsoleted their own x86 real-mode support required for both booting tinyfront.org TOS with and most important this was the basis for any bootstrapping to begin with. Furthermore currently no other than ARCH=x86 got a somewhat clean and verified bootstrapping dependency chain implemented with [live-bootstrap]() and a cross-compilation directly or inderectly necessary from any HOST=x86 towards another TARGET that was not fully covered by [bootstrappable.org]() yet.
Missing suitable kernel with TinyCC

#Kernel
&nbsp;		|linux2.4	|linux5		|fiwix	|minix/hurd(*4)	|
----------------|---------------|---------------|-------|---------------|
**TinyCC**	|**OK(*1)**	|**FAILED(*2)**	|OK(*3)	|--		|
GCC4		|OK/all-arch	|OK/all-arch	|OK	|--		|
GCC6		|OK/all-arch	|OK/all-arch	|OK	|--		|

(*1)

(*2)

(*3)

any architecture with decent hardware supply
sufficient processing power
sufficent hardware support

fiwix kernel which is written in 50000 lines of code only would be more elegant
however this one hasn't got hardware support for USB/ethernet etc.
bootstrappable
hurd, minix

linux5

linux2
> stuff regressed against linux2 syscall abi, which was years of efforts of mine
> to keep software portable towards any linux2-compat and modern linux5 with
> either gcc or tcc for various ARCH in parallel with full cross-compilation
> support.

> Currently both gcc47 and tcc-latest report errors with incompatible changes
> introduced by nptl/o1 scheduler patchset applied to kernel to satisfy the needs
> of musl-libc for POSIX compliance. It is alot of work remaining.

> Otherwise, as I explained, i try to keep tinycc synced to latest HEAD, and so
> far i got linux-2.4.37.11 ready with it, including usb, ioapic, highmem support,
> and somewhat unstable SMP even. Hence there's a chance to hook into linux-2.4
> into bootstrappable system integration path a little earlier, with a powerful
> kernel and rather many software components that I succeeded with supporting with
> tinycc.

#Libc
&nbsp;		|musl-1.1.x		|musl-1.2.x	|
----------------|-----------------------|----------------
**TinyCC**	|**STATIC OK(*1)**	|INCOMPLETE	|
GCC4		|OK			|OK		|
GCC6		|OK			|OK		|

i got header-review for musl-libc and linux-2.4 on todo still; there's a few potential clashes
u64, __u64, uint64... definitions for wchar_t, off_t, loff_t
it's a miracle this thing compiled and booted without segfault
tinycc got a few headers of it's own besides

> Furthermore i cannot support dynamic-linking with tcc yet, because
> musl-libc libc.so dynamic loader crashes when compiled/linked with tcc
> (bootstrappable.org got some patches for musl-libc for support with tcc
> statically linked);
> Hence i have to re-bundle what's currently maintained for tcc without
> ebuilds/portage/crossdev (python needs dynamic linking and fails with tcc),
> statically linked.
> Once the distribution is ready and available as a stable(!) baseline i'll
> summarize ISSUES, so these can be re-produced and verified against it easily
> without duplicate efforts.

> Indeed, musl-libc needs POSIX threads support from kernel which mainline
> linux-2.4 does not provide. Some patchset from redhat9 exists, which would need
> a rebase onto 2.4.37.11 version, and seems to introduce another can of
> regressions. Linux kernel version history, nptl/scheduler and tcc-support
> deserved yet another discussion.

> With regards to musl-libc, there's not much to share other than what
> bootstrappable.org (live-bootstrap) offered. To my knowledge they're using
> musl-libc atop a linux-2.x ABI provided by fiwix. I haven't had time yet to
> throw my i486-tcc-musl.squashfs at linux-2.4.37.11-tcc kernel, nonetheless
> musl-1.1 and musl-1.2 both compiled just fine with tinycc for x86 static-linking
> . And https://github.com/agg1/linux-tcc contains a few patches for linux-2.4
> headers already to satisfy some latest userspace software (compile-time).

> Almost forgot: If I remember correctly, i think it was musl-libc supported with
> tinycc that you had shown interest in. live-bootstrap project got the relevant
> patches for tinycc-support with musl-libc-1.1.24 and fiwix kernel they utilized,
> and I assumed you had been aware of this fact. I merely wrapped the libc patches
> into an ebuild for "simple"(!)/reproducible dependency tracking. Depending on if
> you want linux2 (or fiwix) syscall ABI support, which isn't too difficult to
> accomplish. Although it's not documented officially by musl-libc project, it's a
> few headers only to remove from musl-libc build for linux2 compat.
> I've been told by various people already, bothering with linux2.4 and musl-libc
> was not relevant, another reason i've not git-pushed anything other than the
> kernel fork yet, well then of cause linux2 is "useless", if noone got a capable
> libc for it driven by tinycc, to spawn those ~500 most recent up-to-date
> software components confirmed with tinycc including development utilities atop.

a first spot i'll be hit, is 32bit timestamps; jfs got that unsigned at least
and there's some 64bit offset magic at block-layer (-DLARGEFILE_OFFSET something)
hence, i did a few backups of my usb-sticks as a precaution, just in case anything went wrong anywhere

tcc support for x86/linux2/musl-1.1 is done already

#Linking
&nbsp;		|dynamic|static		|
----------------|-------|---------------|
**TinyCC**	|FAILED	|OK		|
GCC		|OK	|IRRELEVANT	|

> Hi Yao Zi,
>
> thanks for the hint.
> For verification of musl-1.2.2 compilation/linking with i386-tcc i've applied
> the patch https://www.openwall.com/lists/musl/2024/09/15/1
> which didn't yield a working libc.so dynamic loader yet.
>
> I've noticed another iregularity, that is:
> - when compiled/linked with latest i386-tcc
>   # file libc.so
>   libc.so: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), static-pie linked, not stripped
> - which doesn't correspond to gcc-4.7/binutils emitted shared object
>   # file libc.so
>   /usr/lib/libc.so: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), dynamically linked, stripped
>
> It is unknown why i386-tcc emits an elf static-pie; which when executed faults:
>   # ./libc.so
>   Illegal instruction
>
> The 01-libc_so-snippet.log snippet is attached which shows the linking command
> issued with i386-tcc to emit libc.so
> (the full ebuild.log file is 2.8MiB in size hence not attached)
>
> Since static linking is fully supported with anything else that is needed for
> further testing, the dynamic loader problem doesn't block my work currently.
> Hence it isn't the most urgent concern. Reminder, it would only be python that
> needed dynamic linking, and there was various other problems with python/libffi
> when using i386-tcc compiler/linker. Hence for i486-tcc-linux-musl.iso release
> dynamic linking is not considered for immediate support yet.

#Assembler
&nbsp;		|x86 real-mode	|x86_32		|x86-64		|aarch32	|aarch64	| riscv-64	|
----------------|---------------|---------------|---------------|---------------|---------------|---------------|
**TinyCC**	|MISSING	|INCOMPLETE	|INCOMPLETE	| INCOMPLETE	|--		|--		|
as86		|OK		|--		|--		|--		|--		|--		|
binutils	|OK		|OK		|OK		|OK		|OK		|OK		|

> Although as86 would introduce a far less critical dependency
> graph, it too could cause a circular dependency against tcc, depending on when
> linux-2.4 booted into was necessary to proceed with bootstrapping, because 16bit
> real-mode asm bootcode is needed rather early during bootstrapping.
>
> It may not be necessary to rewrite linux/tccboot code for hex2/hex0 because
> bootstrappable.org got a system integration to arrive at binutils and/or as86.
> It would just be a little easier if a capable linux-2.4 kernel could be booted
> earlier without relying on gcc and/or binutils.
> So far i could only abandon gcc mandatory dependency for kernel and a complete
> user-space of ~500 builds.

> the mission, to just make things work with TinyCC, that is missing x86 16bit
> real-mode asm still, hence the idea with as86, or ACK, or whatever
> bootstrappable did. Dis-assemblers and reverse-engineering aren't my field of
> expertise though, not yet.

> With regards to bootloaders, you wouldn't have a kernel and various utilities to
> process 16bit real-mode assembly. tinycc itself wouldn't support 16bit real-mode
> asm processing, yet tinycc would NOT be available during bootstrapping at the
> stage 16bit x86 asm had to be processed already.Too bootstrappable.org considers
> "kernel bootstrapping" an unresolved issue, although they are far ahead with
> compliance with strict acceptance criteria than i would need to be by merely
> trying to avoid gcc/binutils early during bootstrapping, for technical reasons
> not licensing ones, to maintain a complete i486-tcc-linux-musl.iso distribution.

> A few notes should be summarized:
> - .code16 sections and 16bit real-mode support are mostly abandoned with tcc
> - release-tag release_0_9_25 retained 16bit real-mode asm support iirc
> - release_0_9_26 already had deactived it with #ifdefs
> - finally https://repo.or.cz/tinycc.git/commitdiff/55bd08c5 removed it
>
> With consequences to critical system components such as:
> - x86 kernel and loaders including tccboot itself rely upon 16bit real-mode asm
> - real-mode asm may be crucial to "kernel bootstrapping" that
>    bootstrappable.org considers unresolved
> - interestingly, earlier kernel versions (2.2 iirc) implemented their 16bit
>   real-mode asm bootcode parts with another syntax than GNU gas one
> - binutils-as introduce a gigantic dependency graph
>
> Testing release_0_9_25 confirmed various assembly components of linux-2.4.37
> containing .code16 could not be processed with tcc assembler, therefore
> reverting commit 55bd08c5 onto latest mob branch for testing was skipped.
>
> i386-tcc preprocessor and assembler from latest HEAD choke .code16 sections
> still, but cannot completely process it either to emit real-mode bootcode.
> Latest x86_64-tcc assembler instead errors immediately on .code16 token spotted.
>
> 1)
>   $CC -nostdinc -nostdlib -D__BIG_KERNEL__ -I../linux/include \
>     bootsect.S -o bootsect.o
>   ### bootsect.S:108: error: register expected
>   ### -> ldsw    %fs:(%bx), %si          # %ds:%si is source
> 2)
>   $CC -E -P -I../linux/include -D__ASSEMBLY__ -D__KERNEL__ -D__BIG_KERNEL__ \
>   setup.S -o setup.s
>   ### preprocessing ok
>   $CC -I../linux/include -D__ASSEMBLY__ -D__KERNEL__ -D__BIG_KERNEL__ \
>     setup.s -o setup.o
>   ### setup.s:20: error: constant expected
>   ### -> .word   kernel_version
> 3)
>   $CC -I../linux/include -D__ASSEMBLY__ -D__KERNEL__ -D__BIG_KERNEL__ \
>   trampoline.S -o trampoline.o
>   ### trampoline.S:61: error: unknown opcode 'ljmpl'
>   ### -> ljmpl   $__KERNEL_CS, $0x00100000
> ### https://stackoverflow.com/questions/39323061/gnu-as-compilation-error-on-instruction-far-jmp-0x8-0x80000
> ### i386-tcc is not aware of ljmpl , and ljmp implies different adressing and sizes (16bit/32bit)
>
> I do not see a realistic chance to salvage 16bit real-mode support with tinycc
> myself; and FYI bootstrappable.org chose a different approach to implement x86
> bootcode with their hex0 languages and loaders.

> Currently, i could merely confirm binutils can be compiled/bootstrapped with tcc
> for this. Too linux-2.4 compiles and boots supported with tcc, and the binutils
> for 16bit asm. The linux-tcc repository is available at:
>
> https://github.com/agg1/linux-tcc [1]

#Cross-Compilation
&nbsp;|TinyCC|GCC|
------|------|---|
Cross-Compiling beyond different ARCH|**BUGS**|OK
Canadian-Cross|**BUGS**|OK|

i386-tcc produced mis-compiled binaries when residing on some arm/arm64 host
it's tricky, because i spawned an aarch32 userspace atop an aarch64 kernel/uboot which got a 32bit binary compat layer (different to x86)
although i ensured i386-tcc (which is an ARM EABI binary) picked up correct headers for target x86/linux2 _only_
it's miss-compiling x86 binaries; native x86 host needed with it
so, either when compiling tcc itself it got confused over the aarch64/aarch32 situation (it's configured for --cpu=arm userspace explicitely though)
or it's the foreign ARCH transition itself; can't test it on some full aarch64 currently, because compilation times are too excessive
https://lists.gnu.org/archive/html/tinycc-devel/2025-05/msg00000.html
<SeaDough> ^ [Tinycc-devel] mis-compiled binaries with i386-tcc for TARGET=x86 on BUI

[crossdev]()

#System Integration Development Utilities
Since compatibility was prioritized with system integration of TOS most system integration are covered by standardization the system integration and build system tooling itself is covered by the complete [portability test-matrix](#Portability-and-Test-Coverage) and the presence of a complete [bootstrapping chain]() was confirmed by the feasibility of spawning TOS from [live-bootstrap project]().

bootstrappable and next self-hosting against _all_ involved test vectors

1) python can be bootstrapped and remain self-hosting with i386-tcc
and 2) optional gentoo-tooling can remain self-hosting with i386-tcc
and 3) publication would not be blocked by an urgent re-write of packaging of
~500builds maintained with portage currently, because python/portage are
unblocked for extensive testing against i386-tcc now.

A recent perl-5.36.0 version besides the older perl-5.8.6 passed with i386-tcc
already too; the latter supported with tcc and bootstrapping, the former
supported with tcc _and_ cross-compilation beyond different ARCH; with
autotools/autoreconf and python/ portage the major system-integration tooling is
available, both for bootstrapping and self-hosting.

#Portage Fork for Support of a Complete mostly-POSIX base sytem profile
Fully supporting tcc with crossdev/portage was a hell of a hackjob.

> > > Nice! I did not know whether the published stuff was sufficient, [...]
> > > without your ~500 packages but there you know what to do
> >
> > It's not my packages. The ebuilds are sourced from freely available portage tree
> > and were last synced to latest ~testing branch Feb/2025. I merely applied a few
> > patches here and there for linux2 syscall abi compat and tinycc static linking.
> > And since i cannot afford to host a project site to distribute any binary ISO
> > release there's nothing else to be done currently.

> FYI:
> - and a complete set of ~500 packages that i can support with tcc already
>   (removed all direct and transitive c++ dependencies, among other patches)
>
> With plans to emit a complete i486-tcc-linux-musl.iso distribution to work with,
> I've already spotted other minor regressions. I'll try to fix and/or report
> those as best as i can, and will announce on the mailing list once the tcc-linux
> distribution is available.


