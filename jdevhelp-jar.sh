#!/bin/bash
# jdevhelp-jar.sh - install javadoc artifact as Devhelp book
# Copyright 2013 Eric Le Lay <neric27@wanadoo.fr>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

usage="Usage: $0 <xxx-javadoc.jar> [name]"
if [ "" == "$1" ]; then
	echo $usage
	exit -1
elif [ ! -f "$1" ]; then
	echo $usage
	echo "File $1 doesn't exist or is not a file"
	exit -1
else
	jar=$1
fi

set -x
if [ "" == "$2" ]; then
	jarname=`basename $1`
	name=${jarname%-javadoc.jar}
	if [ "$name" == "$jarname" ]; then
		echo $usage
		echo "File $1 doesn't end in -javadoc.jar"
		exit -1
	fi
else
	name=$2
fi

share=${XDG_DATA_HOME:-~/.local/share}
booksdir=$share/devhelp/books

if [ ! -d "$booksdir" ]; then
	mkdir -p "$booksdir"
fi

book=$booksdir/$name
mkdir "$book"

unzip $jar -d "$book"

me=`realpath $0`
mydir=`dirname "$me"`
transform="$mydir/transform.xsl"
tsaxon="$mydir/tsaxon.sh"

$tsaxon "$book/allclasses-noframe.html" \
        "$transform" \
        "$book/$name.devhelp2" \
        "name=$name"
