#!/usr/bin/env bash
set -e
readonly DIR=$(mktemp -d)
trap 'rm -rf "$DIR"' EXIT
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
    local sum
    sum=$(awk -v f="$file" '$2 == f || $2 == "*" f {print $1}' "$lchecksum")
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'
    then
        echo "bad or missing checksum for $file: '$sum'" >&2
        exit 1
    fi
    printf "    # %s\n" "$url"
    printf "    %s: sha256:%s\n" "$platform" "$sum"
}

dl_ver () {
    local ver=$1
    local checksum_url=${MIRROR}/v${ver}/downloads/checksums.txt
    printf "  # %s\n" "$checksum_url"
    local lchecksum=$DIR/glab-${ver}-checksums.txt

    curl -fsSL --proto '=https' --tlsv1.2 -o "$lchecksum" "$checksum_url"

    printf "  %s:\n" "$ver"
    dl $lchecksum $ver darwin arm64
    dl $lchecksum $ver darwin amd64
    dl $lchecksum $ver linux armv6
    dl $lchecksum $ver linux arm64
    dl $lchecksum $ver linux 386
    dl $lchecksum $ver linux amd64
    dl $lchecksum $ver windows 386 zip
    dl $lchecksum $ver windows amd64 zip
}

dl_ver ${1:-1.133.0}
