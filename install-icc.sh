#!/bin/sh

# Install Intel Parallel Studio on Travis CI
# https://github.com/nemequ/icc-travis
#
# Originally written for Squash <https://github.com/quixdb/squash> by
# Evan Nemerson.  For documentation, bug reports, support requests,
# etc. please use <https://github.com/nemequ/icc-travis>.
#
# To the extent possible under law, the author(s) of this script have
# waived all copyright and related or neighboring rights to this work.
# See <https://creativecommons.org/publicdomain/zero/1.0/> for
# details.

# Tools - Not very useful in non-interactive mode.
COMPONENTS_VTUNE="intel-vtune-amplifier-xe-2016-cli__x86_64;intel-vtune-amplifier-xe-2016-common__noarch;intel-vtune-amplifier-xe-2016-cli-common__noarch;intel-vtune-amplifier-xe-2016-collector-64linux__x86_64;intel-vtune-amplifier-xe-2016-sep__noarch;intel-vtune-amplifier-xe-2016-gui-common__noarch;intel-vtune-amplifier-xe-2016-gui__x86_64;intel-vtune-amplifier-xe-2016-common-pset__noarch"
COMPONENTS_INSPECTOR="intel-inspector-xe-2016-cli__x86_64;intel-inspector-xe-2016-cli-common__noarch;intel-inspector-xe-2016-gui-common__noarch;intel-inspector-xe-2016-gui__x86_64;intel-inspector-xe-2016-cli-pset__noarch"
COMPONENTS_ADVISOR="intel-advisor-xe-2016-cli__x86_64;intel-advisor-xe-2016-cli-common__noarch;intel-advisor-xe-2016-gui-common__noarch;intel-advisor-xe-2016-gui__x86_64;intel-advisor-xe-2016-cli-pset__noarch"
COMPONENTS_GDB="intel-gdb-gt__x86_64;intel-gdb-gt-src__noarch;intel-gdb-gt-libelfdwarf__x86_64;intel-gdb-gt-devel__x86_64;intel-gdb-gt-common__noarch;intel-gdb-ps-cdt__x86_64;intel-gdb-ps-cdt-source__x86_64;intel-gdb-ps-mic__x86_64;intel-gdb-ps-mpm__x86_64;intel-gdb__x86_64;intel-gdb-source__noarch;intel-gdb-python-source__noarch;intel-gdb-common__noarch;intel-gdb-ps-common__noarch"

# Parallel libraries
COMPONENTS_MPI="intel-mpi-rt-core__x86_64;intel-mpi-rt-mic__x86_64;intel-mpi-sdk-core__x86_64;intel-mpi-sdk-mic__x86_64;intel-mpi-psxe__x86_64;intel-mpi-rt-psxe__x86_64"
COMPONENTS_TBB="intel-tbb-libs__noarch;intel-mkl-ps-tbb__x86_64;intel-mkl-ps-tbb-devel__x86_64;intel-mkl-ps-tbb-mic__x86_64;intel-mkl-ps-tbb-mic-devel__x86_64;intel-tbb-source__noarch;intel-tbb-devel__noarch;intel-tbb-common__noarch;intel-tbb-ps-common__noarch;intel-tbb-psxe__noarch"
COMPONENTS_MKL="intel-mkl__x86_64;intel-mkl-ps__x86_64;intel-mkl-common__noarch;intel-mkl-ps-common__noarch;intel-mkl-devel__x86_64;intel-mkl-ps-mic-devel__x86_64;intel-mkl-ps-f95-devel__x86_64;intel-mkl-gnu-devel__x86_64;intel-mkl-ps-gnu-devel__x86_64;intel-mkl-ps-pgi-devel__x86_64;intel-mkl-sp2dp-devel__x86_64;intel-mkl-ps-cluster-devel__x86_64;intel-mkl-ps-cluster-common__noarch;intel-mkl-ps-f95-common__noarch;intel-mkl-ps-cluster__x86_64;intel-mkl-gnu__x86_64;intel-mkl-ps-gnu__x86_64;intel-mkl-ps-pgi__x86_64;intel-mkl-sp2dp__x86_64;intel-mkl-ps-mic__x86_64;intel-mkl-ps-tbb__x86_64;intel-mkl-ps-tbb-devel__x86_64;intel-mkl-ps-tbb-mic__x86_64;intel-mkl-ps-tbb-mic-devel__x86_64;intel-mkl-psxe__noarch"
COMPONENTS_IPP="intel-ipp-l-common__noarch;intel-ipp-l-ps-common__noarch;intel-ipp-l-st__x86_64;intel-ipp-l-mt__x86_64;intel-ipp-l-st-devel__x86_64;intel-ipp-l-ps-st-devel__x86_64;intel-ipp-l-mt-devel__x86_64;intel-ipp-psxe__noarch"
COMPONENTS_IPP_CRYPTO="intel-crypto-ipp-st-devel__x86_64;intel-crypto-ipp-ps-st-devel__x86_64;intel-crypto-ipp-st__x86_64;intel-crypto-ipp-mt-devel__x86_64;intel-crypto-ipp-mt__x86_64;intel-crypto-ipp-ss-st-devel__x86_64;intel-crypto-ipp-common__noarch"
COMPONENTS_DAAL="intel-daal__x86_64;intel-daal-common__noarch"

