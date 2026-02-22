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

	# content item navigation
	if [ ! -z "${TINYCMS_NAVITEM_TOC}" ] ; then
		for c in ${TINYCMS_CONTENT_ITEMS} ; do
			[ -e "${c}" ] || continue

			TINYCMS_ITEM_DATE=""
			TINYCMS_ITEM_TITLE=""
			TINYCMS_ITEM_AUTHOR=""
			# optional <contentitem>.meta
			if [ -e "${c}".meta ] ; then
				. "${c}".meta
			fi

			if [ ! -z "${TINYCMS_ITEM_TITLE}" ] ; then
				TINYCMS_ITEM_NAV="$(basename ${c})"
				echo "<div><a href=#${TINYCMS_ITEM_NAV} class=content-nav>${TINYCMS_ITEM_TITLE}</a></div>"
			fi
		done
	fi

	for c in ${TINYCMS_CONTENT_ITEMS} ; do
		[ -e "${c}" ] || continue

		TINYCMS_ITEM_DATE=""
		TINYCMS_ITEM_TITLE=""
		TINYCMS_ITEM_AUTHOR=""
		# optional <contentitem>.meta
		if [ -e "${c}".meta ] ; then
			. "${c}".meta
		fi

		# gather content item modification date if it was not available with <contentitem>.meta
		if [ -z "${TINYCMS_ITEM_DATE}" ] ; then
			TINYCMS_ITEM_DATE="Updated: $(date -d"$(stat -c %y ${c})" +'%Y-%m-%d %H:%S UTC' 2>/dev/null)"
		else
			TINYCMS_ITEM_DATE="Created: ${TINYCMS_ITEM_DATE} - Updated: $(date -d"$(stat -c %y ${c})" +'%Y-%m-%d %H:%S UTC' 2>/dev/null)"
		fi

		if [ ! -z "${TINYCMS_ITEM_AUTHOR}" ] ; then
			TINYCMS_ITEM_FOOTER="${TINYCMS_ITEM_DATE} - ${TINYCMS_ITEM_AUTHOR}"
		else
			TINYCMS_ITEM_FOOTER="${TINYCMS_ITEM_DATE}"
		fi

		# content item title/heading
		if [ ! -z "${TINYCMS_ITEM_TITLE}" ] ; then
			TINYCMS_ITEM_NAV="$(basename ${c})"
			echo -n "<a class=item-anchor href=${TINYCMS_NAVITEM}.html name=${TINYCMS_ITEM_NAV}></a>"
			echo "<h1 class=item-header>${TINYCMS_ITEM_TITLE}</h1>"
		fi

		# content item format specific output
		echo '<div class=col>'
		case "${c}" in
		*.md)
			_entity="$(basename ${c} .md)"
			# markdown items with optional table of contents
			if [ -z "${TINYCMS_ITEM_TOC}" ] ;then
				markdown -f+tables,+footnote,+html -C "fn_${_entity}" ${c}
			else
				markdown -T -f+toc,+tables,+footnote,+html -C "fn_${_entity}" ${c}
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
		## optional content item changelog link
		echo "<div class=item-footer>${TINYCMS_ITEM_FOOTER}</div>"
	done
}

tinycms_download_content() {
	#
	echo '<div class=col><pre>'
	for f in $(find ${TINYCMS_DOWNLOAD_DIR} -type f -maxdepth 1) ; do
		_f=$(ls --time-style='+%Y-%m-%d %M:%H' -gho "${f}")
		_f_size="$(echo ${_f} | cut -d' ' -f3)"
		_f_date="$(echo ${_f} | cut -d' ' -f4)"
		_f_time="$(echo ${_f} | cut -d' ' -f5)"
		_f_name="$(echo ${_f} | cut -d' ' -f6)"
		_f_entry="${_f_size}"
		echo "<a href='${f}'>> ${_f_size}	${_f_date} ${_f_time} ${_f_name}</a>"
	done
	echo '</pre></div>'
}

tinycms_blog_content() {
	# no specific blog_content handler exists yet to navigate by <year>/<month>
	tinycms_default_content
}

tinycms_rss_content() {
	# generate rss.xml
}

$TINYCMS_CONTENT_HANDLER

