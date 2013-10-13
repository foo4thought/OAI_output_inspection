<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:foo="http://www.openarchives.org/OAI/2.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output encoding="ISO-8859-1" indent="no" method="text" version="1.0"/>
    


    <xsl:template match="//foo:identifier">
		<!-- <xsl:value-of select="concat(substring-after(text(),'/catalog/'),'&#10;')"/> -->
		<xsl:value-of select="concat(text(),'&#10;')"/>
    </xsl:template>
    <xsl:template match="text()"/>  
    
    
</xsl:stylesheet>