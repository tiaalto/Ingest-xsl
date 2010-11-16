<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                version="1.0">



        
        

<!--
                **************************************************
                MODS-2-DIM  ("DSpace Intermediate Metadata" ~ Dublin Core variant)
                For a DSpace INGEST Plug-In Crosswalk
                Original author William Reilly wreilly@mit.edu
                Further developed by Timo Aalto (timo.j.aalto@helsinki.fi) 
                for University of Helsinki Pure4 CRIS integration.


     **************************************************
-->


<!--        See also mods.properties in same directory.
        e.g. dc.contributor = <mods:name><mods:namePart>%s</mods:namePart></mods:name> | mods:namePart/text()
-->


                
        <!-- Target XML:
                http://wiki.dspace.org/DspaceIntermediateMetadata
                
                e.g. <dim:dim xmlns:dim="http://www.dspace.org/xmlns/dspace/dim">
                <dim:field mdschema="dc" element="title" lang="en">CSAIL Title - The Urban Question as a Scale Question</dim:field>
                <dim:field mdschema="dc" element="contributor" qualifier="author" lang="en">Brenner, Neil</dim:field>
                ...
        -->


        <!-- Dublin Core schema links:
                        http://dublincore.org/schemas/xmls/qdc/2003/04/02/qualifieddc.xsd
                        http://dublincore.org/schemas/xmls/qdc/2003/04/02/dcterms.xsd  -->

        <xsl:output indent="yes" method="xml"/>


        <xsl:template match="text()">
                <!--
                                Do nothing.

                                Override, effectively, the "Built-In" rule which will
                                process all text inside elements otherwise not matched by any xsl:template.

                                Note: With this in place, be sure to then provide templates or "value-of"
                                statements to actually _get_ the (desired) text out to the result document!
                -->
        </xsl:template>


<!-- **** MODS  mods  [ROOT ELEMENT] ====> DC n/a **** -->
        <xsl:template match="*[local-name()='mods']">
                <!-- fwiw, these match approaches work:
                        <xsl:template match="mods:mods">...
                        <xsl:template match="*[name()='mods:mods']">...
                        <xsl:template match="*[local-name()='mods']">...
                        ...Note that only the latter will work on XML data that does _not_ have
                        namespace prefixes (e.g. <mods><titleInfo>... vs. <mods:mods><mods:titleInfo>...)
                -->
                <xsl:element name="dim:dim">

        <xsl:comment>IMPORTANT NOTE:
                ****************************************************************************************************
                THIS "Dspace Intermediate Metadata" ('DIM') IS **NOT** TO BE USED FOR INTERCHANGE WITH OTHER SYSTEMS.
                ****************************************************************************************************
                It does NOT pretend to be a standard, interoperable representation of Dublin Core.

                It is expressly used for transformation to and from source metadata XML vocabularies into and out of the DSpace object model.

                See http://wiki.dspace.org/DspaceIntermediateMetadata

                For more on Dublin Core standard schemata, see:
                        http://dublincore.org/schemas/xmls/qdc/2003/04/02/qualifieddc.xsd
                        http://dublincore.org/schemas/xmls/qdc/2003/04/02/dcterms.xsd

        </xsl:comment>


