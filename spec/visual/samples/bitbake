inherit linux-kernel-base kernel-module-split

COMPATIBLE_HOST = ".*-linux"

KERNEL_PACKAGE_NAME ??= "kernel"
KERNEL_DEPLOYSUBDIR ??= "${@ "" if (d.getVar("KERNEL_PACKAGE_NAME") == "kernel") else d.getVar("KERNEL_PACKAGE_NAME") }"

PROVIDES += "${@ "virtual/kernel" if (d.getVar("KERNEL_PACKAGE_NAME") == "kernel") else "" }"
DEPENDS += "virtual/${TARGET_PREFIX}binutils virtual/${TARGET_PREFIX}gcc kmod-native bc-native bison-native"
DEPENDS += "${@bb.utils.contains("INITRAMFS_FSTYPES", "cpio.lzo", "lzop-native", "", d)}"
DEPENDS += "${@bb.utils.contains("INITRAMFS_FSTYPES", "cpio.lz4", "lz4-native", "", d)}"
PACKAGE_WRITE_DEPS += "depmodwrapper-cross"

do_deploy[depends] += "depmodwrapper-cross:do_populate_sysroot gzip-native:do_populate_sysroot"
do_clean[depends] += "make-mod-scripts:do_clean"

CVE_PRODUCT ?= "linux_kernel"

S = "${STAGING_KERNEL_DIR}"
B = "${WORKDIR}/build"
KBUILD_OUTPUT = "${B}"
OE_TERMINAL_EXPORTS += "KBUILD_OUTPUT"

# we include gcc above, we dont need virtual/libc
INHIBIT_DEFAULT_DEPS = "1"

KERNEL_IMAGETYPE ?= "zImage"
INITRAMFS_IMAGE ?= ""
INITRAMFS_IMAGE_NAME ?= "${@['${INITRAMFS_IMAGE}-${MACHINE}', ''][d.getVar('INITRAMFS_IMAGE') == '']}"
INITRAMFS_TASK ?= ""
INITRAMFS_IMAGE_BUNDLE ?= ""

# KERNEL_VERSION is extracted from source code. It is evaluated as
# None for the first parsing, since the code has not been fetched.
# After the code is fetched, it will be evaluated as real version
# number and cause kernel to be rebuilt. To avoid this, make
# KERNEL_VERSION_NAME and KERNEL_VERSION_PKG_NAME depend on
# LINUX_VERSION which is a constant.
KERNEL_VERSION_NAME = "${@d.getVar('KERNEL_VERSION') or ""}"
KERNEL_VERSION_NAME[vardepvalue] = "${LINUX_VERSION}"
KERNEL_VERSION_PKG_NAME = "${@legitimize_package_name(d.getVar('KERNEL_VERSION'))}"
KERNEL_VERSION_PKG_NAME[vardepvalue] = "${LINUX_VERSION}"

