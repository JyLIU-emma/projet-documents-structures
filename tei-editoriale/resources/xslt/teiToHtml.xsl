<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:output method="xhtml" indent="yes"/> 

    <xsl:template match="/">
        <div class="page-header" align="center">
            <h1>
                <xsl:value-of select="//tei:body/tei:head"/>
            </h1>
            <b>
                <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:author"/>
            </b>
            <br/>
        </div>
        <div class="sommaire">
            <h2>Table des mati¨¨res</h2>
            <xsl:for-each select="//tei:body/tei:div">
                <xsl:call-template name="sommaire"/>
            </xsl:for-each>
            <hr/>
        </div>
        <div class="body">
            <xsl:apply-templates select="//tei:body"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div" name="sommaire">
        <xsl:choose>
            <xsl:when test="./@n='1'">
                <a href="#{./tei:head/text()}">
                    <h4>
                        <xsl:value-of select="./tei:head"/>
                    </h4>
                </a>
                <xsl:for-each select="./tei:div[@n='2']/tei:head">
                    <a href="#{./text()}">
                        <h6>
                            <xsl:value-of select="."/>
                        </h6>
                    </a>               
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="./@n='2'">
                <a href="#{./tei:head/text()}">
                    <h5>
                        <xsl:value-of select="./tei:head"/>
                    </h5>
                </a>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:for-each select="./tei:div">
            <div id="{./tei:head/text()}">
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>     
    </xsl:template>
    
    <xsl:template match="tei:head">
        <br/>
        <h4>
            <xsl:value-of select="./text()"/>
        </h4>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <p align="right">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:div[@n='2']">
        <div id="{./tei:head/text()}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="./@rend='italic'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:when test="./@rend='bold'">
                <b>
                    <xsl:apply-templates/>
                </b>
            </xsl:when>
        </xsl:choose>     
    </xsl:template>
    
</xsl:stylesheet>