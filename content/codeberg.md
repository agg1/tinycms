All repositories were migrated from github to [codeberg.org](https://codeberg.org/aggi) since year 2024.

Tinyfront Operating System (TOS) supported with TinyCC toolchain cross-compilation and static linking for a **complete** POSIX base system profile containing all required development utilities and sanitized from C++ to keep that fully optional:

- [TOS linux-2.4 kernel fork](https://codeberg.org/aggi/linux-tcc)
- [TOS musl-libc fork](docs.html#Libc) for portability towards linux-2.4 syscall ABI [unavailable tinyfront.org/gitweb](src.html#gitweb.md)
- [TOS portage-tree fork](docs.html#Userspace-Fork) with ~500 components [unavailable tinyfront.org/gitweb](src.html#gitweb.md)

[TinyCMS](https://codeberg.org/aggi/tinycms) web content management system built upon [mkws.sh design](https://mkws.sh)

Interleaved LFSR polymorphic scrambler matrix high-speed symmetric crypto stack:

- [dropbear-2024.85-scrash.patch](downloads/dropbear-2024.85-scrash.patch) for high-speed scrambling of ssh transport
- [SCRAM](https://codeberg.org/aggi/linux-tcc/commit/ede4ba1022e571cca61f35cf639b48b5d972c141) final 8x4Bytes (8x32Bit) implementation portable towards both linux-2.4 and linux-5.x loopdev which needs a legacy util-linux that supported losetup -e <encryption>
- [SCRAM88](https://codeberg.org/aggi/scram88) initial 8x8Bytes (8x64Bit) design and implementation against linux dm-crypt API for LUKS and cryptsetup that enables easy benchmarking