python __anonymous () {
    pn = d.getVar("PN")
    kpn = d.getVar("KERNEL_PACKAGE_NAME")

    # XXX Remove this after bug 11905 is resolved
    #  FILES_${KERNEL_PACKAGE_NAME}-dev doesn't expand correctly
    if kpn == pn:
        bb.warn("Some packages (E.g. *-dev) might be missing due to "
                "bug 11905 (variable KERNEL_PACKAGE_NAME == PN)")

    # The default kernel recipe builds in a shared location defined by
    # bitbake/distro confs: STAGING_KERNEL_DIR and STAGING_KERNEL_BUILDDIR.
    # Set these variables to directories under ${WORKDIR} in alternate
    # kernel recipes (I.e. where KERNEL_PACKAGE_NAME != kernel) so that they
    # may build in parallel with the default kernel without clobbering.
    if kpn != "kernel":
        workdir = d.getVar("WORKDIR")
        sourceDir = os.path.join(workdir, 'kernel-source')
        artifactsDir = os.path.join(workdir, 'kernel-build-artifacts')
        d.setVar("STAGING_KERNEL_DIR", sourceDir)
        d.setVar("STAGING_KERNEL_BUILDDIR", artifactsDir)

    # Merge KERNEL_IMAGETYPE and KERNEL_ALT_IMAGETYPE into KERNEL_IMAGETYPES
    type = d.getVar('KERNEL_IMAGETYPE') or ""
    alttype = d.getVar('KERNEL_ALT_IMAGETYPE') or ""
    types = d.getVar('KERNEL_IMAGETYPES') or ""
    if type not in types.split():
        types = (type + ' ' + types).strip()
    if alttype not in types.split():
        types = (alttype + ' ' + types).strip()
    d.setVar('KERNEL_IMAGETYPES', types)

    # KERNEL_IMAGETYPES may contain a mixture of image types supported directly
    # by the kernel build system and types which are created by post-processing
    # the output of the kernel build system (e.g. compressing vmlinux ->
    # vmlinux.gz in kernel_do_compile()).
    # KERNEL_IMAGETYPE_FOR_MAKE should contain only image types supported
    # directly by the kernel build system.
    if not d.getVar('KERNEL_IMAGETYPE_FOR_MAKE'):
        typeformake = set()
        for type in types.split():
            if type == 'vmlinux.gz':
                type = 'vmlinux'
            typeformake.add(type)

        d.setVar('KERNEL_IMAGETYPE_FOR_MAKE', ' '.join(sorted(typeformake)))

    kname = d.getVar('KERNEL_PACKAGE_NAME') or "kernel"
    imagedest = d.getVar('KERNEL_IMAGEDEST')

    for type in types.split():
        typelower = type.lower()
        d.appendVar('PACKAGES', ' %s-image-%s' % (kname, typelower))
        d.setVar('FILES_' + kname + '-image-' + typelower, '/' + imagedest + '/' + type + '-${KERNEL_VERSION_NAME}' + ' /' + imagedest + '/' + type)
        d.appendVar('RDEPENDS_%s-image' % kname, ' %s-image-%s' % (kname, typelower))
        d.setVar('PKG_%s-image-%s' % (kname,typelower), '%s-image-%s-${KERNEL_VERSION_PKG_NAME}' % (kname, typelower))
        d.setVar('ALLOW_EMPTY_%s-image-%s' % (kname, typelower), '1')
        d.setVar('pkg_postinst_%s-image-%s' % (kname,typelower), """set +e
if [ -n "$D" ]; then
    ln -sf %s-${KERNEL_VERSION} $D/${KERNEL_IMAGEDEST}/%s > /dev/null 2>&1
else
    ln -sf %s-${KERNEL_VERSION} ${KERNEL_IMAGEDEST}/%s > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Filesystem on ${KERNEL_IMAGEDEST}/ doesn't support symlinks, falling back to copied image (%s)."
        install -m 0644 ${KERNEL_IMAGEDEST}/%s-${KERNEL_VERSION} ${KERNEL_IMAGEDEST}/%s
    fi
fi
set -e
""" % (type, type, type, type, type, type, type))
        d.setVar('pkg_postrm_%s-image-%s' % (kname,typelower), """set +e
if [ -f "${KERNEL_IMAGEDEST}/%s" -o -L "${KERNEL_IMAGEDEST}/%s" ]; then
    rm -f ${KERNEL_IMAGEDEST}/%s  > /dev/null 2>&1
fi
set -e
""" % (type, type, type))


    image = d.getVar('INITRAMFS_IMAGE')
    # If the INTIRAMFS_IMAGE is set but the INITRAMFS_IMAGE_BUNDLE is set to 0,
    # the do_bundle_initramfs does nothing, but the INITRAMFS_IMAGE is built
    # standalone for use by wic and other tools.
    if image:
        d.appendVarFlag('do_bundle_initramfs', 'depends', ' ${INITRAMFS_IMAGE}:do_image_complete')

    # NOTE: setting INITRAMFS_TASK is for backward compatibility
    #       The preferred method is to set INITRAMFS_IMAGE, because
    #       this INITRAMFS_TASK has circular dependency problems
    #       if the initramfs requires kernel modules
    image_task = d.getVar('INITRAMFS_TASK')
    if image_task:
        d.appendVarFlag('do_configure', 'depends', ' ${INITRAMFS_TASK}')
}

# Here we pull in all various kernel image types which we support.
#
# In case you're wondering why kernel.bbclass inherits the other image
# types instead of the other way around, the reason for that is to
# maintain compatibility with various currently existing meta-layers.
# By pulling in the various kernel image types here, we retain the
# original behavior of kernel.bbclass, so no meta-layers should get
# broken.
#
# KERNEL_CLASSES by default pulls in kernel-uimage.bbclass, since this
# used to be the default behavior when only uImage was supported. This
# variable can be appended by users who implement support for new kernel
# image types.

KERNEL_CLASSES ?= " kernel-uimage "
inherit ${KERNEL_CLASSES}

# Old style kernels may set ${S} = ${WORKDIR}/git for example
# We need to move these over to STAGING_KERNEL_DIR. We can't just
# create the symlink in advance as the git fetcher can't cope with
# the symlink.
do_unpack[cleandirs] += " ${S} ${STAGING_KERNEL_DIR} ${B} ${STAGING_KERNEL_BUILDDIR}"
do_clean[cleandirs] += " ${S} ${STAGING_KERNEL_DIR} ${B} ${STAGING_KERNEL_BUILDDIR}"
python do_symlink_kernsrc () {
    s = d.getVar("S")
    if s[-1] == '/':
        # drop trailing slash, so that os.symlink(kernsrc, s) doesn't use s as directory name and fail
        s=s[:-1]
    kernsrc = d.getVar("STAGING_KERNEL_DIR")
    if s != kernsrc:
        bb.utils.mkdirhier(kernsrc)
        bb.utils.remove(kernsrc, recurse=True)
        if d.getVar("EXTERNALSRC"):
            # With EXTERNALSRC S will not be wiped so we can symlink to it
            os.symlink(s, kernsrc)
        else:
            import shutil
            shutil.move(s, kernsrc)
            os.symlink(kernsrc, s)
}
# do_patch is normally ordered before do_configure, but
# externalsrc.bbclass deletes do_patch, breaking the dependency of
# do_configure on do_symlink_kernsrc.
addtask symlink_kernsrc before do_patch do_configure after do_unpack

inherit kernel-arch deploy

