#! /bin/bash

RESETCLR="\e[0m"
RED="\e[31m"
GREEN="\e[32m"

cecho() {
    case $1 in 
    RED)
        print_clr=${RED}
        ;;
    GREEN)
        print_clr=${GREEN}
        ;;
    *)
        print_clr=${RESETCLR}
        ;;    
    esac
    echo -e ${print_clr}${2}${RESETCLR}
}

bail_if_fail() {
    if [[ $? -ne 0 ]]; then
    cecho RED "---- cherry-pick failed! Aborting... ----"
    git cherry-pick --abort 
    fi
}

run_in_path() {
    cd $1
    if [[ "$PWD" =~ "$1" ]]; then
        eval $2
        bail_if_fail
        cd - > /dev/null
    fi
}

cecho GREEN "Applying patch to fix display transforms (night light/SDM livedisplay picturadjustment/extra dim)"
run_in_path "hardware/qcom-caf/sm8650/display" "git fetch https://github.com/LineageOS/android_hardware_qcom_display refs/changes/23/430223/2 && git cherry-pick FETCH_HEAD"

cecho GREEN "Applying patch to fix qcom sepolicy on android 16"
run_in_path "device/qcom/sepolicy_vndr/sm8650" "git fetch https://github.com/Evolution-X/device_qcom_sepolicy_vndr/ refs/heads/bka-sm8450 && git cherry-pick 6839c88bc978abc0bf39d021780fba3a2b1e4f37"

cecho GREEN "Applying patch to allow dtbs to depend on each other"
run_in_path "vendor/lineage" "git fetch https://github.com/LineageOS/android_vendor_lineage refs/changes/43/436043/3 && git cherry-pick FETCH_HEAD"

cecho GREEN "Applying patch to fix NubiaCamera 8K recording and front camera on tiro (sensor pixel mode)"
run_in_path "frameworks/av" "git fetch https://github.com/LineageOS/android_frameworks_av refs/changes/17/451317/1 && git cherry-pick FETCH_HEAD"

cecho GREEN "Applying patch for sysfs livedisplay node permissions"
run_in_path "hardware/lineage/interfaces" "git fetch https://github.com/LineageOS/android_hardware_lineage_interfaces refs/changes/68/450868/1 && git cherry-pick FETCH_HEAD"