# Compilers
COMPONENTS_OPENMP="intel-openmp-l-all__x86_64;intel-openmp-l-ps-mic__x86_64;intel-openmp-l-ps__x86_64;intel-openmp-l-ps-ss__x86_64;intel-openmp-l-all-devel__x86_64;intel-openmp-l-ps-mic-devel__x86_64;intel-openmp-l-ps-devel__x86_64;intel-openmp-l-ps-ss-devel__x86_64"
COMPONENTS_COMPILER_COMMON="intel-comp-l-all-vars__noarch;intel-comp-l-all-common;intel-comp-l-ps-common;intel-comp-l-all-devel;intel-comp-l-ps-ss-devel;intel-comp-l-ps-ss-wrapper;intel-comp-l-all-devel;intel-comp-l-ps-devel__x86_64;intel-comp-l-ps-ss-devel__x86_64;intel-psf-intel__x86_64;intel-icsxe-pset;intel-ipsf__noarch;intel-ccompxe__noarch;${COMPONENTS_OPENMP}"
COMPONENTS_IFORT="intel-ifort-l-ps__x86_64;intel-ifort-l-ps-vars__noarch;intel-ifort-l-ps-common__noarch;intel-ifort-l-ps-devel__x86_64;${COMPONENTS_COMPILER_COMMON}"
COMPONENTS_ICC="intel-icc-l-all__x86_64;intel-icc-l-ps-ss__x86_64;intel-icc-l-all-vars__noarch;intel-icc-l-all-common__noarch;intel-icc-l-ps-common__noarch;intel-icc-l-all-devel__x86_64;intel-icc-l-ps-devel__x86_64;intel-icc-l-ps-ss-devel__x86_64;${COMPONENTS_COMPILER_COMMON}"

DESTINATION="${HOME}/intel"
TEMPORARY_FILES="/tmp"
PHONE_INTEL="no"
COMPONENTS=""

add_components() {
    if [ ! -z "${COMPONENTS}" ]; then
	COMPONENTS="${COMPONENTS};$1"
    else
	COMPONENTS="$1"
    fi
}

