# nOS 
An attempt to make a CLI operating system

version notation: x.y.z (x=major_release ; y=minor_features ; z=patch)

Steps to making it:
(_each step should be its own commit, or a tag (if it is more complex and achieves a milestone)_)
(_The Engineering Methodology is Incremental_)

1. Make a dockerfile to setup cross-compile build environment
2. PoC bootable loop program with a message
3. Create makefile that builds the PoC into image (tag: 0.0.0)
4. From the Bootloader, load the kernel into memory and jump there
5. Bootloader transitions to protected mode before jumping to kernel
6. Change kernel from assembly to C program (tag: 0.1.0)

`docker build -t nos-buildenv .`

`docker run --rm -it -v $(pwd):/root/env nos-buildenv`
or
`docker run --cpus="15" -m 10g --rm -v $(pwd):/root/env -w /root/env nos-buildenv make`

`qemu-system-x86_64 -drive format=raw,file=build/nos.img -display curses`
To exit qemu: ALT-2 then type `quit`

### Instruction for the Makefile
1. build kernel
  1. assemble kernel_start.asm
  2. compile kernel.cpp
  3. link them
2. assemble bootloader
3. concatenate bootloader with kernel and truncate the result