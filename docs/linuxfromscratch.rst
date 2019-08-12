BUILD AN LFS SYSTEM

OVERVIEW

The LFS system will be built by using an already installed Linux
distribution (such as Debian, Fedora). This existing Linux system (the
host) will be used as a starting point to provide necessary
programs,including a compiler, linker, and shell, to build the new
system

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/how.html

PRE-REQUISITE:

Separate partition in linux is required. This is to ensure that existing
host don’t have any impact due to this Linux creation process

$ mkfs -v -t ext4 </partition>

REQUIREMENTS CHECK

Required software packages for the Host to build LFS are listed

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter02/hostreqs.html

SETTING UP LFS VARIABLE

$ export LFS=</yourpartition_name>

Mount new partition:

$ mkdir -pv $LFS

$ mount -v -t ext4 </dev/partitionA> $LFS

Create sources directory in your partition where you have to place your
packages only for compiling and building.

Once it is completed. At the end, we can remove the packages and
generated files inside souces folder.

$ mkdir -v $LFS/sources

BUILD PROCESS:

Place all the sources and patches in *<your_partition_name>*\ sources.
Do not put sources in /*<partition_name>/*\ tools.

For each package , extract using tar and change directory to extracted
package and give instructions specified

BUILDING LFS IN STAGES:

Toolchain Build – Pass 1 and Pass 2: Overview

To build Packages as tools you need tools/compilation packages. Ex: If
you need to build a compiler , you need a compiler.

IMPORTANT NOTES:

1. Install everypackages / toolchains in the same order. If you have
missed some packages in toolchain building. And if you are into later
stages of your toolchain build. There can be problem with the missing
package.

2. Test suites usually will be present in installation process. Test
suite is to ensure that everything installed is correct or not. For ex,
if you face test failures when running make check command in Glibc tool
chain build, you have to correct the error at that point of time. There
is no point in going beyond, if you have some test failures.

3. Some tests may randomly fail but cross check once. Usually, if there
is a failure, it will affect the test cases in huge numbers. If there is
one or two failures, probably you don’t have any error while building.
But cross check your logs with prebuilt logs given.

4. Proper logs can be found in the below path for the packages you are
trying to build in orderwise.

Cross check first with the built logs, which they given.

5. Always delete the package once the build is completed in sources
folder.

For ex, if you have extracted and compiled Binutils.tar.gz for toolchain
Pass. Same package have to be installed but with a different
configuration in successive levels.

Binutils has to be compiled in – Pass 1 of toolchain, Pass 2 of
toolchain , Packages build.

So, delete the /*sources*/binutils i.e remove the compiled folder
present in sources folder in your $LFS partition.

5. SBU refers to build time . This can be referred for high end
processors and for some packages like Glibc , will require patience to
build . If SBU is higher, build time will be increased.

TOOLCHAIN BUILD – PASS 1

Binutils-2.32 – Pass 1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/binutils-pass1.html

$ mkdir -v build

$ cd build

$ ../configure –prefix=/tools \\

--with-sysroot=$LFS \\

--with-lib-path=/tools/lib \\

--target=$LFS_TGT \\

--disable-nls \\

--disable-werror

The above command will run the config file present in Binutils package.

$ make

make command will compile the binutils

*case $(uname -m) in*

* x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;*

*esac*

ln -sv command create symbolic links for your respective packages.

$ make install

make install will install and place the required files to the required
locations for your linux.

BUILD REMAING packages of TOOL CHAINS by following the LFS book.

GCC-8.2.0 – Pass 1 -

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-pass1.html

Linux-4.20.12 API Headers -

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/linux-headers.html

Glibc-2.29 -

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/glibc.html

Binutils-2.32 – Pass 2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/binutils-pass2.html

GCC-8.2.0 – Pass 2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-pass2.html

Tcl-8.6.9 -

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/tcl.html

Expect – 5.45.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/expect.html

DejaGNU-1.6.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/dejagnu.html

M4-1.4.18

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/m4.html

Ncurses-6.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/ncurses.html

Bash-5.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/bash.html

Bison-3.3.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/bison.html

Bzip2-1.0.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/bzip2.html

Coreutils-8.30

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/coreutils.html

Diffutils-3.7

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/diffutils.html

File-5.36

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/file.html

Findutils-4.6.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/findutils.html

Gawk-4.2.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gawk.html

Gettext-0.19.8.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gettext.html

Grep-3.3

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/grep.html

Gzip-1.10

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gzip.html

Make-4.2.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/make.html

Patch-2.7.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/patch.html

Perl-5.28.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/perl.html

Python-3.7.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/Python.html

Sed-4.7

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/sed.html

Tar-1.31

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/tar.html

Texinfo-6.5

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/texinfo.html

Util-linux-2.33.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/util-linux.html

Xz-5.2.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/xz.html

Change to root user no longer as user lfs

$ chown -R root:root $LFS/tools

BUILDING LFS – PACKAGES BUILDING

PREPARING VIRTUAL KERNEL FILE SYSTEMS

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/kernfs.html

Pre-requisites/configurations before starting Packages Build Procedure.

ENTERING CHROOT

*$ chroot "$LFS" /tools/bin/env -i \\*

* HOME=/root \\*

* TERM="$TERM" \\*