<!-- WR_ NAMESPACE NOTE
        Don't "code into" this XSLT the creation of the attribute with the name 'xmlns:dim', to hold the DSpace URI for that namespace.
        NO: <dim:field mdschema="dc" element="title" lang="en" xmlns:dim="http://www.dspace.org/xmlns/dspace/dim">
        Why not?
        Because it's an error (or warning, at least), and because the XML/XSLT tools (parsers, processors) will take care of it for you. ("Ta-da!")
        [fwiw, I tried this on 4 processors: Sablotron, libxslt, Saxon, and Xalan-J (using convenience of TestXSLT http://www.entropy.ch/software/macosx/ ).]
        -->
<!-- WR_ Do Not Use (see above note)
                <xsl:attribute name="xmlns:dim">http://www.dspace.org/xmlns/dspace/dim</xsl:attribute>
        -->
                        <xsl:apply-templates/>
                </xsl:element>
        </xsl:template>
<!-- **** MODS   titleInfo/title ====> DC title **** -->
        <xsl:template match="*[local-name()='titleInfo']/*[local-name()='title']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">title</xsl:attribute>
                        <xsl:attribute name="lang">
                                <xsl:call-template name="langCode">
                                        <xsl:with-param name="la" select="../attribute::lang"></xsl:with-param>
                                </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>


<!-- **** MODS   titleInfo/subTitle ====> DC title ______ (?) **** -->
        <!-- TODO No indication re: 'subTitle' from this page:
                http://cwspace.mit.edu/docs/WorkActivity/Metadata/Crosswalks/MODSmapping2MB.html
                -->
        <!-- (Not anticipated from CSAIL.) -->
        <!-- A subtitle is merely a repeat of dc.title since there does not seem to be a better
        way to describe it in Dublin Core / tiaalto 180510 -->
        <xsl:template match="*[local-name()='titleInfo']/*[local-name()='subTitle']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">title</xsl:attribute>
                        <xsl:attribute name="lang">
                                <xsl:call-template name="langCode">
                                <xsl:with-param name="la" select="../attribute::lang"></xsl:with-param>
                                </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>


<!-- **** MODS   titleInfo/@type="alternative" ====> DC title.alternative **** -->
        <xsl:template match="*[local-name()='titleInfo'][@type='alternative']">
                <!-- TODO Three other attribute values:
                        http://www.loc.gov/standards/mods/mods-outline.html#titleInfo
                        -->
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">title</xsl:attribute>
                        <xsl:attribute name="qualifier">alternative</xsl:attribute>
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>



<!-- **** MODS  name ====> DC  contributor.{role/roleTerm} **** -->
        <xsl:template match="*[local-name()='name']">
                <!--Tiaalto 16/11/10: I'm commenting this out altogether because it creates an unwanted artefact-->
                <!--<xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">contributor</xsl:attribute>
                        <!-\- Important assumption: That the string value used
                                in the MODS role/roleTerm is indeed a DC Qualifier.
                                e.g. contributor.illustrator
                                (Using this assumption, rather than coding in
                                a more controlled vocabulary via xsl:choose etc.)
                                -\->
                        <xsl:attribute name="qualifier"><xsl:value-of select="*[local-name()='role']/*[local-name()='roleTerm']"/></xsl:attribute>

                        <xsl:value-of select="*[local-name()='namePart'][@type='family']"/><xsl:text>, </xsl:text><xsl:value-of select="*[local-name()='namePart'][@type='given']"/>

                       <!-\- This was a temporary solution, works only with the simplest surname, firstname case, (IOW, not well at all)-\->
                        <!-\-<xsl:value-of select="substring-after(*[local-name()='namePart'], ' ')"/>
                        <xsl:text>, </xsl:text><xsl:value-of select="substring-before(*[local-name()='namePart'], ' ')"/>-\->
                </xsl:element>-->
                <!--         **** MODS affiliation ====> DC  contributor (no qualifier), with addition of "Helsingin yliopisto" (UH specific, adjust accordingly) tiaalto 120210**** -->
                <!--if there is an affiliation for a person and he/she is UH-->
                <xsl:if test="*[local-name()='affiliation'][../@authority='local']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">contributor</xsl:attribute>           
                        <xsl:attribute name="lang">fi</xsl:attribute>
                        <xsl:text>Helsingin yliopisto, </xsl:text><xsl:value-of select="*[local-name()='affiliation']"/>               
                </xsl:element>
                </xsl:if>
                
                <!--This is for capturing local authors (ie Pure persons?) into their own DIM field, for integration purposes.
                It assumes that such persons have been encoded in MODS using a authority="local" attribute in v3:name / tiaalto 12.5.2010-->
                
                <xsl:if test="@authority='local'">
                        <xsl:element name="dim:field">
                                <!--this DIM mapping is just for testing and must be changed-->
                                <xsl:attribute name="mdschema">dc</xsl:attribute>
                                <xsl:attribute name="element">contributor</xsl:attribute>
                                <xsl:attribute name="qualifier">uhperson</xsl:attribute>
                                <xsl:value-of select="*[local-name()='namePart'][@type='family']"/><xsl:text>, </xsl:text><xsl:value-of select="*[local-name()='namePart'][@type='given']"/>
                                
                        </xsl:element>              
                      
                </xsl:if>
        </xsl:template>
        
        


        <!-- **** MODS   originInfo/dateValid ====> DC  date.embargoedUntil (UH specific, adjust accordingly) tiaalto 120210 **** -->
        <xsl:template match="*[local-name()='originInfo']/*[local-name()='dateValid']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">date</xsl:attribute>
                        <xsl:attribute name="qualifier">embargoedUntil</xsl:attribute>
                        <xsl:call-template name="FormatDate">                              
                                <xsl:with-param name="DateTime" select="."/>
                        </xsl:call-template>
                </xsl:element>
        </xsl:template>

<!-- **** MODS   originInfo/dateIssued ====> DC  date.issued **** -->
        <xsl:template match="*[local-name()='originInfo']/*[local-name()='dateIssued']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">date</xsl:attribute>
                        <xsl:attribute name="qualifier">issued</xsl:attribute>                       
                        <xsl:value-of select="."/>
                </xsl:element>
        </xsl:template>
        
        <!-- **** MODS   Language/LanguageTerm ====> DC  language.iso **** -->
        <xsl:template match="*[local-name()='language']/*[local-name()='languageTerm']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">language</xsl:attribute>
                        <xsl:attribute name="qualifier">iso</xsl:attribute>                       
                        <xsl:value-of select="."/>
                </xsl:element>        
                
        </xsl:template>


<!-- **** MODS   physicalDescription/extent ====> DC  format.extent **** -->
        <xsl:template match="*[local-name()='physicalDescription']/*[local-name()='extent']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">format</xsl:attribute>                    
                        <xsl:attribute name="qualifier">extent</xsl:attribute>
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:value-of select="."/>
                </xsl:element>
        </xsl:template>

<!-- **** MODS   abstract  ====> DC  description.abstract **** -->
        <xsl:template match="*[local-name()='abstract']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">description</xsl:attribute>                      
                        <xsl:attribute name="qualifier">abstract</xsl:attribute>
                        <xsl:attribute name="lang">
                                <xsl:call-template name="langCode">
                                        <xsl:with-param name="la" select="attribute::lang"></xsl:with-param>
                                </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>


<!-- **** MODS   subject/topic ====> DC  subject **** -->
        <xsl:template match="*[local-name()='subject']/*[local-name()='topic'][not(@xsi:nil)]">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">subject</xsl:attribute>                   
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>


<!-- **** MODS   subject/geographic ====> DC  coverage.spatial **** -->
        <!-- (Not anticipated for CSAIL.) -->
        <xsl:template match="*[local-name()='subject']/*[local-name()='geographic']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">coverage</xsl:attribute>
                        <xsl:attribute name="qualifier">spatial</xsl:attribute>
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>

<!-- **** MODS   subject/temporal ====> DC  coverage.temporal **** -->
        <!-- (Not anticipated for CSAIL.) -->
        <xsl:template match="*[local-name()='subject']/*[local-name()='temporal']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">coverage</xsl:attribute>                                                  
                        <xsl:attribute name="qualifier">temporal</xsl:attribute>
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>


<!-- **** MODS   relatedItem...    **** -->
        <!-- NOTE -
                HAS *TWO* INTERPRETATIONS IN DC:
                1) DC  identifier.citation
                MODS [@type='host'] {/part/text}       ====> DC  identifier.citation
                2) DC  relation.___
                MODS [@type='____'] {/titleInfo/title} ====> DC  relation.{ series | host | other...}
        -->
        <xsl:template match="*[local-name()='relatedItem']">
                <xsl:choose>
                        <!-- 1)  DC  identifier.citation  -->
                        <xsl:when test="./@type='host'  and   *[local-name()='part']/*[local-name()='text']">
                                <xsl:element name="dim:field">
                                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                                        <xsl:attribute name="element">identifier</xsl:attribute>
                                        <xsl:attribute name="qualifier">citation</xsl:attribute>
                                        <xsl:attribute name="lang">en</xsl:attribute>
                                        <xsl:value-of select="normalize-space(*[local-name()='part']/*[local-name()='text'])"/>
                                </xsl:element>
                                <!-- Note: CSAIL Assumption (and for now, generally):
                                        The bibliographic citation is _not_ parsed further,
                                        and one single 'text' element will contain it.
                                        e.g. <text>Journal of Physics, v. 53, no. 9, pp. 34-55, Aug. 15, 2004</text>
                                        -->
                        </xsl:when>
                        <!-- 2)  DC  relation._____  -->
                        <xsl:otherwise>
                                <xsl:element name="dim:field">
                                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                                        <xsl:attribute name="element">relation</xsl:attribute>
                                        <xsl:choose>
                                                <xsl:when test="./@type='series'">
                                                        <xsl:attribute name="qualifier">ispartofseries</xsl:attribute>
                                                </xsl:when>
                                                <xsl:when test="./@type='host'">
                                                        <xsl:attribute name="qualifier">ispartof</xsl:attribute>
                                                </xsl:when>
                                                <!-- 10 more... TODO