COMPONENTS="intel-itac-common__noarch;intel-trace-analyzer__x86_64;intel-trace-collector__x86_64;intel-itac-common-pset__noarch;intel_clck_common__x86_64;intel_clck_analyzer__x86_64;intel_clck_collector__x86_64;intel_clck__noarch;intel_clck_common-pset__noarch;intel-vtune-amplifier-2018-cli-common__noarch;intel-vtune-amplifier-2018-common__noarch;intel-vtune-amplifier-2018-cli__x86_64;intel-vtune-amplifier-2018-cli-32bit__i486;intel-vtune-amplifier-2018-collector-32linux__i486;intel-vtune-amplifier-2018-collector-64linux__x86_64;intel-vtune-amplifier-2018-doc__noarch;intel-vtune-amplifier-2018-sep__noarch;intel-vtune-amplifier-2018-target__noarch;intel-vtune-amplifier-2018-gui-common__noarch;intel-vtune-amplifier-2018-gui__x86_64;intel-vtune-amplifier-2018-common-pset__noarch;intel-inspector-2018-cli-common__noarch;intel-inspector-2018-cli__x86_64;intel-inspector-2018-cli-32bit__i486;intel-inspector-2018-doc__noarch;intel-inspector-2018-gui-common__noarch;intel-inspector-2018-gui__x86_64;intel-inspector-2018-cli-common-pset__noarch;intel-advisor-2018-cli-common__noarch;intel-advisor-2018-cli__x86_64;intel-advisor-2018-cli-32bit__i486;intel-advisor-2018-doc__noarch;intel-advisor-2018-gui-common__noarch;intel-advisor-2018-gui__x86_64;intel-advisor-2018-cli-common-pset__noarch;intel-comp__x86_64;intel-comp-doc__noarch;intel-comp-l-all-common__noarch;intel-comp-l-all-vars__noarch;intel-comp-nomcu-vars__noarch;intel-comp-ps__x86_64;intel-comp-ps-ss__x86_64;intel-comp-ps-ss-bec__x86_64;intel-openmp__x86_64;intel-openmp-common__noarch;intel-openmp-common-icc__noarch;intel-openmp-common-ifort__noarch;intel-openmp-ifort__x86_64;intel-tbb-libs__x86_64;intel-idesupport-icc-common-ps__noarch;intel-icc__x86_64;intel-c-comp-common__noarch;intel-icc-common__noarch;intel-icc-common-ps__noarch;intel-icc-common-ps-ss-bec__noarch;intel-icc-doc__noarch;intel-icc-doc-ps__noarch;intel-icc-ps__x86_64;intel-icc-ps-ss__x86_64;intel-icc-ps-ss-bec__x86_64;intel-ifort__x86_64;intel-ifort-common__noarch;intel-ifort-doc__noarch;intel-mkl-common__noarch;intel-mkl-core__x86_64;intel-mkl-core-rt__x86_64;intel-mkl-doc__noarch;intel-mkl-doc-ps__noarch;intel-mkl-gnu__x86_64;intel-mkl-gnu-rt__x86_64;intel-mkl-cluster__x86_64;intel-mkl-cluster-common__noarch;intel-mkl-cluster-rt__x86_64;intel-mkl-common-ps__noarch;intel-mkl-core-ps__x86_64;intel-mkl-common-c__noarch;intel-mkl-core-c__x86_64;intel-mkl-common-c-ps__noarch;intel-mkl-cluster-c__noarch;intel-mkl-tbb__x86_64;intel-mkl-tbb-rt__x86_64;intel-mkl-gnu-c__x86_64;intel-mkl-common-f__noarch;intel-mkl-core-f__x86_64;intel-mkl-cluster-f__noarch;intel-mkl-gnu-f-rt__x86_64;intel-mkl-gnu-f__x86_64;intel-mkl-f95-common__noarch;intel-mkl-f__x86_64;intel-ipp-common__noarch;intel-ipp-common-ps__noarch;intel-ipp-st__x86_64;intel-ipp-st-devel__x86_64;intel-ipp-st-devel-ps__x86_64;intel-ipp-doc__noarch;intel-tbb-devel__x86_64;intel-tbb-common__noarch;intel-tbb-doc__noarch;intel-daal-core__x86_64;intel-daal-common__noarch;intel-daal-doc__noarch;intel-imb__x86_64;intel-mpi-rt__x86_64;intel-mpi-sdk__x86_64;intel-mpi-doc__x86_64;intel-mpi-samples__x86_64;intel-gdb-gt__x86_64;intel-gdb-gt-doc__noarch;intel-gdb-gt-doc-ps__noarch;intel-gdb__x86_64;intel-gdb-common__noarch;intel-gdb-doc__noarch;intel-ism__noarch;intel-icsxe__noarch;intel-gdb-doc-ps__noarch;intel-gdb-mic__x86_64;intel-psxe-common__noarch;intel-psxe-doc__noarch;intel-psxe-common-doc__noarch;intel-icsxe-doc__noarch;intel-psxe-licensing__noarch;intel-psxe-licensing-doc__noarch;intel-icsxe-pset"

