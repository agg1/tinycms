With Linux kernel many filesystems are supported including [NILFS2](https://nilfs.sourceforge.io/en/about_nilfs.html) developed by Nippon Telegraph and Telephone Cyber Space Laboratories which:

- follows a different log-structured design in principle
- implements copy-on-write
- supports 64bit timestamps
- calculates and stores CRC-hashsums for all data and metadata segments
- naturally applies wear-leveling to prevent write-amplification to flash memory

This filesystem had proven very robust and did not report a single filesystem error even when cold-resetting test systems often.
However, nilfs2-utils did not expose a fsck-utility for verification of segment CRC, which was easily implemented as:

- [valseg utility](downloads/nilfs-utils-nocleaner_valseg.patch)

Which is available in the [download section](download.html). Any mounted nilfs2 filesystem can be verified with the command:

	$ valseg -a <block-device>
	### To report all segment whose CRC mismatched due to a hardware fault as protocol log to console.
	### Verbose option will dump all mis-matched AND too matching segment CRC as a protocol log to console.

Sadly nilfs2 is not available with [linux-2.4 tinyfront kernel](doc.html#Kernel) and cannot be back-ported. As a consequence no filesystem exists with linux-2.4 that supported 64-bit timestamps. [IBM JFS2](https://en.wikipedia.org/wiki/JFS_%28file_system%29) available with linux-2.4  at least stores timestamps as 32bit unsigned value to prolong until year 2106 instead of [year2038](downloads/year2038-list.txt) as [ext2 filesystem](https://en.wikipedia.org/wiki/Ext2) and most other would with a 32bit POSIX system already.[^year2038-list]

[^year2038-list]: [https://github.com/y2038/y2038-list](https://github.com/y2038/y2038-list)