PACKAGES_DYNAMIC += "^${KERNEL_PACKAGE_NAME}-module-.*"
PACKAGES_DYNAMIC += "^${KERNEL_PACKAGE_NAME}-image-.*"
PACKAGES_DYNAMIC += "^${KERNEL_PACKAGE_NAME}-firmware-.*"

export OS = "${TARGET_OS}"
export CROSS_COMPILE = "${TARGET_PREFIX}"
export KBUILD_BUILD_VERSION = "1"
export KBUILD_BUILD_USER ?= "oe-user"
export KBUILD_BUILD_HOST ?= "oe-host"

KERNEL_RELEASE ?= "${KERNEL_VERSION}"

# The directory where built kernel lies in the kernel tree
KERNEL_OUTPUT_DIR ?= "arch/${ARCH}/boot"
KERNEL_IMAGEDEST ?= "boot"

#
# configuration
#
export CMDLINE_CONSOLE = "console=${@d.getVar("KERNEL_CONSOLE") or "ttyS0"}"

KERNEL_VERSION = "${@get_kernelversion_headers('${B}')}"

KERNEL_LOCALVERSION ?= ""

# kernels are generally machine specific
PACKAGE_ARCH = "${MACHINE_ARCH}"

# U-Boot support
UBOOT_ENTRYPOINT ?= "20008000"
UBOOT_LOADADDRESS ?= "${UBOOT_ENTRYPOINT}"

# Some Linux kernel configurations need additional parameters on the command line
KERNEL_EXTRA_ARGS ?= ""

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""
EXTRA_OEMAKE += " HOSTCXX="${BUILD_CXX} ${BUILD_CXXFLAGS} ${BUILD_LDFLAGS}""

KERNEL_ALT_IMAGETYPE ??= ""

copy_initramfs() {
	echo "Copying initramfs into ./usr ..."
	# In case the directory is not created yet from the first pass compile:
	mkdir -p ${B}/usr
	# Find and use the first initramfs image archive type we find
	rm -f ${B}/usr/${INITRAMFS_IMAGE_NAME}.cpio
	for img in cpio cpio.gz cpio.lz4 cpio.lzo cpio.lzma cpio.xz; do
		if [ -e "${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE_NAME}.$img" ]; then
			cp ${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE_NAME}.$img ${B}/usr/.
			case $img in
			*gz)
				echo "gzip decompressing image"
				gunzip -f ${B}/usr/${INITRAMFS_IMAGE_NAME}.$img
				break
				;;
			*lz4)
				echo "lz4 decompressing image"
				lz4 -df ${B}/usr/${INITRAMFS_IMAGE_NAME}.$img ${B}/usr/${INITRAMFS_IMAGE_NAME}.cpio
				break
				;;
			*lzo)
				echo "lzo decompressing image"
				lzop -df ${B}/usr/${INITRAMFS_IMAGE_NAME}.$img
				break
				;;
			*lzma)
				echo "lzma decompressing image"
				lzma -df ${B}/usr/${INITRAMFS_IMAGE_NAME}.$img
				break
				;;
			*xz)
				echo "xz decompressing image"
				xz -df ${B}/usr/${INITRAMFS_IMAGE_NAME}.$img
				break
				;;
			esac
			break
		fi
	done
	# Verify that the above loop found a initramfs, fail otherwise
	[ -f ${B}/usr/${INITRAMFS_IMAGE_NAME}.cpio ] && echo "Finished copy of initramfs into ./usr" || die "Could not find any ${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE_NAME}.cpio{.gz|.lz4|.lzo|.lzma|.xz) for bundling; INITRAMFS_IMAGE_NAME might be wrong."
}

do_bundle_initramfs () {
	if [ ! -z "${INITRAMFS_IMAGE}" -a x"${INITRAMFS_IMAGE_BUNDLE}" = x1 ]; then
		echo "Creating a kernel image with a bundled initramfs..."
		copy_initramfs
		# Backing up kernel image relies on its type(regular file or symbolic link)
		tmp_path=""
		for imageType in ${KERNEL_IMAGETYPE_FOR_MAKE} ; do
			if [ -h ${KERNEL_OUTPUT_DIR}/$imageType ] ; then
				linkpath=`readlink -n ${KERNEL_OUTPUT_DIR}/$imageType`
				realpath=`readlink -fn ${KERNEL_OUTPUT_DIR}/$imageType`
				mv -f $realpath $realpath.bak
				tmp_path=$tmp_path" "$imageType"#"$linkpath"#"$realpath
			elif [ -f ${KERNEL_OUTPUT_DIR}/$imageType ]; then
				mv -f ${KERNEL_OUTPUT_DIR}/$imageType ${KERNEL_OUTPUT_DIR}/$imageType.bak
				tmp_path=$tmp_path" "$imageType"##"
			fi
		done
		use_alternate_initrd=CONFIG_INITRAMFS_SOURCE=${B}/usr/${INITRAMFS_IMAGE_NAME}.cpio
		kernel_do_compile
		# Restoring kernel image
		for tp in $tmp_path ; do
			imageType=`echo $tp|cut -d "#" -f 1`
			linkpath=`echo $tp|cut -d "#" -f 2`
			realpath=`echo $tp|cut -d "#" -f 3`
			if [ -n "$realpath" ]; then
				mv -f $realpath $realpath.initramfs
				mv -f $realpath.bak $realpath
				ln -sf $linkpath.initramfs ${B}/${KERNEL_OUTPUT_DIR}/$imageType.initramfs
			else
				mv -f ${KERNEL_OUTPUT_DIR}/$imageType ${KERNEL_OUTPUT_DIR}/$imageType.initramfs
				mv -f ${KERNEL_OUTPUT_DIR}/$imageType.bak ${KERNEL_OUTPUT_DIR}/$imageType
			fi
		done
	fi
}
do_bundle_initramfs[dirs] = "${B}"

