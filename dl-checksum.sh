#!/usr/bin/env bash
set -e
readonly DIR=~/Downloads
readonly MIRROR=https://gitlab.com/gitlab-org/cli/-/releases

dl()
{
    local lchecksum=$1
    local ver=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform=${os}_${arch}
    local file=glab_${ver}_${platform}.${archive_type}
    local url=$MIRROR/v$ver/downloads/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksum | awk '{print $1}')
}

dl_ver () {
    local ver=$1
    local checksum_url=${MIRROR}/v${ver}/downloads/checksums.txt
    printf "  # %s\n" $checksum_url
    local lchecksum=$DIR/glab-${ver}-checksums.txt

    if [ ! -e $lchecksum ];
    then
        curl -sSLf -o $lchecksum $checksum_url
    fi

    printf "  %s:\n" $ver
    dl $lchecksum $ver macOS arm64
    dl $lchecksum $ver macOS x86_64
    dl $lchecksum $ver Linux armv6
    dl $lchecksum $ver Linux arm64
    dl $lchecksum $ver Linux i386
    dl $lchecksum $ver Linux x86_64
    dl $lchecksum $ver Windows i386 zip
    dl $lchecksum $ver Windows x86_64 zip
}

dl_ver ${1:-1.45.0}