while [ $# != 0 ]; do
    case "$1" in
	"--dest")
	    DESTINATION="$(realpath "$2")"; shift
	    ;;
	"--tmpdir")
	    TEMPORARY_FILES="$2"; shift
	    ;;
	"--components")
	    shift
	    OLD_IFS="${IFS}"
	    IFS=","
	    IFS="${OLD_IFS}"
	    ;;
	*)
	    echo "Unrecognized argument '$1'"
	    exit 1
	    ;;
    esac
    shift
done

if [ -z "${COMPONENTS}" ]; then
    COMPONENTS="${COMPONENTS_ICC}"
fi

INSTALLER_SCRIPT="parallel_studio_xe_2018_update1_cluster_edition_online"
INSTALLER="${TEMPORARY_FILES}/${INSTALLER_SCRIPT}"
INSTALLER_URL="http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12374/${INSTALLER_SCRIPT}.tzg"
#INSTALLER_URL="http://registrationcenter-download.intel.com/akdlm/irc_nas/9061/"
SILENT_CFG="${TEMPORARY_FILES}/${INSTALLER_SCRIPT}/silent.cfg"
SUCCESS_INDICATOR="${TEMPORARY_FILES}/icc-travis-success"

if [ ! -e "${TEMPORARY_FILES}" ]; then
    echo "${TEMPORARY_FILES} does not exist, creating..."
    mkdir -p "${TEMPORARY_FILES}" || (sudo mkdir -p "${TEMPORARY_FILES}" && sudo chown -R "${USER}:${USER}" "${TEMPORARY_FILES}")
fi

if [ ! -e "${DESTINATION}" ]; then
    echo "${DESTINATION} does not exist, creating..."
    mkdir -p "${DESTINATION}" || (sudo mkdir -p "${DESTINATION}" && sudo chown -R "${USER}:${USER}" "${DESTINATION}")
fi

if [ ! -e "${INSTALLER}" ]; then
    wget -P /tmp/ http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/12374/parallel_studio_xe_2018_update1_cluster_edition_online.tgz || exit 1
    tar xf /tmp/parallel_studio_xe_2018_update1_cluster_edition_online.tgz -C "${TEMPORARY_FILES}"
fi
chmod u+x "${TEMPORARY_FILES}/${INSTALLER_SCRIPT}/install.sh"

# See https://software.intel.com/en-us/articles/intel-composer-xe-2015-silent-installation-guide
echo "# Generated silent configuration file" > "${SILENT_CFG}"
echo "ACCEPT_EULA=accept" >> "${SILENT_CFG}"
echo "INSTALL_MODE=NONRPM" >> "${SILENT_CFG}"
echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> "${SILENT_CFG}"
echo "PSET_INSTALL_DIR=${DESTINATION}" >> "${SILENT_CFG}"
echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> "${SILENT_CFG}"
echo "COMPONENTS=${COMPONENTS}" >> "${SILENT_CFG}"
echo "PSET_MODE=install" >> "${SILENT_CFG}"
echo "PHONEHOME_SEND_USAGE_DATA=${PHONE_INTEL}" >> "${SILENT_CFG}"
if [ "x" != "x${INTEL_SERIAL_NUMBER}" ]; then
    echo "ACTIVATION_SERIAL_NUMBER=${INTEL_SERIAL_NUMBER}" >> "${SILENT_CFG}"
    echo "ACTIVATION_TYPE=serial_number" >> "${SILENT_CFG}"
