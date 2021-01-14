<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xhtml" indent="yes"/>
    
    <xsl:template match="/">
        <div class="page-header" align="center">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"/>
                    <li data-target="#myCarousel" data-slide-to="1"/>
                </ol>
                <!-- Wrapper for slides -->
                <div class="carousel-inner" role="listbox">
                    <div class="item active">
                        <img src="$app-root/resources/img/front3.jpg" alt="First" width="1200" height="600"/>
                        <div class="carousel-caption">
                            <p style="font-size:80px">
                                Bienvenue au monde de livres!
                            </p>
                        </div>
                    </div>
                    <div class="item">
                        <img src="$app-root/resources/img/front1.jpg" alt="a nice feature picture" width="1200" height="600"/>
                        <div class="carousel-caption">
                            <p style="font-size:80px">
                                Welcome to the world of books!
                            </p>
                        </div>
                    </div>
                </div>
                <!-- Left and right controls -->
                <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                    <!--<span class="sr-only">Previous</span>-->
                </a>
                <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                    <!--<span class="sr-only">Next</span>-->
                </a>
            </div>
            
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