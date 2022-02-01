

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