http://cwspace.mit.edu/docs/WorkActivity/Metadata/Crosswalks/MODSmapping2MB.html
                                                http://www.loc.gov/standards/mods/mods-outline.html#relatedItem
                                                        -->
                                        </xsl:choose>
                                        
                                        <xsl:value-of select="normalize-space(*[local-name()='titleInfo']/*[local-name()='title'])"/>
                                        <xsl:if test="*[local-name()='titleInfo']/*[local-name()='subTitle']">
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="normalize-space(*[local-name()='titleInfo']/*[local-name()='subTitle'])"/>
                                        </xsl:if>
                                </xsl:element>
                        </xsl:otherwise>
                </xsl:choose>
             
                       <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">identifier</xsl:attribute>
                        <xsl:attribute name="qualifier">
                                <xsl:choose>       
                                        <xsl:when test="*[local-name()='identifier'][@type='issn']">issn</xsl:when>
                                        <xsl:when test="*[local-name()='identifier'][@type='isbn']">isbn</xsl:when>
                                        <xsl:otherwise>other</xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(*[local-name()='identifier'])"/>               
                </xsl:element>
        </xsl:template>
        
<!-- Copyright statement- mods:accessCondition => dc.rights / tiaalto 180510 -->

        <xsl:template match="mods:accessCondition">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">rights</xsl:attribute>
                        <xsl:attribute name="lang">en</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>
        <!-- External links  to dc.relation.uri / tiaalto 170510 -->
        <xsl:template match="*[local-name()='url']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">relation</xsl:attribute>
                        <xsl:attribute name="qualifier">uri</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
                
                
        </xsl:template>
        

