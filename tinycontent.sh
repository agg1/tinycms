#!/bin/sh -e
# aggi (c) 2025
# TinyCMS content item handlers

#
TINYCMS_CONTENTDIR="${1}"
#
TINYCMS_NAVITEM="${2}"
#
TINYCMS_NAVITEM_META="${TINYCMS_CONTENTDIR}"/_"${TINYCMS_NAVITEM}".meta
#
TINYCMS_PRETEXT_ITEM=""

#
if [ ! -e "${TINYCMS_NAVITEM_META}" ] ; then
	echo "Navitem not found: ${TINYCMS_NAVITEM_META}"
	exit 1
else
	. "${TINYCMS_NAVITEM_META}"
fi

# optional htm content item rendered above content grid
[ ! -z "${TINYCMS_PRETEXT_ITEM}" -a -e "${TINYCMS_PRETEXT_ITEM}" ] && cat "${TINYCMS_PRETEXT_ITEM}"

# arrange content snippets defined in _<navitem>.meta
tinycms_default_content() {
	[ -z "${TINYCMS_CONTENT_ITEMS}" ] && return
	for c in ${TINYCMS_CONTENT_ITEMS} ; do
		[ -e "${c}" ] || continue

		TINYCMS_ITEM_DATE=""
		TINYCMS_ITEM_TITLE=""
		TINYCMS_ITEM_AUTHOR=""
		# optional <contentitem>.meta
		if [ -e "${c}".meta ] ; then
			. "${c}".meta
		fi

		# gather content item modification data if it was not available with <contentitem>.meta
		if [ ! -z "${TINYCMS_ITEM_DATE}" ] ; then
			TINYCMS_ITEM_MDATE="$(date -d"$(stat -c %y ${c})" +'%Y-%m-%d %H:%S UTC' 2>/dev/null)"
		fi

		# content item title/heading
		[ ! -z "${TINYCMS_ITEM_TITLE}" ] && \
		echo "<div class=heading>${TINYCMS_ITEM_TITLE}</div>"

		# content item format specific output
		echo '<div class=col>'
		case "${c}" in
		*.md)
			# markdown items with optional table of contents
			if [ -z "${TINYCMS_ITEM_TOC}" ] ;then
				markdown -f+html ${c}
			else
				markdown -T -f+toc,+html ${c}
			fi
		;;
		*.htm*)
			cat ${c}
		;;
		*.txt)
			echo -n "<pre>" ; cat ${c} ; echo "</pre>"
		;;
		#*.pdf)
		#	#pdftotext does not work with legacy gs-7.07
		#;;
		*)
		;;
		esac
		echo '</div>'
		echo "<div class=text-right>${TINYCMS_ITEM_MDATE}</div>"
	done
}

tinycms_download_content() {
	#
	echo '<div class=col>'
	for f in $(find ${TINYCMS_DOWNLOAD_DIR} -type f) ; do
		echo "<a href='${f}'>$(ls --time-style='+%Y-%m-%d %M:%H' -gho "${f}")</a><br />"
	done
	echo '</div>'
}

tinycms_blog_content() {
	# no specific blog_content handler exists yet to navigate by <year>/<month>
	tinycms_default_content
}

tinycms_rss_content() {
	# generate rss.xml
}

$TINYCMS_CONTENT_HANDLER

