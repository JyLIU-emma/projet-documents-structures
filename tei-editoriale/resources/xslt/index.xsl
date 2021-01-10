<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xhtml" indent="yes"/>
    
    <xsl:template match="/">
        <div class="page-header" align="center">
            <h1>
                Bienvenue au monde de livres!
            </h1>
            <br/>
        </div>
            <xsl:apply-templates select="//partie"/>        
    </xsl:template>
    
    <xsl:template match="partie">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="./@id"/>
            </xsl:attribute>
            <h3 align="center">
                <xsl:value-of select="./titre"/>
            </h3>
            <xsl:for-each select="./para">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:for-each>
            <br/>
        </div>
    </xsl:template>
    
    <xsl:template match="code">
        <code>
            <xsl:value-of select="."/>
        </code>
    </xsl:template>
    
    <xsl:template match="lien">
        <a href="{./text()}">cliquer ici</a>
    </xsl:template>
    
</xsl:stylesheet>