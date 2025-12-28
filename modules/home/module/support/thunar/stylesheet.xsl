<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
  <xsl:template match='/expr/attrs/attr[@name="actions"]'>
    <actions>
      <xsl:for-each select='/expr/attrs/attr[@name="actions"]/list/attrs'>
        <action>
          <icon><xsl:value-of select='attr[@name="icon"]/string/@value'/></icon>
          <name><xsl:value-of select='attr[@name="name"]/string/@value'/></name>
          <submenu></submenu>
          <unique-id><xsl:value-of select='attr[@name="unique-id"]/string/@value'/></unique-id>
          <command><xsl:value-of select='attr[@name="command"]/string/@value'/></command>
          <description><xsl:value-of select='attr[@name="description"]/string/@value'/></description>
          <range></range>
          <patterns><xsl:value-of select='attr[@name="patterns"]/string/@value'/></patterns>
          <xsl:if test='attr[@name="directories"]/bool/@value = "true"'><directories/></xsl:if>
          <xsl:if test='attr[@name="startup-notify"]/bool/@value = "true"'><startup-notify/></xsl:if>
          <xsl:if test='attr[@name="other-files"]/bool/@value = "true"'><other-files/></xsl:if>
          <xsl:if test='attr[@name="text-files"]/bool/@value = "true"'><text-files/></xsl:if>
          <xsl:if test='attr[@name="image-files"]/bool/@value = "true"'><image-files/></xsl:if>
          <xsl:if test='attr[@name="audio-files"]/bool/@value = "true"'><audio-files/></xsl:if>
          <xsl:if test='attr[@name="video-files"]/bool/@value = "true"'><video-files/></xsl:if>
        </action>
      </xsl:for-each>
    </actions>
  </xsl:template>
</xsl:stylesheet>
