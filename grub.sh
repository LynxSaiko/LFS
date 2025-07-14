#!/bin/bash
# [+] Author: LynxSaiko

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2

	echo "[lfs-final] Starting build of $package_name at $(date)"

	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-final] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}
