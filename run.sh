#!/bin/bash
# run.sh - Launch NexOS in QEMU

make
qemu-system-i386 -cdrom nexos.iso -m 128M -serial stdio