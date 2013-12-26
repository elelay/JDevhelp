#!/bin/bash
# jdevhelp-link.sh - make javadoc accessible as Devhelp book
# Copyright 2013 Eric Le Lay wanadoo.fr:neric27
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

usage="Usage: $0 <existing javadoc dir> [name]"
if [ "" == "$1" ]; then
	echo $usage
	exit -1
elif [ ! -f "$1/allclasses-noframe.html" ]; then
	echo $usage
	echo "E: $1/allclasses-noframe.html doesn't exist"
	exit -1
else
	apidir=`realpath $1`
	allclasses=$apidir/allclasses-noframe.html
fi

#set -x
if [ "" == "$2" ]; then
	echo $usage
	echo "E: name is required (pick a unique name)"
	exit -1
else
	name=$2
fi

share=${XDG_DATA_HOME:-~/.local/share}
booksdir=$share/devhelp/books

if [ ! -d "$booksdir" ]; then
	mkdir -p "$booksdir"
fi

book=$booksdir/$name

if [ -e "$book" ]; then
	if [ `readlink $book` == "$apidir" ]; then
		echo "I: link already exists, not creating (OK)"
	else
		echo "E: $book already exists. Remove it first."
		exit -1
	fi
else
	ln -s "$apidir" "$book"
fi

me=`realpath $0`
mydir=`dirname "$me"`
transform="$mydir/transform.xsl"
tsaxon="$mydir/tsaxon.sh"

$tsaxon "$book/allclasses-noframe.html" \
        "$transform" \
        "$book/$name.devhelp2" \
        "name=$name"