<!-- **** MODS   identifier/@type  ====> DC identifier.other  **** -->
       <xsl:template match="*[local-name()='identifier']"> <!-- [@type='series']"> -->
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">identifier</xsl:attribute>
                        <xsl:choose>
                                <xsl:when test="./@type='local'">
                                        <xsl:attribute name="qualifier">other</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="./@type='doi'">
                                        <xsl:attribute name="qualifier">doi</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="./@type='uri'">
                                        <xsl:attribute name="qualifier">uri</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="./@type='isbn'">
                                        <xsl:attribute name="qualifier">isbn</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="./@type='issn'">
                                        <xsl:attribute name="qualifier">issn</xsl:attribute>
                                </xsl:when>
                                <!-- 6 (?) more... TODO
                                        http://cwspace.mit.edu/docs/WorkActivity/Metadata/Crosswalks/MODSmapping2MB.html
                                        http://www.loc.gov/standards/mods/mods-outline.html#identifier
                                        
                                        (but see also MODS relatedItem[@type="host"]/part/text == identifier.citation)
                                -->
                        </xsl:choose>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
                </xsl:template>

<!-- **** MODS   originInfo/publisher  ====> DC  publisher  **** -->
        <xsl:template match="*[local-name()='originInfo']/*[local-name()='publisher']">
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">publisher</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>
        
        <!--Finnish KOTA Publication classification to info:eu-repo/semantics.
                UH/Finland specific, comment out or change accordingly.
                tiaalto 161110-->
        <xsl:template match="*[local-name()='genre'][@type='publicationType']">
                <xsl:element name="dim:field">
                <xsl:attribute name="mdschema">dc</xsl:attribute>
                <xsl:attribute name="element">type</xsl:attribute>
                 <xsl:attribute name="qualifier">uri</xsl:attribute>
                <xsl:call-template name="KOTATypes">
                        <!-- use only the 2 char code, ie. "A2" -->
                        <xsl:with-param name="kota" select="substring(.,1,2)"/>
                </xsl:call-template>
                </xsl:element>
                
                <!-- include also the plain KOTA classification into dc.type -->
                
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">type</xsl:attribute>
                        <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>
        </xsl:template>
        <!-- DCMI type, UH specific add to DSpace registry. Omit if not required -->
        <xsl:template match="*[local-name()='genre'][@type='documentType']">
                <xsl:element name="dim:field">
                <xsl:attribute name="mdschema">dc</xsl:attribute>
                <xsl:attribute name="element">type</xsl:attribute>
                <xsl:attribute name="qualifier">dcmitype</xsl:attribute>
                <xsl:value-of select="normalize-space(.)"/>
                </xsl:element>         
        </xsl:template>
        <!-- Peer review status, mapped to DSpace 1.5+ standard field dc.description.version
                AND as URI to dc.type.uri (Non-standard field). See conversion tables below & adjust accordingly tiaalto 170610 -->
        <xsl:template match="mods:note[@type='version identification']">
                        <xsl:element name="dim:field">
                                <xsl:attribute name="mdschema">dc</xsl:attribute>
                                <xsl:attribute name="element">type</xsl:attribute>
                                <xsl:attribute name="qualifier">uri</xsl:attribute>
                                <xsl:call-template name="peerReviewURI">
                                        <xsl:with-param name="statusURI" select="."></xsl:with-param>
                                </xsl:call-template>
                        </xsl:element>
                <xsl:element name="dim:field">
                        <xsl:attribute name="mdschema">dc</xsl:attribute>
                        <xsl:attribute name="element">description</xsl:attribute>
                        <xsl:attribute name="qualifier">version</xsl:attribute>
                        <xsl:call-template name="peerReview">
                                <xsl:with-param name="status" select="."></xsl:with-param>
                                </xsl:call-template>
                </xsl:element> 
               
                
        </xsl:template>
        
        <!-- KOTA TYPES => SWAP /tiaalto 170610 -->
        <xsl:template name="KOTATypes">
                <xsl:param name="kota"></xsl:param>
                <xsl:choose>
                        <xsl:when test="$kota='A1'">info:eu-repo/semantics/article</xsl:when>
                        <xsl:when test="$kota='A2'">info:eu-repo/semantics/article</xsl:when>
                        <xsl:when test="$kota='A3'">info:eu-repo/semantics/bookPart</xsl:when>
                        <xsl:when test="$kota='A4'">info:eu-repo/semantics/conferencePaper</xsl:when>
                        <xsl:when test="$kota='B1'">info:eu-repo/semantics/article</xsl:when>
                        <xsl:when test="$kota='B2'">info:eu-repo/semantics/bookPart</xsl:when>
                        <xsl:when test="$kota='B3'">info:eu-repo/semantics/conferencePaper</xsl:when>
                        <xsl:when test="$kota='C1'">info:eu-repo/semantics/book</xsl:when>
                        <xsl:when test="$kota='C2'">info:eu-repo/semantics/book</xsl:when>
                        <xsl:when test="$kota='D1'">info:eu-repo/semantics/contributionToPeriodical</xsl:when>
                        <xsl:when test="$kota='D2'">info:eu-repo/semantics/bookPart</xsl:when>
                        <xsl:when test="$kota='D3'">info:eu-repo/semantics/conferencePaper</xsl:when>
                        <xsl:when test="$kota='D4'">info:eu-repo/semantics/workingPaper</xsl:when>
                        <xsl:when test="$kota='D5'">info:eu-repo/semantics/book</xsl:when>
                        <xsl:when test="$kota='E1'">info:eu-repo/semantics/contributionToPeriodical</xsl:when>
                        <xsl:when test="$kota='E2'">info:eu-repo/semantics/book</xsl:when>
                        <xsl:when test="$kota='F1'">info:eu-repo/semantics/other</xsl:when>
                        <xsl:when test="$kota='F2'">info:eu-repo/semantics/other</xsl:when>
                        <xsl:when test="$kota='F3'">info:eu-repo/semantics/other</xsl:when>
                        <xsl:when test="$kota='F4'">info:eu-repo/semantics/other</xsl:when>
                        <xsl:when test="$kota='G1'">info:eu-repo/semantics/bachelorThesis</xsl:when>
                        <xsl:when test="$kota='G2'">info:eu-repo/semantics/masterThesis</xsl:when>
                        <xsl:when test="$kota='G3'">info:eu-repo/semantics/studentThesis</xsl:when>
                        <xsl:when test="$kota='G4'">info:eu-repo/semantics/doctoralThesis</xsl:when>
                        <xsl:when test="$kota='G5'">info:eu-repo/semantics/doctoralThesis</xsl:when>
                        <xsl:when test="$kota='H1'">info:eu-repo/semantics/patent</xsl:when>
                        <xsl:when test="$kota='I1'">info:eu-repo/semantics/other</xsl:when>
                        <xsl:when test="$kota='I2'">info:eu-repo/semantics/other</xsl:when>
                        <xsl:otherwise>info:eu-repo/semantics/other</xsl:otherwise>
                </xsl:choose>
                
        </xsl:template>
        <!-- get the iso-639-2b into iso-639-1 form, here some common languages with fallback to english
             Note that this is only being used for getting the "correct" value to DIM field lang attribute which
             is currently of dubious utility / tiaalto 170610 -->
        <xsl:template name="langCode">
                <xsl:param name="la"></xsl:param>
                <xsl:choose>
                        <xsl:when test="$la='eng'">en</xsl:when>
                        <xsl:when test="$la='fin'">fi</xsl:when>
                        <xsl:when test="$la='swe'">sv</xsl:when>
                        <xsl:when test="$la='fra' or $la='fre'">fr</xsl:when>
                        <xsl:when test="$la='ger' or $la='deu'">de</xsl:when>
                        <xsl:when test="$la='rus'">ru</xsl:when>
                        <xsl:when test="$la='ita'">it</xsl:when>
                        <xsl:when test="$la='lat'">la</xsl:when>
                        <xsl:otherwise>en</xsl:otherwise>
                </xsl:choose>
                
        </xsl:template>
        
        <!-- tiaalto 170610 Templates for peer review status -->
        <xsl:template name="peerReview">
                <xsl:param name="status"></xsl:param>
                <xsl:choose>
                        <!-- the current PURE peer review status options are somewhat lacking and needs review, used here anyway -->
                        <xsl:when test="$status='postprint'">Peer reviewed</xsl:when>
                        <xsl:when test="$status='authorsversion'">Peer reviewed</xsl:when>
                        <xsl:when test="$status='publishersversion'">Peer reviewed</xsl:when>
                        <xsl:otherwise >Non Peer reviewed</xsl:otherwise>        
                </xsl:choose>
        </xsl:template>
        
        <xsl:template name="peerReviewURI">
                <xsl:param name="statusURI"></xsl:param>
                <xsl:choose>
                        <!-- the current PURE peer review status options are somewhat lacking and needs review, used here anyway -->
                        <xsl:when test="$statusURI='postprint'">info:eu-repo/semantics/submittedVersion</xsl:when>
                        <xsl:when test="$statusURI='authorsversion'">info:eu-repo/semantics/acceptedVersion</xsl:when>
                        <xsl:when test="$statusURI='publishersversion'">info:eu-repo/semantics/publishedVersion</xsl:when>
                        <xsl:otherwise >http://purl.org/eprint/status/NonPeerReviewed</xsl:otherwise>        
                </xsl:choose>
        </xsl:template>
        
        <!--tiaalto 12.05.10: This template is for massaging the embargo date into a form understandable by DSpace 
                Not necessarily needed if PURE handles the Embargo?
        source: http://geekswithblogs.net/workdog/archive/2007/02/08/105858.aspx-->

        <xsl:template name="FormatDate">
                
                <xsl:param name="DateTime" />
                
                <!-- new date format 2006-01-14T08:55:22 -->
                
                <xsl:variable name="mo">                        
                        <xsl:value-of select="substring($DateTime,1,2)" />                        
                </xsl:variable>                
                <xsl:variable name="day-temp">                        
                        <xsl:value-of select="substring-after($DateTime,'-')" />                        
                </xsl:variable>               
                <xsl:variable name="day">                       
                        <xsl:value-of select="substring-before($day-temp,'-')" />                      
                </xsl:variable>              
                <xsl:variable name="year-temp">                      
                        <xsl:value-of select="substring-after($day-temp,'-')" />                      
                </xsl:variable>              
                <xsl:variable name="year">                      
                        <xsl:value-of select="substring($year-temp,1,4)" />                      
                </xsl:variable>              
                <xsl:variable name="time">                       
                        <xsl:value-of select="substring-after($year-temp,' ')" />                       
                </xsl:variable>               
                <xsl:variable name="hh">                       
                        <xsl:value-of select="substring($time,1,2)" />                       
                </xsl:variable>               
                <xsl:variable name="mm">                       
                        <xsl:value-of select="substring($time,4,2)" />                       
                </xsl:variable>                
                <xsl:variable name="ss">                       
                        <xsl:value-of select="substring($time,7,2)" />                       
                </xsl:variable>
                <xsl:value-of select="$year"/>           
                <xsl:value-of select="'-'"/>       
                <xsl:if test="(string-length($day) &lt; 2)">                        
                        <xsl:value-of select="0"/>                        
                </xsl:if>                
                <xsl:value-of select="$day"/>                
                <xsl:value-of select="'-'"/>
                <xsl:value-of select="$mo"/>
        </xsl:template>

        
</xsl:stylesheet>