python do_devshell_prepend () {
    os.environ["LDFLAGS"] = ''
}

addtask bundle_initramfs after do_install before do_deploy

get_cc_option () {
		# Check if KERNEL_CC supports the option "file-prefix-map".
		# This option allows us to build images with __FILE__ values that do not
		# contain the host build path.
		if ${KERNEL_CC} -Q --help=joined | grep -q "\-ffile-prefix-map=<old=new>"; then
			echo "-ffile-prefix-map=${S}=/kernel-source/"
		fi
}

kernel_do_compile() {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
	if [ "${BUILD_REPRODUCIBLE_BINARIES}" = "1" ]; then
		# kernel sources do not use do_unpack, so SOURCE_DATE_EPOCH may not
		# be set....
		if [ "${SOURCE_DATE_EPOCH}" = "" -o "${SOURCE_DATE_EPOCH}" = "0" ]; then
			# The source directory is not necessarily a git repository, so we
			# specify the git-dir to ensure that git does not query a
			# repository in any parent directory.
			SOURCE_DATE_EPOCH=`git --git-dir="${S}/.git" log -1 --pretty=%ct 2>/dev/null || echo "${REPRODUCIBLE_TIMESTAMP_ROOTFS}"`
		fi

		ts=`LC_ALL=C date -d @$SOURCE_DATE_EPOCH`
		export KBUILD_BUILD_TIMESTAMP="$ts"
		export KCONFIG_NOTIMESTAMP=1
		bbnote "KBUILD_BUILD_TIMESTAMP: $ts"
	fi
	# The $use_alternate_initrd is only set from
	# do_bundle_initramfs() This variable is specifically for the
	# case where we are making a second pass at the kernel
	# compilation and we want to force the kernel build to use a
	# different initramfs image.  The way to do that in the kernel
	# is to specify:
	# make ...args... CONFIG_INITRAMFS_SOURCE=some_other_initramfs.cpio
	if [ "$use_alternate_initrd" = "" ] && [ "${INITRAMFS_TASK}" != "" ] ; then
		# The old style way of copying an prebuilt image and building it
		# is turned on via INTIRAMFS_TASK != ""
		copy_initramfs
		use_alternate_initrd=CONFIG_INITRAMFS_SOURCE=${B}/usr/${INITRAMFS_IMAGE_NAME}.cpio
	fi
	cc_extra=$(get_cc_option)
	for typeformake in ${KERNEL_IMAGETYPE_FOR_MAKE} ; do
		oe_runmake ${typeformake} CC="${KERNEL_CC} $cc_extra " LD="${KERNEL_LD}" ${KERNEL_EXTRA_ARGS} $use_alternate_initrd
	done
	# vmlinux.gz is not built by kernel
	if (echo "${KERNEL_IMAGETYPES}" | grep -wq "vmlinux\.gz"); then
		mkdir -p "${KERNEL_OUTPUT_DIR}"
		gzip -9cn < ${B}/vmlinux > "${KERNEL_OUTPUT_DIR}/vmlinux.gz"
	fi
}

do_compile_kernelmodules() {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
	if [ "${BUILD_REPRODUCIBLE_BINARIES}" = "1" ]; then
		# kernel sources do not use do_unpack, so SOURCE_DATE_EPOCH may not
		# be set....
		if [ "${SOURCE_DATE_EPOCH}" = "" -o "${SOURCE_DATE_EPOCH}" = "0" ]; then
			# The source directory is not necessarily a git repository, so we
			# specify the git-dir to ensure that git does not query a
			# repository in any parent directory.
			SOURCE_DATE_EPOCH=`git --git-dir="${S}/.git" log -1 --pretty=%ct 2>/dev/null || echo "${REPRODUCIBLE_TIMESTAMP_ROOTFS}"`
		fi

		ts=`LC_ALL=C date -d @$SOURCE_DATE_EPOCH`
		export KBUILD_BUILD_TIMESTAMP="$ts"
		export KCONFIG_NOTIMESTAMP=1
		bbnote "KBUILD_BUILD_TIMESTAMP: $ts"
	fi
	if (grep -q -i -e '^CONFIG_MODULES=y$' ${B}/.config); then
		cc_extra=$(get_cc_option)
		oe_runmake -C ${B} ${PARALLEL_MAKE} modules CC="${KERNEL_CC} $cc_extra " LD="${KERNEL_LD}" ${KERNEL_EXTRA_ARGS}

		# Module.symvers gets updated during the 
		# building of the kernel modules. We need to
		# update this in the shared workdir since some
		# external kernel modules has a dependency on
		# other kernel modules and will look at this
		# file to do symbol lookups
		cp ${B}/Module.symvers ${STAGING_KERNEL_BUILDDIR}/
		# 5.10+ kernels have module.lds that we need to copy for external module builds
		if [ -e "${B}/scripts/module.lds" ]; then
			install -Dm 0644 ${B}/scripts/module.lds ${STAGING_KERNEL_BUILDDIR}/scripts/module.lds
		fi
	else
		bbnote "no modules to compile"
	fi
}
addtask compile_kernelmodules after do_compile before do_strip

