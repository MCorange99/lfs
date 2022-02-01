cat packages.csv | while read line; do
	NAME="`echo $line | cut -d\; -f1`"
	VERSION="`echo $line | cut -d\; -f2`"
	URL="`echo $line | cut -d\; -f3 | sed "s/@/$VERSION/g"`"
	MD5="`echo $line | cut -d\; -f4`"

	CACHEFILE="$(basename "$URL")"

	echo "NAME: $NAME"
	echo "VERSION: $VERSION"
	echo "URL: $URL"
	echo "MD5: $MD5"
	echo "CACHEFILE: $CACHEFILE"

	if [ ! -f "$CACHEFILE" ]; then 
		echo "Downloading: $URL"
		wget "$URL"
		if ! echo "$MD5 $CACHEFILE" | md5sum -c >/dev/null; then
			rm -f "$CACHEFILE"
			echo "MD5sum check failed for $CACHEFILE!"
			exit 1
		fi
	fi

done
echo "==================Finished downloading packages=================="

# patch binutils-2.37.tar.xz binutils-2.37-upstream_fix-1.patch
# patch bzip2-1.0.8.tar.gz bzip2-1.0.8-install_docs-1.patch
# patch coreutils-8.32.tar.xz coreutils-8.32-i18n-1.patch
# patch glibc-2.34.tar.xz glibc-2.34-fhs-1.patch 
# patch kbd-2.4.0.tar.xz kbd-2.4.0-backspace-1.patch
# patch perl-2.34.0.tar.xz perl-5.34.0-upstream_fixes-1.patch 