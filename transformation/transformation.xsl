<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    exclude-result-prefixes="xs meta office text"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="metad" select="document('meta.xml')"/>
    


    <xsl:template match="/">
        <xsl:variable name="title" select="$metad//meta:user-defined[@meta:name='Titre']"/>
        <xsl:result-document href="{translate($title,' ','-')}.xml" method="xml">
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>
                                <xsl:value-of select="$metad//meta:user-defined[@meta:name='Titre']"/>
                            </title>
                            <author>
                                <xsl:value-of select="$metad//meta:user-defined[@meta:name='Auteur']"/>
                            </author>
                            <respStmt>
                                <resp>Encoded in TEI Simple by</resp>
                                <name>Jianying LIU</name>
                            </respStmt>
                        </titleStmt>
                        <extent>
                            <measure unit="pages">
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="$metad//meta:document-statistic/@meta:page-count"/>
                                </xsl:attribute><xsl:value-of select="$metad//meta:document-statistic/@meta:page-count"/> pages</measure>
                            <measure unit="paragraphs">
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="$metad//meta:document-statistic/@meta:paragraph-count"/>
                                </xsl:attribute><xsl:value-of select="$metad//meta:document-statistic/@meta:paragraph-count"/> paragraphs</measure>
                            <measure unit="words">
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="$metad//meta:document-statistic/@meta:word-count"/>
                                </xsl:attribute><xsl:value-of select="$metad//meta:document-statistic/@meta:word-count"/> words</measure>
                            <measure unit="characters">
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="$metad//meta:document-statistic/@meta:character-count"/>
                                </xsl:attribute><xsl:value-of select="$metad//meta:document-statistic/@meta:character-count"/> characters</measure>
                            <measure unit="non-whitespace-characters">
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="$metad//meta:document-statistic/@meta:non-whitespace-character-count"/>
                                </xsl:attribute><xsl:value-of select="$metad//meta:document-statistic/@meta:non-whitespace-character-count"/> non-whitespace-characters</measure>
                        </extent>
                        <publicationStmt>
                            <publisher>Project Gutenberg</publisher>
                            <address>
                                <addrLine>
                                    <xsl:value-of select="$metad//meta:user-defined[@meta:name='Source']"/>
                                </addrLine>
                            </address>
                            <availability>
                                <licence>
                                    <xsl:attribute name="target">
                                        <xsl:value-of select="$metad//meta:user-defined[@meta:name='Licence']"/>
                                    </xsl:attribute>The Project Gutenberg License</licence>
                            </availability>
                            <date>
                                <xsl:value-of select="$metad//meta:user-defined[@meta:name= 'Date de la publication' or @meta:name= 'Date de publication']"/>
                            </date>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <title>
                                    <xsl:value-of select="$metad//meta:user-defined[@meta:name='Titre']"/>
                                </title>
                                <author>
                                    <xsl:value-of select="$metad//meta:user-defined[@meta:name='Auteur']"/>
                                </author>
                                <address>
                                    <addrLine>
                                        <xsl:value-of select="$metad//meta:user-defined[@meta:name='Source']"/>
                                    </addrLine>
                                </address>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <projectDesc>
                            <p><xsl:value-of select="$metad//meta:user-defined[@meta:name='Description']"/></p>
                        </projectDesc>
                    </encodingDesc>
                    <profileDesc>
                        <creation>
                            <date>
                                <xsl:value-of select="$metad//meta:user-defined[@meta:name='Date de la source']"/>
                            </date>
                        </creation>
                    </profileDesc>
                </teiHeader>
                <text>
                    <body>
                        <head>
                            <xsl:value-of select="//office:body/office:text/text:p[@text:style-name='Title']"/>
                        </head>
                        
                        <xsl:choose>
                            <xsl:when test="//text:h[@text:style-name='Heading_20_1']">
                                <xsl:apply-templates select="//office:body/office:text/text:h[@text:style-name='Heading_20_1']" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="//office:body/office:text/text:h[@text:style-name='Heading_20_2']" />
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="text:h[@text:style-name='Heading_20_1']">
        <div n="1">
            <head><xsl:value-of select="."/></head>
            <xsl:apply-templates select="following-sibling::text:p[@text:style-name='citation'][1]" />
            <xsl:choose>
                <xsl:when test="following-sibling::text:h[@text:style-name='Heading_20_1'][1]">
                    <xsl:variable name="post" select="index-of(following-sibling::*, following-sibling::text:h[@text:style-name='Heading_20_1'][1])"/>
                    <xsl:for-each select="following-sibling::*[position() &lt; $post]">
                        <xsl:if test="./@text:style-name eq 'Heading_20_2'">
                            <xsl:apply-templates select="."></xsl:apply-templates>
                        </xsl:if>               
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="following-sibling::text:h[@text:style-name='Heading_20_2']">
                        <xsl:apply-templates select="."></xsl:apply-templates>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <xsl:template match="text:h[@text:style-name='Heading_20_2']">
        <div n="2">
            <head><xsl:value-of select="."/></head>
            <xsl:choose>
                
                <xsl:when test="following-sibling::text:h[1]">
                    <xsl:variable name="post" select="index-of(following-sibling::*, following-sibling::text:h[1])"/>
                    <xsl:for-each select="following-sibling::*[position() &lt; $post]">
                        <xsl:apply-templates select="." />  
                    </xsl:for-each>
                </xsl:when>
                              
                <xsl:otherwise>
                    <xsl:for-each select="following-sibling::text:p">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:otherwise>
                
            </xsl:choose>          
        </div>
    </xsl:template>
    
    
    
    <xsl:template match="text:p">
<!--        <xsl:apply-templates select="text:span" />-->
        <xsl:choose>
            <xsl:when test="./@text:style-name='Text_20_body'">
                <p>
                    <xsl:apply-templates />
                </p>
            </xsl:when>
            <xsl:when test="./@text:style-name='citation'">
                <quote>
                    <xsl:apply-templates />
                </quote>
            </xsl:when>
        </xsl:choose>  
    </xsl:template>

    
    <xsl:template match="text:span">
        <xsl:choose>
            <xsl:when test="./@text:style-name='italique'">
                <hi rend="italic">
                    <xsl:apply-templates />
                </hi>
            </xsl:when>
            <xsl:when test="./@text:style-name='gras'">
                <hi rend="bold">
                    <xsl:apply-templates />
                </hi>
            </xsl:when>
        </xsl:choose>     
    </xsl:template>
    
</xsl:stylesheet>