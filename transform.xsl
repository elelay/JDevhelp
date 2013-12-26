<?xml version="1.0" ?>
<!--
 transform.xsl - produce a Devhelp version 2 book from given javadoc
 Copyright 2013 Eric Le Lay <neric27@wanadoo.fr>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.devhelp.net/book"
	xmlns:h="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- name must be unique amongst installed books.
         Only the first book with this name will be displayed
         in Devhelp.
      -->
    <xsl:param name="name" as="xs:string"/>
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- only template: this transform is very procedural -->
    <xsl:template match="/">
    <book 
    	title="{substring-before(substring-after(/h:html/h:head/h:title,'('),')')}"
    	link="overview-summary.html"
    	author="me"
    	name="{$name}"
    	version="2"
    	language="Java">
    	
    	<chapters>
    		<!-- one chapter per package -->
    		<xsl:for-each-group select="/h:html/h:body/descendant::h:a"
    							group-by="replace(@title,'.+ in (.+)','$1')">
    			<xsl:sort select="current-grouping-key()"/>
    			<xsl:variable name="topkg" select="concat(replace(current-grouping-key(),'\.','/'),'/package-summary.html')"/>
    			<xsl:variable name="pkg" select="current-grouping-key()"/>
    			<sub name="{$pkg}"
    			     link="{$topkg}">
    			     <!-- uncomment to add a level with class|interface -->
    			     <!--<xsl:for-each-group select="current-group()"
    			                         group-by="substring-before(@title,' in')">
    			         <sub name="{current-grouping-key()}" link="{$topkg}">-->
							<xsl:for-each select="current-group()">
								<sub name="{$pkg}.{.}" link="{@href}"/>
							</xsl:for-each>
    			         <!--</sub>
    			     </xsl:for-each-group>-->
    			</sub>
    		</xsl:for-each-group>
    	</chapters>
    	<!-- uncomment to produce searchable keywords for methods
    	     and constructors.
    	     Parses the description of each class so it add considerable
    	     time.
    	     Not that useful: too many results -->
    	<!-- <functions>
    		<xsl:for-each select="/h:html/h:body/descendant::h:a">
    			<xsl:variable name="class" select="normalize-space(.)"/>
    			<xsl:for-each select="document(@href,.)">
    				<xsl:for-each select="//h:a[@name='method_summary']/following-sibling::h:table[1]">
						<xsl:call-template name="method_summary">
							<xsl:with-param name="class" select="$class"/>
						</xsl:call-template>
    				</xsl:for-each>
    				<xsl:for-each select="//h:a[@name='constructor_summary']/following-sibling::h:table[1]">
						<xsl:call-template name="constructor_summary">
							<xsl:with-param name="class" select="$class"/>
						</xsl:call-template>
    				</xsl:for-each>
    			</xsl:for-each>
    		</xsl:for-each>
    	</functions>
    	-->
    </book>
    </xsl:template>
    
    <!-- produce 1 searchable keyword per declared function -->
    <xsl:template name="method_summary">
    	<xsl:param name="class" as="xs:string"/>
    	<xsl:for-each select="h:tr[position()>1]/h:td[2]/h:code[1]">
    		<keyword type="function"
    			name="{$class}.{normalize-space(replace(.,'\(.+','','s'))}"
    			link="{replace(h:strong/h:a[1]/@href,'(\.\./)+','')}"/>
    	</xsl:for-each>
    </xsl:template>
    
    <!-- produce 1 searchable keyword per constructor -->
    <xsl:template name="constructor_summary">
    	<xsl:param name="class" as="xs:string"/>
    	<xsl:for-each select="h:tr[position()>1]/h:td[1]/h:code[1]">
    		<keyword type="function"
    			name="{$class}.{normalize-space(replace(.,'\(.+','','s'))}"
    			link="{replace(h:strong/h:a[1]/@href,'(\.\./)+','')}"/>
    	</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

