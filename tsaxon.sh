#!/bin/sh
# tsaxon.sh - invoke Saxon 9 with TagSoup parser to parse HTML
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
me=`realpath "$0"`
mydir=`dirname "$0"`

usage="Usage: $O <source.html> <transform.xsl> <output> [more parameters passed to saxon]"
if [ "$1" == "" ]; then
	echo $usage
	exit -1
elif [[ ( ( ! -e "$1" ) || -d "$1" ) ]]; then
	echo $usage
	echo "$1 is not a readable file"
	exit -1
else
	source=$1
	shift
fi

if [ "$1" == "" ]; then
	echo $usage
	exit -1
elif [[ ( ( ! -e "$1" ) || -d "$1" ) ]]; then
	echo $usage
	echo "$1 is not a readable file"
	exit -1
else
	transform=$1
	shift
fi

if [ "$1" == "" ]; then
	echo $usage
	exit -1
elif [ -d "$1" ]; then
	echo $usage
	echo "$1 is a directory; can't write to it"
	exit -1
else
	output=$1
	shift
fi

CLASSPATH=$mydir/saxon9he.jar:$mydir/tagsoup-1.2.1.jar
#set -x
java -cp "$CLASSPATH" net.sf.saxon.Transform "-s:$source" "-xsl:$transform" "-o:$output" \
     -x:org.ccil.cowan.tagsoup.Parser -dtd:off \
     $*