else
    echo "ACTIVATION_TYPE=trial_lic" >> "${SILENT_CFG}"
fi

attempt=1;
while [ $attempt -le 3 ]; do
    if [ ! -e "${TEMPORARY_FILES}/parallel-studio-install-data" ]; then
	mkdir -p "${TEMPORARY_FILES}/parallel-studio-install-data" || (sudo mkdir -p "${TEMPORARY_FILES}/parallel-studio-install-data" && sudo chown -R "${USER}:${USER}" "${TEMPORARY_FILES}")
    fi

    ("${INSTALLER}/install.sh" \
	 -t "${TEMPORARY_FILES}/parallel-studio-install-data" \
	 -s "${SILENT_CFG}" \
	 --cli-mode \
	 --user-mode && \
	 touch "${SUCCESS_INDICATOR}") &

    # So Travis doesn't die in case of a long download/installation.
    #
    # NOTE: a watched script never terminates.
    elapsed=0;
    while kill -0 $! 2>/dev/null; do
	sleep 1
	elapsed=$(expr $elapsed + 1)
	if [ $(expr $elapsed % 60) -eq 0 ]; then
	    mins_elapsed=$(expr $elapsed / 60)
	    if [ $mins_elapsed = 1 ]; then
		minute_string="minute"
	    else
		minute_string="minutes"
	    fi
	    echo "Still running... (about $(expr $elapsed / 60) ${minute_string} so far)."
	fi
    done

    if [ ! -e "${SUCCESS_INDICATOR}" ]; then
	echo "Installation failed."
	exit 1
    fi

    if [ ! -e "${DESTINATION}/bin/compilervars.sh" ]; then
	# Sometimes the installer returns successfully without actually
	# installing anything.  Let's try again…
	echo "Installation attempt #${attempt} completed, but unable to find compilervars.sh."
	find "${DESTINATION}"
    else
	break
    fi

    rm -vrf "${TEMPORARY_FILES}/parallel-studio-install-data"
    echo "Trying again..."

    attempt=$(expr $attempt + 1)
done

if [ ! -e "${DESTINATION}/bin/compilervars.sh" ]; then
	echo "Installation failed."
	exit 1
fi

# Apparently the installer drops the license file in a location it
# doesn't know to check.
ln -s "${DESTINATION}"/licenses ~/Licenses

# Add configuration information to ~/.bashrc.  Unfortunately this will
# not be picked up automatically by Travis, so you'll still need to
# source ~/.bashrc in your .travis.yml
#
# Container-based builds include a `[ -z "$PS1" ] && return` near the
# beginning of the file, so appending won't work, we'll need to
# prepend.
echo "export INTEL_INSTALL_PATH=\"${DESTINATION}\"" >> ~/.bashrc-intel
echo ". \"\${INTEL_INSTALL_PATH}/bin/compilervars.sh\" intel64" >> ~/.bashrc-intel
echo "export LD_LIBRARY_PATH=\"\${INTEL_INSTALL_PATH}/ism/bin/intel64:\${INTEL_INSTALL_PATH}/lib/intel64_lin:\$LD_LIBRARY_PATH\"" >> ~/.bashrc-intel
echo "export PATH=\"\${INTEL_INSTALL_PATH}/bin:\$PATH\"" >> ~/.bashrc-intel
echo "function uninstall_intel_software {" >> ~/.bashrc-intel
echo "  find \"\${INTEL_INSTALL_PATH}\" -name 'uninstall.sh' -not -path '*/ism/uninstall.sh' -exec {} -s \;" >> ~/.bashrc-intel
echo "}" >> ~/.bashrc-intel
cat ~/.bashrc >> ~/.bashrc-intel
mv ~/.bashrc-intel ~/.bashrc