kernel_do_install() {
	#
	# First install the modules
	#
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
	if (grep -q -i -e '^CONFIG_MODULES=y$' .config); then
		oe_runmake DEPMOD=echo MODLIB=${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION} INSTALL_FW_PATH=${D}${nonarch_base_libdir}/firmware modules_install
		rm "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/build"
		rm "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/source"
		# If the kernel/ directory is empty remove it to prevent QA issues
		rmdir --ignore-fail-on-non-empty "${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel"
	else
		bbnote "no modules to install"
	fi

	#
	# Install various kernel output (zImage, map file, config, module support files)
	#
	install -d ${D}/${KERNEL_IMAGEDEST}
	install -d ${D}/boot

	#
	# When including an initramfs bundle inside a FIT image, the fitImage is created after the install task
	# by do_assemble_fitimage_initramfs.
	# This happens after the generation of the initramfs bundle (done by do_bundle_initramfs).
	# So, at the level of the install task we should not try to install the fitImage. fitImage is still not
	# generated yet.
	# After the generation of the fitImage, the deploy task copies the fitImage from the build directory to
	# the deploy folder.
	#

	for imageType in ${KERNEL_IMAGETYPES} ; do
		if [ $imageType != "fitImage" ] || [ "${INITRAMFS_IMAGE_BUNDLE}" != "1" ] ; then
			install -m 0644 ${KERNEL_OUTPUT_DIR}/$imageType ${D}/${KERNEL_IMAGEDEST}/$imageType-${KERNEL_VERSION}
		fi
	done

	install -m 0644 System.map ${D}/boot/System.map-${KERNEL_VERSION}
	install -m 0644 .config ${D}/boot/config-${KERNEL_VERSION}
	install -m 0644 vmlinux ${D}/boot/vmlinux-${KERNEL_VERSION}
	[ -e Module.symvers ] && install -m 0644 Module.symvers ${D}/boot/Module.symvers-${KERNEL_VERSION}
	install -d ${D}${sysconfdir}/modules-load.d
	install -d ${D}${sysconfdir}/modprobe.d
}

