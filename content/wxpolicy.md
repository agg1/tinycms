Modern Intel&reg; CPUs support [NX-bit](https://en.wikipedia.org/wiki/NX_bit#x86) to separate memory areas for storing data and instructions with read-only and executable permissions applied accordingly, to prevent run-time malicious-code injection attemps into main memory. However, for this security feature to have any effect memory access must be restricted and policies applied by kernel, for both [kernel-space and user-space](https://en.wikipedia.org/wiki/User_space_and_kernel_space) code. Several projects seeked to implement and mainline memory-protection policy enforcement with kernel:

- [Grsecurity](https://grsecurity.net) which terminated public access to regularly maintained patches for recent kernel versions
- and [S.A.R.A linux security module](https://sara.smeso.it/en/latest) which was not forward-ported to recent kernel versions for many years

To re-introduce this security feature with recent linux-5 kernel series the [linux security module](https://en.wikipedia.org/wiki/Linux_Security_Module) for [W\^X policy enforcement](https://en.wikipedia.org/wiki/W%5EX) was forked, simplified, and forward ported to linux-5 kernel versions with the name wxprot given:

- [wxprot kernel patch](downloads/0024-wxprot-linux-5.9.patch) is available in the [download section](download.html)
- besides [wxloader](downloads/wxloader) userspace utility which was used to administer policy exception

The wxprot project is not maintained anymore and was deactivated because:

- W\^X policy enforcement makes specific assumptions for user-space program behaviour with mprotect() and related system calls clashing with POSIX
- which either many user-space programs must be re-written for to avoid this problem (in particular script interpreters such as Python and Perl) which is a non-trivial task
- or exceptions must be administered to deactivate policy enforcement for affected user-space components then
- and kernel message syslog was flooded with policy-violation warnings or error messages during regular run-time of affected programs
- in worst case breaking important user-space components

In comparison [ASLR](https://en.wikipedia.org/wiki/ASLR) would not make any such assumptions, remains mostly transparent to user-space, and too can prevent most malicious code injection arbitrary code execution attempts.

With [linux-2.4 tinyfront kernel](docs.html#Kernel) instead [ASLR patch from grsecurity](https://codeberg.org/aggi/linux-tcc/commit/ae733137c6ca29551a2dfdb05c44e7742276ea08) project was applied as a minimum kernel security precaution.
