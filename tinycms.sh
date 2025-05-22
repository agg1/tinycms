#!/bin/sh -e
# TinyCMS web content management system written in shell script inspired by mkws.sh
# aggi (c) 2025

CWD="$(pwd)"

#
export LANG="C.UTF-8"

#
export TINYCMS_SITEURL="http://tinyfront.mooo.com"
# this contains <navitem>.meta data and content files residing anywhere
export TINYCMS_CONTENTDIR="/media/DATA/WWW/tinycms.git/content"
#
export TINYCMS_DOWNLOAD_DIR="downloads"
# authoring directory maintained with git
export TINYCMS_SRCDIR="/media/DATA/WWW/tinycms.git"
#
export TINYCMS_TEMPLATE="${TINYCMS_SRCDIR}"/tinycms.tmpl
#
export TINYCMS_SITEMAP_TEMPLATE="${TINYCMS_SRCDIR}"/sitemap.tmpl

# chrooted websrv/lighttpd.conf
WEBSRV_ROOT="/tmp/www"
# htdocs output directory
TINYCMS_OUTDIR="${WEBSRV_ROOT}"/tinycms

# each nav-item needs a ${TINYCMS_CONTENTDIR}/<navitem>.meta file
TINYCMS_NAVITEMS="index docs download src projects people contact blog rss"

# cleanup
[ ! -z "${WEBSRV_ROOT}" -a -e "${WEBSRV_ROOT}" ] && rm -rf "${WEBSRV_ROOT}"
[ ! -z "${TINYCMS_OUTDIR}" ] && rm -rf "${TINYCMS_OUTDIR}"
mkdir -p "${TINYCMS_OUTDIR}"

### render htdocs output for deployment
cd "${TINYCMS_SRCDIR}"
#
for n in ${TINYCMS_NAVITEMS} ; do
	echo "Generating ${TINYCMS_OUTDIR}/${n}.html"
	pp "${TINYCMS_TEMPLATE}" "${n}" "${TINYCMS_SITEURL}" > "${TINYCMS_OUTDIR}"/"${n}.html"
done
#
echo "Generating ${TINYCMS_OUTDIR}/sitemap.xml"
cd "${TINYCMS_OUTDIR}"
pp "${TINYCMS_SITEMAP_TEMPLATE}" "${TINYCMS_SITEURL}" > "${TINYCMS_OUTDIR}"/sitemap.xml
cd "${TINYCMS_SRCDIR}"
cp -p "${TINYCMS_SRCDIR}"/robots.txt "${TINYCMS_OUTDIR}" || true

### deploy
# variant1
#openssl genrsa -aes256 -out new.key 4096
# remove ssword
#openssl rsa -in new.key -out testing.key
#openssl req -new -key testing.key -out testing.csr
#openssl x509 -req -days 365 -in testing.csr -signkey testing.key -out testing.crt
#cat testing.key testing.crt > testing.pem
## variant2
##openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
##chmod 600 *
##chown lighttpd:lighttpd *
##chmod 600 *.key *.crt *.pem

### initial template
##git init .
###git ignore
##git config user.email "aggi@tinyfront"
##git config user.name "Michael Ackermann"

pkill lighttpd

# lighttpd chroot
mkdir -p "${WEBSRV_ROOT}"/www-cache "${WEBSRV_ROOT}"/log "${WEBSRV_ROOT}"/stat
#
mkdir -p "${WEBSRV_ROOT}"/dev ; chmod 755 "${WEBSRV_ROOT}"/dev
#mknod "${WEBSRV_ROOT}"/dev/null c 1 3; chmod 666 "${WEBSRV_ROOT}"/dev/null
touch "${WEBSRV_ROOT}"/dev/null; chmod 666 "${WEBSRV_ROOT}"/dev/null

#
cp -R files "${TINYCMS_OUTDIR}"
cp -R schemas "${TINYCMS_OUTDIR}"
cp -R styles "${TINYCMS_OUTDIR}"
cp -R "${TINYCMS_DOWNLOAD_DIR}" "${TINYCMS_OUTDIR}"

# 
chown -R root:lighttpd "${TINYCMS_OUTDIR}"
chmod -R ugo-rwx "${TINYCMS_OUTDIR}"
chmod -R ug+rX "${TINYCMS_OUTDIR}"
# keep it read-only
chmod -R ugo-w "${TINYCMS_OUTDIR}"

# webroot directories
chown -R lighttpd:lighttpd "${WEBSRV_ROOT}"
chmod -R ugo-rwx "${WEBSRV_ROOT}"/www-cache "${WEBSRV_ROOT}"/log "${WEBSRV_ROOT}"/stat
chmod -R u+rwX "${WEBSRV_ROOT}"/www-cache "${WEBSRV_ROOT}"/log "${WEBSRV_ROOT}"/stat
chmod 550 "${WEBSRV_ROOT}"

# lighttpd websrv configuration
cp websrv/lighttpd.conf /etc/lighttpd/
chown root:lighttpd /etc/lighttpd/lighttpd.conf
chmod 640 /etc/lighttpd/lighttpd.conf
# certificate
cp websrv/testing.pem /etc/lighttpd/
chown lighttpd:lighttpd /etc/lighttpd/testing.pem
chmod 400 /etc/lighttpd/testing.pem
lighttpd -f /etc/lighttpd/lighttpd.conf