# Must be ran no earlier than after do_kernel_checkout or else Makefile won't be in ${S}/Makefile
do_kernel_version_sanity_check() {
	if [ "x${KERNEL_VERSION_SANITY_SKIP}" = "x1" ]; then
		exit 0
	fi

	# The Makefile determines the kernel version shown at runtime
	# Don't use KERNEL_VERSION because the headers it grabs the version from aren't generated until do_compile
	VERSION=$(grep "^VERSION =" ${S}/Makefile | sed s/.*=\ *//)
	PATCHLEVEL=$(grep "^PATCHLEVEL =" ${S}/Makefile | sed s/.*=\ *//)
	SUBLEVEL=$(grep "^SUBLEVEL =" ${S}/Makefile | sed s/.*=\ *//)
	EXTRAVERSION=$(grep "^EXTRAVERSION =" ${S}/Makefile | sed s/.*=\ *//)

	# Build a string for regex and a plain version string
	reg="^${VERSION}\.${PATCHLEVEL}"
	vers="${VERSION}.${PATCHLEVEL}"
	if [ -n "${SUBLEVEL}" ]; then
		# Ignoring a SUBLEVEL of zero is fine
		if [ "${SUBLEVEL}" = "0" ]; then
			reg="${reg}(\.${SUBLEVEL})?"
		else
			reg="${reg}\.${SUBLEVEL}"
			vers="${vers}.${SUBLEVEL}"
		fi
	fi
	vers="${vers}${EXTRAVERSION}"
	reg="${reg}${EXTRAVERSION}"

	if [ -z `echo ${PV} | grep -E "${reg}"` ]; then
		bbfatal "Package Version (${PV}) does not match of kernel being built (${vers}). Please update the PV variable to match the kernel source or set KERNEL_VERSION_SANITY_SKIP=\"1\" in your recipe."
	fi
	exit 0
}

addtask shared_workdir after do_compile before do_compile_kernelmodules
addtask shared_workdir_setscene

do_shared_workdir_setscene () {
	exit 1
}

emit_depmod_pkgdata() {
	# Stash data for depmod
	install -d ${PKGDESTWORK}/${KERNEL_PACKAGE_NAME}-depmod/
	echo "${KERNEL_VERSION}" > ${PKGDESTWORK}/${KERNEL_PACKAGE_NAME}-depmod/${KERNEL_PACKAGE_NAME}-abiversion
	cp ${B}/System.map ${PKGDESTWORK}/${KERNEL_PACKAGE_NAME}-depmod/System.map-${KERNEL_VERSION}
}

PACKAGEFUNCS += "emit_depmod_pkgdata"

do_shared_workdir[cleandirs] += " ${STAGING_KERNEL_BUILDDIR}"
do_shared_workdir () {
	cd ${B}

	kerneldir=${STAGING_KERNEL_BUILDDIR}
	install -d $kerneldir

	#
	# Store the kernel version in sysroots for module-base.bbclass
	#

	echo "${KERNEL_VERSION}" > $kerneldir/${KERNEL_PACKAGE_NAME}-abiversion

	# Copy files required for module builds
	cp System.map $kerneldir/System.map-${KERNEL_VERSION}
	[ -e Module.symvers ] && cp Module.symvers $kerneldir/
	cp .config $kerneldir/
	mkdir -p $kerneldir/include/config
	cp include/config/kernel.release $kerneldir/include/config/kernel.release
	if [ -e certs/signing_key.x509 ]; then
		# The signing_key.* files are stored in the certs/ dir in
		# newer Linux kernels
		mkdir -p $kerneldir/certs
		cp certs/signing_key.* $kerneldir/certs/
	elif [ -e signing_key.priv ]; then
		cp signing_key.* $kerneldir/
	fi

	# We can also copy over all the generated files and avoid special cases
	# like version.h, but we've opted to keep this small until file creep starts
	# to happen
	if [ -e include/linux/version.h ]; then
		mkdir -p $kerneldir/include/linux
		cp include/linux/version.h $kerneldir/include/linux/version.h
	fi

	# As of Linux kernel version 3.0.1, the clean target removes
	# arch/powerpc/lib/crtsavres.o which is present in
	# KBUILD_LDFLAGS_MODULE, making it required to build external modules.
	if [ ${ARCH} = "powerpc" ]; then
		if [ -e arch/powerpc/lib/crtsavres.o ]; then
			mkdir -p $kerneldir/arch/powerpc/lib/
			cp arch/powerpc/lib/crtsavres.o $kerneldir/arch/powerpc/lib/crtsavres.o
		fi
	fi

	if [ -d include/generated ]; then
		mkdir -p $kerneldir/include/generated/
		cp -fR include/generated/* $kerneldir/include/generated/
	fi

	if [ -d arch/${ARCH}/include/generated ]; then
		mkdir -p $kerneldir/arch/${ARCH}/include/generated/
		cp -fR arch/${ARCH}/include/generated/* $kerneldir/arch/${ARCH}/include/generated/
	fi

	if (grep -q -i -e '^CONFIG_UNWINDER_ORC=y$' $kerneldir/.config); then
		# With CONFIG_UNWINDER_ORC (the default in 4.14), objtool is required for
		# out-of-tree modules to be able to generate object files.
		if [ -x tools/objtool/objtool ]; then
			mkdir -p ${kerneldir}/tools/objtool
			cp tools/objtool/objtool ${kerneldir}/tools/objtool/
		fi
	fi
}

# We don't need to stage anything, not the modules/firmware since those would clash with linux-firmware
sysroot_stage_all () {
	:
}

KERNEL_CONFIG_COMMAND ?= "oe_runmake_call -C ${S} CC="${KERNEL_CC}" LD="${KERNEL_LD}" O=${B} olddefconfig || oe_runmake -C ${S} O=${B} CC="${KERNEL_CC}" LD="${KERNEL_LD}" oldnoconfig"

python check_oldest_kernel() {
    oldest_kernel = d.getVar('OLDEST_KERNEL')
    kernel_version = d.getVar('KERNEL_VERSION')
    tclibc = d.getVar('TCLIBC')
    if tclibc == 'glibc':
        kernel_version = kernel_version.split('-', 1)[0]
        if oldest_kernel and kernel_version:
            if bb.utils.vercmp_string(kernel_version, oldest_kernel) < 0:
                bb.warn('%s: OLDEST_KERNEL is "%s" but the version of the kernel you are building is "%s" - therefore %s as built may not be compatible with this kernel. Either set OLDEST_KERNEL to an older version, or build a newer kernel.' % (d.getVar('PN'), oldest_kernel, kernel_version, tclibc))
}

check_oldest_kernel[vardepsexclude] += "OLDEST_KERNEL KERNEL_VERSION"
do_configure[prefuncs] += "check_oldest_kernel"

kernel_do_configure() {
	# fixes extra + in /lib/modules/2.6.37+
	# $ scripts/setlocalversion . => +
	# $ make kernelversion => 2.6.37
	# $ make kernelrelease => 2.6.37+
	touch ${B}/.scmversion ${S}/.scmversion

	if [ "${S}" != "${B}" ] && [ -f "${S}/.config" ] && [ ! -f "${B}/.config" ]; then
		mv "${S}/.config" "${B}/.config"
	fi

	# Copy defconfig to .config if .config does not exist. This allows
	# recipes to manage the .config themselves in do_configure_prepend().
	if [ -f "${WORKDIR}/defconfig" ] && [ ! -f "${B}/.config" ]; then
		cp "${WORKDIR}/defconfig" "${B}/.config"
	fi

	${KERNEL_CONFIG_COMMAND}
}

do_savedefconfig() {
	bbplain "Saving defconfig to:\n${B}/defconfig"
	oe_runmake -C ${B} savedefconfig
}
do_savedefconfig[nostamp] = "1"
addtask savedefconfig after do_configure

inherit cml1

KCONFIG_CONFIG_COMMAND_append = " LD='${KERNEL_LD}' HOSTLDFLAGS='${BUILD_LDFLAGS}'"

EXPORT_FUNCTIONS do_compile do_install do_configure

# kernel-base becomes kernel-${KERNEL_VERSION}
# kernel-image becomes kernel-image-${KERNEL_VERSION}
PACKAGES = "${KERNEL_PACKAGE_NAME} ${KERNEL_PACKAGE_NAME}-base ${KERNEL_PACKAGE_NAME}-vmlinux ${KERNEL_PACKAGE_NAME}-image ${KERNEL_PACKAGE_NAME}-dev ${KERNEL_PACKAGE_NAME}-modules"
FILES_${PN} = ""
FILES_${KERNEL_PACKAGE_NAME}-base = "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.order ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo"
FILES_${KERNEL_PACKAGE_NAME}-image = ""
FILES_${KERNEL_PACKAGE_NAME}-dev = "/boot/System.map* /boot/Module.symvers* /boot/config* ${KERNEL_SRC_PATH} ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/build"
FILES_${KERNEL_PACKAGE_NAME}-vmlinux = "/boot/vmlinux-${KERNEL_VERSION_NAME}"
FILES_${KERNEL_PACKAGE_NAME}-modules = ""
RDEPENDS_${KERNEL_PACKAGE_NAME} = "${KERNEL_PACKAGE_NAME}-base"
# Allow machines to override this dependency if kernel image files are
# not wanted in images as standard
RDEPENDS_${KERNEL_PACKAGE_NAME}-base ?= "${KERNEL_PACKAGE_NAME}-image"
PKG_${KERNEL_PACKAGE_NAME}-image = "${KERNEL_PACKAGE_NAME}-image-${@legitimize_package_name(d.getVar('KERNEL_VERSION'))}"
RDEPENDS_${KERNEL_PACKAGE_NAME}-image += "${@oe.utils.conditional('KERNEL_IMAGETYPE', 'vmlinux', '${KERNEL_PACKAGE_NAME}-vmlinux', '', d)}"
PKG_${KERNEL_PACKAGE_NAME}-base = "${KERNEL_PACKAGE_NAME}-${@legitimize_package_name(d.getVar('KERNEL_VERSION'))}"
RPROVIDES_${KERNEL_PACKAGE_NAME}-base += "${KERNEL_PACKAGE_NAME}-${KERNEL_VERSION}"
ALLOW_EMPTY_${KERNEL_PACKAGE_NAME} = "1"
ALLOW_EMPTY_${KERNEL_PACKAGE_NAME}-base = "1"
ALLOW_EMPTY_${KERNEL_PACKAGE_NAME}-image = "1"
ALLOW_EMPTY_${KERNEL_PACKAGE_NAME}-modules = "1"
DESCRIPTION_${KERNEL_PACKAGE_NAME}-modules = "Kernel modules meta package"

pkg_postinst_${KERNEL_PACKAGE_NAME}-base () {
	if [ ! -e "$D/lib/modules/${KERNEL_VERSION}" ]; then
		mkdir -p $D/lib/modules/${KERNEL_VERSION}
	fi
	if [ -n "$D" ]; then
		depmodwrapper -a -b $D ${KERNEL_VERSION}
	else
		depmod -a ${KERNEL_VERSION}
	fi
}

PACKAGESPLITFUNCS_prepend = "split_kernel_packages "

python split_kernel_packages () {
    do_split_packages(d, root='${nonarch_base_libdir}/firmware', file_regex=r'^(.*)\.(bin|fw|cis|csp|dsp)$', output_pattern='${KERNEL_PACKAGE_NAME}-firmware-%s', description='Firmware for %s', recursive=True, extra_depends='')
}

# Many scripts want to look in arch/$arch/boot for the bootable
# image. This poses a problem for vmlinux and vmlinuz based
# booting. This task arranges to have vmlinux and vmlinuz appear
# in the normalized directory location.
do_kernel_link_images() {
	if [ ! -d "${B}/arch/${ARCH}/boot" ]; then
		mkdir ${B}/arch/${ARCH}/boot
	fi
	cd ${B}/arch/${ARCH}/boot
	ln -sf ../../../vmlinux
	if [ -f ../../../vmlinuz ]; then
		ln -sf ../../../vmlinuz
	fi
	if [ -f ../../../vmlinuz.bin ]; then
		ln -sf ../../../vmlinuz.bin
	fi
	if [ -f ../../../vmlinux.64 ]; then
		ln -sf ../../../vmlinux.64
	fi
}
addtask kernel_link_images after do_compile before do_strip

do_strip() {
	if [ -n "${KERNEL_IMAGE_STRIP_EXTRA_SECTIONS}" ]; then
		if ! (echo "${KERNEL_IMAGETYPES}" | grep -wq "vmlinux"); then
			bbwarn "image type(s) will not be stripped (not supported): ${KERNEL_IMAGETYPES}"
			return
		fi

		cd ${B}
		headers=`"$CROSS_COMPILE"readelf -S ${KERNEL_OUTPUT_DIR}/vmlinux | \
			  grep "^ \{1,\}\[[0-9 ]\{1,\}\] [^ ]" | \
			  sed "s/^ \{1,\}\[[0-9 ]\{1,\}\] //" | \
			  gawk '{print $1}'`

		for str in ${KERNEL_IMAGE_STRIP_EXTRA_SECTIONS}; do {
			if ! (echo "$headers" | grep -q "^$str$"); then
				bbwarn "Section not found: $str";
			fi

			"$CROSS_COMPILE"strip -s -R $str ${KERNEL_OUTPUT_DIR}/vmlinux
		}; done

		bbnote "KERNEL_IMAGE_STRIP_EXTRA_SECTIONS is set, stripping sections:" \
			"${KERNEL_IMAGE_STRIP_EXTRA_SECTIONS}"
	fi;
}
do_strip[dirs] = "${B}"

addtask strip before do_sizecheck after do_kernel_link_images

# Support checking the kernel size since some kernels need to reside in partitions
# with a fixed length or there is a limit in transferring the kernel to memory.
# If more than one image type is enabled, warn on any that don't fit but only fail
# if none fit.
do_sizecheck() {
	if [ ! -z "${KERNEL_IMAGE_MAXSIZE}" ]; then
		invalid=`echo ${KERNEL_IMAGE_MAXSIZE} | sed 's/[0-9]//g'`
		if [ -n "$invalid" ]; then
			die "Invalid KERNEL_IMAGE_MAXSIZE: ${KERNEL_IMAGE_MAXSIZE}, should be an integer (The unit is Kbytes)"
		fi
		at_least_one_fits=
		for imageType in ${KERNEL_IMAGETYPES} ; do
			size=`du -ks ${B}/${KERNEL_OUTPUT_DIR}/$imageType | awk '{print $1}'`
			if [ $size -ge ${KERNEL_IMAGE_MAXSIZE} ]; then
				bbwarn "This kernel $imageType (size=$size(K) > ${KERNEL_IMAGE_MAXSIZE}(K)) is too big for your device."
			else
				at_least_one_fits=y
			fi
		done
		if [ -z "$at_least_one_fits" ]; then
			die "All kernel images are too big for your device. Please reduce the size of the kernel by making more of it modular."
		fi
	fi
}
do_sizecheck[dirs] = "${B}"

addtask sizecheck before do_install after do_strip

inherit kernel-artifact-names

kernel_do_deploy() {
	deployDir="${DEPLOYDIR}"
	if [ -n "${KERNEL_DEPLOYSUBDIR}" ]; then
		deployDir="${DEPLOYDIR}/${KERNEL_DEPLOYSUBDIR}"
		mkdir "$deployDir"
	fi

	for imageType in ${KERNEL_IMAGETYPES} ; do
		baseName=$imageType-${KERNEL_IMAGE_NAME}
		install -m 0644 ${KERNEL_OUTPUT_DIR}/$imageType $deployDir/$baseName.bin
		ln -sf $baseName.bin $deployDir/$imageType-${KERNEL_IMAGE_LINK_NAME}.bin
		ln -sf $baseName.bin $deployDir/$imageType
	done

	if [ ${MODULE_TARBALL_DEPLOY} = "1" ] && (grep -q -i -e '^CONFIG_MODULES=y$' .config); then
		mkdir -p ${D}${root_prefix}/lib
		if [ -n "${SOURCE_DATE_EPOCH}" ]; then
			TAR_ARGS="--sort=name --clamp-mtime --mtime=@${SOURCE_DATE_EPOCH}"
		else
			TAR_ARGS=""
		fi
		TAR_ARGS="$TAR_ARGS --owner=0 --group=0"
		tar $TAR_ARGS -cv -C ${D}${root_prefix} lib | gzip -9n > $deployDir/modules-${MODULE_TARBALL_NAME}.tgz

		ln -sf modules-${MODULE_TARBALL_NAME}.tgz $deployDir/modules-${MODULE_TARBALL_LINK_NAME}.tgz
	fi

	if [ ! -z "${INITRAMFS_IMAGE}" -a x"${INITRAMFS_IMAGE_BUNDLE}" = x1 ]; then
		for imageType in ${KERNEL_IMAGETYPE_FOR_MAKE} ; do
			if [ "$imageType" = "fitImage" ] ; then
				continue
			fi
			initramfsBaseName=$imageType-${INITRAMFS_NAME}
			install -m 0644 ${KERNEL_OUTPUT_DIR}/$imageType.initramfs $deployDir/$initramfsBaseName.bin
			ln -sf $initramfsBaseName.bin $deployDir/$imageType-${INITRAMFS_LINK_NAME}.bin
		done
	fi
}

# We deploy to filenames that include PKGV and PKGR, read the saved data to
# ensure we get the right values for both
do_deploy[prefuncs] += "read_subpackage_metadata"

addtask deploy after do_populate_sysroot do_packagedata

EXPORT_FUNCTIONS do_deploy

# Add using Device Tree support
inherit kernel-devicetree