* PS1='(lfs chroot) \\u:\w\$ ' \\*

* PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \\*

* /tools/bin/bash --login +h*

Note: Ensure that $LFS variable is set to your partition_name before
executing the above command

CREATING DIRECTORIES:

Create some structure in LFS file system

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/creatingdirs.html

Create essential symlinks and files in LFS

$ ln -sv bash /*bin*/sh

Remaining symlinks and files has to be created as per below link

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/createfiles.html

Linux-4.20.12 API Headers

Remember API Headers are different from actual Kernel Package.

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/linux-headers.html

Man-pages-4.16

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/man-pages.html

Glibc-2.29

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/glibc.html

ADJUSTING TOOLCHAIN:

Now C libraries have created , we need to adjust the /tools directory or
in layman terms, we need to adjust toolchain created previously to make
it suitable for later packages to install properly.

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/adjusting.html

Zlib-1.2.11

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/zlib.html

File-5.36

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/file.html

Readline-8.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/readline.html

M4-1.4.18

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/m4.html

Bc-1.07.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/bc.html

Binutils-2.32

Please dont get confused with tool chain packages which you installed
already. These will be your linux packages. Please delete the directory
if it exists in your compilation folder i.e /*sources/binutils* before
starting out the installation.

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/binutils.html

GMP-6.1.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gmp.html

MPFR-4.0.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/mpfr.html

MPC-1.1.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/mpc.html

Shadow-4.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/shadow.html

GCC-8.2.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gcc.html

Bzip2-1.0.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/bzip2.html

Pkg-config-0.29.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/pkg-config.html

Ncurses-6.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/ncurses.html

Attr-2.4.48

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/attr.html

Acl-2.2.53

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/acl.html

Libcap-2.26

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/libcap.html

Sed-4.7

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/sed.html

Psmisc-23.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/psmisc.html

Iana-Etc-2.30

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/iana-etc.html

Bison-3.3.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/bison.html

Flex-2.6.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/flex.html

Grep-3.3

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/grep.html

Bash-5.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/bash.html

Libtool-2.4.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/libtool.html

GDBM-1.18.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gdbm.html

Gperf-3.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gperf.html

Expat-2.2.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/expat.html

Inetuils-1.9.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/inetutils.html

Perl-5.28.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/perl.html

XML::Parser-2.44

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/xml-parser.html

Intltool-0.51.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/intltool.html

Autoconf-2.69

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/autoconf.html

Automake-1.16.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/automake.html

Xz-5.2.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/xz.html

Kmod-26

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/kmod.html

Gettext-0.19.8.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gettext.html

Libelf from Elfutils-0.176

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/libelf.html

Libffi-3.2.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/libffi.html

OpenSSL-1.1.1a

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/openssl.html

Python-3.7.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/Python.html

Ninja-0.49.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/ninja.html

Meson-0.49.2

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/meson.html

Coreutils-8.30

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/coreutils.html

Check-0.12.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/check.html

Diffutils-3.7

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/diffutils.html

Gawk-4.2.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gawk.html

Findutils-4.6.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/findutils.html

Groff-1.22.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/groff.html

GRUB-2.02

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/grub.html

Less-530

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/less.html

Gzip-1.10

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gzip.html

Iproute2-4.20.0

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/iproute2.html

Kbd-2.0.4

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/kbd.html

Libpipeline-1.5.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/libpipeline.html

Make-4.2.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/make.html

Patch-2.7.6

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/patch.html

Man-DB-2.8.5

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/man-db.html

Tar-1.31

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/tar.html

Texinfo-6.5

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/texinfo.html

Vim-8.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/vim.html

Systemd240

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/systemd.html

D-Bus-1.12.12

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/dbus.html

Procps-ng-3.3.15

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/procps-ng.html

Util-linux-2.33.1

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/util-linux.html

E2fsprogs-1.44.5

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/e2fsprogs.html

CLEANUP

Now several packages have integrated to your linux. So, remove the
unnecessary files as below

$ rm -rf /tmp\*

LOGOUT and LOGIN again to CHROOT environment.

*$ logout*

*$\ chroot "$LFS" /usr/bin/env -i \\*

* HOME=/root TERM="$TERM" \\*

* PS1='(lfs chroot) \\u:\w\$ ' \\*

* PATH=/bin:/usr/bin:/sbin:/usr/sbin \\*

* /bin/bash –login*

*$\ rm -f /usr/lib/lib{bfd,opcodes}.a*

*$\ rm -f /usr/lib/libbz2.a*

*$\ rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a*

*$\ rm -f /usr/lib/libltdl.a*

*$\ rm -f /usr/lib/libfl.a*

*$\ rm -f /usr/lib/libz.a*

*$\ find /usr/lib /usr/libexec -name \\*.la -delete*

**SYSTEM CONFIGURATION FOR MINIMAL LINUX**

*After cleaning up, you need to configure your linux for system related
configurations like static IP set, clock, console in chroot environment
which you already on.*

*Follow, LFS book in system configuration section*

MAKE MINIMAL LINUX BOOTABLE

/etc/fstab file is responsible for your boot level configurations inside
linux.

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/fstab.html

Linux-4.20.12

The last package you need to configure for your lfs is kernel. This is
because some of the packages which are all installed previously, might
be needed to compile the kernel package.

http://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/kernel.html


