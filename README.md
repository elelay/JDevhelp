# JDevhelp

This program makes javadocs browsable from
[Devhelp](https://wiki.gnome.org/Apps/Devhelp).


    Copyright 2013 Eric Le Lay wanadoo.fr:neric27
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

## Dependencies

 - Java 1.6 or later (JDK is not required).
 - The open source SAXON XSLT processor developed by Saxonica Limited 
   (the home edition is sufficient).
 - The *HTML as XML* TagSoup parser developed by John Cowan.

## Installation

1. get this [directory](https://github.com/elelay/JDevhelp/archive/master.zip)
2. download Saxon HE 9 from [Saxon homepage](http://saxon.sourceforge.net/)
   or [maven repository](http://search.maven.org/remotecontent?filepath=net/sf/saxon/Saxon-HE/9.5.1-3/Saxon-HE-9.5.1-3-compressed.jar)
3. Save it in this directory as `saxon9he.jar`
4. download TagSoup from [TagSoup homepage](http://ccil.org/~cowan/XML/tagsoup/#1.2.1)
5. Save it in this directory as `tagsoup-1.2.1.jar`

## Browsing local javadoc

To browse the API of a program you built yourself,
use the `jdevhelp-link.sh` script.

> jdevhelp-link.sh build/doc/api MySuperProgram

will make the javadoc in build/doc/api browsable
in Devhelp as MySuperProgram.

The content will not be copied over 
to the Devhelp books directory so keep it in place

You'll have to restart Devhelp to access the new book.

### Indexing the Java Platform API

 1. Download the javadoc from [Oracle](http://www.oracle.com/technetwork/java/javase/documentation/java-se-7-doc-download-435117.html)
 2. Extract to `Whatever` directory
 3. Run `jdevhelp-link.sh Whatever/api JavaPlatform`


## Browsing javadoc of a dependency

Download the javadoc artifact from
maven [repository](http://search.maven.org).
These are jar files ending with "-javadoc.jar"

Use the `jdevhelp-jar.sh` script:

> jdevhelp-jar.sh ~/Downloads/my-dependency-x.y.z-javadoc.jar

You'll have to restart Devhelp to access the new book.

## How it works

Devhelp books are installed in `$HOME/.local/share/devhelp/books`

They consist in a directory with html content and a `xxx.devhelp2` XML file
containing the table of contents and index.

Javadocs always have an `allclasses-noframe.html` file
listing all classes in the javadoc. This file is parsed
by JDevhelp and transformed into a devhelp2 table of contents.

`jdevhelp-link.sh` will first create a link from the directory
containing the javadocs to the books directory.

`jdevhelp-jar.sh` will first extract the content of the javadocs artifacts
in the books directory.

## Alternatives / future work


### A Devhelp doclet

Devhelp integration is currently decoupled from the build process.

`jdevhelp-link` could be run from an Ant task.

A better way would be to generate the devhelp2 file using a doclet (see
[The javadoc ant task](http://ant.apache.org/manual/Tasks/javadoc.html)).
See for instance the [jEdit doclet](http://jedit.svn.sourceforge.net/viewvc/jedit/jEdit/trunk/doclet/GenerateTocXML.java?view=markup).

Then jdevhelp-link would be invoked only once to setup the link (or `ln -s` run
manually) and the book will be in sync with the javadocs upon each successive
`ant build`.

### Select and install from Devhelp itself

This is not the way of installing books in Devhelp currently, but a GUI to
browse for and install javadocs directly from Devhelp preferences would be cool.


### Maven integration

One should be able to get javadocs for all dependencies using this snippet (untested):

     <project>
       [...]
       <build>
         <plugins>
           <plugin>
             <groupId>org.apache.maven.plugins</groupId>
             <artifactId>maven-dependency-plugin</artifactId>
             <version>2.8</version>
             <executions>
               <execution>
                 <id>javadoc-dependencies</id>
                 <phase>package</phase>
                 <goals>
                   <goal>unpack-dependencies</goal>
                 </goals>
                 <configuration>
                   <classifier>javadoc</classifier>
                   <failOnMissingClassifierArtifact>false</failOnMissingClassifierArtifact>
                   <outputDirectory>${project.build.directory}/apidocs</outputDirectory>
                 </configuration>
               </execution>
             </executions>
           </plugin>
         </plugins>
       </build>
       [...]
     </project>
Source: [Maven Dependency Plugin](http://maven.apache.org/plugins/maven-dependency-plugin/examples/using-dependencies-sources.html)

Then (untested)
    for i in build/apidocs/*; do
      j=`basename $i`
      echo installing $j
      jdevhelp-link.sh $i $j
    done

### Tagging methods, fields and constructors

Variations in the transform are possible. I have tried to index methods and
constructors but I didn't find the search function satisfactory:
if I index methods and constructors, 
I can't find the *String* class by typing *String* anymore.

To enable indexing of methods and constructors, uncomment relevant parts of
`transform.xsl`.
