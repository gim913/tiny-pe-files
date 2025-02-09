Tiny PE files
=============

This repo contains asm files (and hopefully will contain executables) illustrating some 64-bit PE peculiarities.
Although it will not try to squash MZ and PE headers one onto another, like such attempts have shown, as that is not the goal.

All files were tested on Win11 (23H2 Build 22631.4751).

| dir | description | size |
| -- | -- | -- |
| `1.simple` | this one is based on [@ayaka14732/TinyPE-on-Win10](https://github.com/ayaka14732/TinyPE-on-Win10), with MS stub thrown out and message made much smaller. | 544b |
| `2.drop-dds` | data directories that are not needed are removed | 432b |
| `3.coll-dd` | collapses import data directory entry onto section name (this is all fine meme goes here) | 4168b |
| `4.strings` | move all necessary strings into mz header | 368b |
