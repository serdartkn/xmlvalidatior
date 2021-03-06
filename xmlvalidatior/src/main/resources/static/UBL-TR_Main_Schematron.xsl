<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                xmlns:ef="http://www.efatura.gov.tr/package-namespace"
                xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:apr="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
                xmlns:desp="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2"
                xmlns:recp="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:xades="http://uri.etsi.org/01903/v1.3.2#"
                xmlns:hr="http://www.hr-xml.org/3"
                xmlns:oa="http://www.openapplications.org/oagis/9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xsl oa xsi saxon sh ef inv apr desp recp cac cbc ext ds xs xades hr"
                version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. The name or details of 
    this mode may change during 1Q 2007.-->


<!--PHASES-->


<!--PROLOG-->
   <xsl:output xmlns:xs="http://www.w3.org/2001/XMLSchema" method="xml"/>

   <!--KEYS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p"
                          select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p&gt;1">[<xsl:value-of select="$p"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p&gt;1">[<xsl:value-of select="$p"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@sch:schema</xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:choose>
         <xsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
            <xsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA METADATA-->
   <xsl:template match="/">
      <Errors>
         <xsl:apply-templates select="/" mode="M0"/>
         <xsl:apply-templates select="/" mode="M1"/>
         <xsl:apply-templates select="/" mode="M32"/>
         <xsl:apply-templates select="/" mode="M33"/>
         <xsl:apply-templates select="/" mode="M34"/>
      </Errors>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN codes-->
   <xsl:variable name="ProfileIDType"
                 select="',TICARIFATURA,TEMELFATURA,YOLCUBERABERFATURA,IHRACAT,OZELFATURA,KAMU,HKS,'"/>
   <xsl:variable name="ProfileIDTypeEarchive" select="',EARSIVFATURA,'"/>
   <xsl:variable name="ProfileIDTypeGoruntuleme"
                 select="',TICARIFATURA,TEMELFATURA,YOLCUBERABERFATURA,IHRACAT,EARSIVFATURA,OZELFATURA,KAMU,HKS,'"/>
   <xsl:variable name="InvoiceTypeCodeList"
                 select="',SATIS,IADE,TEVKIFAT,ISTISNA,OZELMATRAH,IHRACKAYITLI,SGK,KOMISYONCU,'"/>
   <xsl:variable name="DespatchAdviceTypeCodeList" select="',SEVK,MATBUDAN,'"/>
  <xsl:variable name="ReceiptAdviceTypeCodeList" select="',TEMEL,'"/>
  <!-- <xsl:variable name="ReceiptAdviceTypeCodeList" select="',SEVK,'"/>-->
   <xsl:variable name="EnvelopeType"
                 select="',SENDERENVELOPE,POSTBOXENVELOPE,SYSTEMENVELOPE,USERENVELOPE,'"/>
   <xsl:variable name="ElementType"
                 select="',INVOICE,APPLICATIONRESPONSE,PROCESSUSERACCOUNT,CANCELUSERACCOUNT,DESPATCHADVICE,RECEIPTADVICE,CREDITNOTE,'"/>
   <xsl:variable name="TaxType"
                 select="',0003,0015,0061,0071,0073,0074,0075,0076,0077,1047,1048,4080,4081,9015,9021,9077,8001,8002,8004,8005,8006,8007,8008,9040,0011,4071,4171,0021,0022,9944,'"/>
   <xsl:variable name="WithholdingTaxType"
                 select="',601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,650,'"/>
   <xsl:variable name="WithholdingTaxTypeWithPercent"
                 select="',60140,60290,60370,60450,60550,60690,60790,60890,60970,61090,61190,61290,61390,61450,61570,61650,61770,61870,61970,62070,62190,62290,62350,62420,62530,62620,65090,65050,65070,65020,65030,'"/>
   <xsl:variable name="AccountingCostCodeList"
                 select="',SAGLIK_ECZ,SAGLIK_HAS,SAGLIK_OPT,SAGLIK_MED,ABONELIK,MAL_HIZMET,DIGER,'"/>
   <xsl:variable name="TaxExemptionReasonCodeType"
                 select="',101,102,103,104,105,106,107,108,151,201,202,204,205,206,207,208,209,211,212,213,214,215,216,217,218,219,220,221,223,225,226,227,228,229,230,231,232,234,235,236,237,238,239,240,241,242,250,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,350,351,501,801,802,803,804,805,806,807,808,809,810,811,812,701,702,703,'"/>
   <xsl:variable name="istisnaTaxExemptionReasonCodeType"
                 select="',101,102,103,104,105,106,107,108,201,202,204,205,206,207,208,209,211,212,213,214,215,216,217,218,219,220,221,223,225,226,227,228,229,230,231,232,234,235,236,237,238,239,240,241,242,250,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,350,501,'"/>
   <xsl:variable name="ozelMatrahTaxExemptionReasonCodeType"
                 select="',801,802,803,804,805,806,807,808,809,810,811,812,'"/>
   <xsl:variable name="ihracExemptionReasonCodeType" select="',701,702,703,'"/>
   <xsl:variable name="DeliveryTermCodeList"
                 select="',CFR,CIF,CIP,CPT,DAF,DDP,DDU,DEQ,DES,EXW,FAS,FCA,FOB,DAP,DAT,'"/>
   <xsl:variable name="TransportModeCodeList" select="',0,1,2,3,4,5,6,7,8,9,'"/>
   <xsl:variable name="PartyIdentificationIDType"
                 select="',TCKN,VKN,HIZMETNO,MUSTERINO,TESISATNO,TELEFONNO,DISTRIBUTORNO,TICARETSICILNO,TAPDKNO,BAYINO,ABONENO,SAYACNO,EPDKNO,SUBENO,PASAPORTNO,ARACIKURUMETIKET,ARACIKURUMVKN,CIFTCINO,IMALATCINO,DOSYANO,HASTANO,MERSISNO,URETICINO,GTB_REFNO,GTB_GCB_TESCILNO,GTB_FIILI_IHRACAT_TARIHI,'"/>
   <xsl:variable name="DocumentDescriptionType"
                 select="',AVANS,YEMEK_FIS,E-FATURA,E-FATURA_IRSALIYE,E-ARSIV,E-ARSIV_IRSALIYE,FATURA,OTOPARK,FATURA_TAHSILAT,FATURA_TAHSILAT_KOMISYONLU,'"/>
   <xsl:variable name="ResponseCodeType" select="',KABUL,RED,IADE,S_APR,GUMRUKONAY,'"/>
   <xsl:variable name="AppResponseCodeType"
                 select="',1000,1100,1110,1111,1120,1130,1131,1132,1133,1140,1141,1142,1143,1150,1160,1161,1162,1163,1170,1171,1172,1175,1176,1177,1180,1181,1182,1183,1190,1191,1195,1200,'"/>
   <xsl:variable name="ContactTypeIdentifierType" select="',UNVAN,VKN_TCKN,'"/>
   <xsl:variable name="PackageTypeCodeList"
                 select="',1A,1B,1D,1F,1G,1W,2C,3A,3H,43,44,4A,4B,4C,4D,4F,4G,4H,5H,5L,5M,6H,6P,7A,7B,8A,8B,8C,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AL,AM,AP,AT,AV,B4,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ,CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,DA,DB,DC,DG,DH,DI,DJ,DK,DL,DM,DN,DP,DR,DS,DT,DU,DV,DW,DX,DY,EC,ED,EE,EF,EG,EH,EI,EN,FB,FC,FD,FE,FI,FL,FO,FP,FR,FT,FW,FX,GB,GI,GL,GR,GU,GY,GZ,HA,HB,HC,HG,HN,HR,IA,IB,IC,ID,IE,IF,IG,IH,IK,IL,IN,IZ,JB,JC,JG,JR,JT,JY,KG,KI,LE,LG,LT,LU,LV,LZ,MA,MB,MC,ME,MR,MS,MT,MW,MX,NA,NE,NF,NG,NS,NT,NU,NV,OA,OB,OC,OD,OE,OF,OK,OT,OU,P2,PA,PB,PC,PD,PE,PF,PG,PH,PI,PJ,PK,PL,PN,PO,PP,PR,PT,PU,PV,PX,PY,PZ,QA,QB,QC,QD,QF,QG,QH,QJ,QK,QL,QM,QN,QP,QQ,QR,QS,RD,RG,RJ,RK,RL,RO,RT,RZ,SA,SB,SC,SD,SE,SH,SI,SK,SL,SM,SO,SP,SS,ST,SU,SV,SW,SX,SY,SZ,T1,TB,TC,TD,TE,TG,TI,TK,TL,TN,TO,TR,TS,TT,TU,TV,TW,TY,TZ,UC,UN,VA,VG,VI,VK,VL,VO,VP,VQ,VN,VR,VS,VY,WA,WB,WC,WD,WF,WG,WH,WJ,WK,WL,WM,WN,WP,WQ,WR,WS,WT,WU,WV,WW,WX,WY,WZ,XA,XB,XC,XD,XF,XG,XH,XJ,XK,YA,YB,YC,YD,YF,YG,YH,YJ,YK,YL,YM,YN,YP,YQ,YR,YS,YT,YV,YW,YX,YY,YZ,ZA,ZB,ZC,ZD,ZF,ZG,ZH,ZJ,ZK,ZL,ZM,ZN,ZP,ZQ,ZR,ZS,ZT,ZU,ZV,ZW,ZX,ZY,ZZ,'"/>
   <xsl:variable name="CurrencyCodeList"
                 select="',AED,AFN,ALL,AMD,ANG,AOA,ARS,AUD,AWG,AZN,BAM,BBD,BDT,BGN,BHD,BIF,BMD,BND,BOB,BOV,BRL,BSD,BTN,BWP,BYN,BZD,CAD,CDF,CHE,CHF,CHW,CLF,CLP,CNY,COP,COU,CRC,CUC,CUP,CVE,CZK,DJF,DKK,DOP,DZD,EEK,EGP,ERN,ETB,EUR,FJD,FKP,GBP,GEL,GHS,GIP,GMD,GNF,GTQ,GWP,GYD,HKD,HNL,HRK,HTG,HUF,IDR,ILS,INR,IQD,IRR,ISK,JMD,JOD,JPY,KES,KGS,KHR,KMF,KPW,KRW,KWD,KYD,KZT,LAK,LBP,LKR,LRD,LSL,LTL,LVL,LYD,MAD,MAD,MDL,MGA,MKD,MMK,MNT,MOP,MRO,MUR,MVR,MWK,MXN,MXV,MYR,MZN,NAD,NGN,NIO,NOK,NPR,NZD,OMR,PAB,PEN,PGK,PHP,PKR,PLN,PYG,QAR,RON,RSD,RUB,RWF,SAR,SBD,SCR,SDG,SEK,SGD,SHP,SLL,SOS,SRD,STD,SVC,SYP,SZL,THB,TJS,TMT,TND,TOP,TRY,TTD,TWD,TZS,UAH,UGX,USD,USN,USS,UYI,UYU,UZS,VEF,VND,VUV,WST,XAF,XAG,XAU,XBA,XBB,XBC,XBD,XCD,XDR,XFU,XOF,XPD,XPF,XPF,XPF,XPT,XTS,XXX,YER,ZAR,ZMK,ZWL,'"/>
   <xsl:variable name="CountryCodeList"
                 select="',AF,AX,AL,DZ,AS,AD,AO,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BA,BW,BV,BR,IO,BN,BG,BF,BI,KH,CM,CA,CV,KY,CF,TD,CL,CW,CN,CX,CC,CO,KM,CG,CD,CK,CR,CI,HR,CU,CY,CZ,DK,DJ,DM,DO,EC,EG,SV,GQ,ER,EE,ET,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,GG,GN,GW,GY,HT,HM,VA,HN,HK,HU,IS,IN,ID,IR,IQ,IE,IM,IL,IT,JM,JP,JE,JO,KZ,KE,KI,KP,KR,KW,KG,LA,LV,LB,LS,LR,LY,LI,LT,LU,MO,MK,MG,MW,MY,MV,ML,MT,MH,MQ,MR,MU,YT,MX,FM,MD,MC,MN,ME,MS,MA,MZ,MM,NA,NR,NP,NL,AN,NC,NZ,NI,NE,NG,NU,NF,MP,NO,OM,PK,PW,PS,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,RE,RO,RU,RW,BL,SH,KN,LC,MF,PM,VC,WS,SM,ST,SA,SN,RS,SC,SL,SG,SK,SI,SB,SO,ZA,GS,ES,LK,SD,SR,SJ,SZ,SE,CH,SY,TW,TJ,TZ,TH,TL,TG,TK,TO,TT,TN,TR,TM,TC,TV,UG,UA,AE,GB,US,UM,UY,UZ,VU,VE,VN,VG,VI,WF,EH,YE,ZM,ZW,CTR,XK,BQ,SX,ZZ,XZ,SS,'"/>
   <xsl:variable name="UserType" select="',1,2,11,12,21,22,31,32,41,42,'"/>
   <xsl:variable name="ReservedAliases"
                 select="',usergb,GIB,archive,earchive,archive_earchive,eticket,edespatch,esevoucher,epreceipt,esevoucher_archive,epreceipt_archive,erevenue,'"/>
   <xsl:variable name="UserEnvelopeAliases"
                 select="',usergb,archive,earchive,archive_earchive,eticket,edespatch,archive_edespatch,esevoucher,epreceipt,esevoucher_archive,epreceipt_archive,erevenue,'"/>
   <xsl:variable name="UnitCodeList"
                 select="',05,06,08,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,43,44,45,46,47,48,53,54,56,57,58,59,60,61,62,63,64,66,69,71,72,73,74,76,77,78,80,81,84,2,85,87,89,90,91,92,93,94,95,96,97,98,1A,1B,1C,1D,1E,1F,1G,1H,1I,1J,1K,1L,1M,1X,2A,2B,2C,2G,2H,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2V,2W,2X,2Y,2Z,3B,3C,3E,3G,3H,3I,4A,4B,4C,4E,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5C,5E,5F,5G,5H,5I,5J,5K,5P,5Q,A1,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A50,A51,A52,A53,A54,A55,A56,A57,A58,A59,3.9,A6,A60,A61,A62,A63,A64,A65,A66,A67,A68,A69,A7,A70,A71,A73,A74,A75,A76,A77,A78,A79,A8,A80,A81,A82,A83,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,A99,AA,AB,ACR,ACT,AD,AE,AH,AI,AJ,AK,AL,AM,AMH,AMP,ANN,2,AP,APZ,AQ,AR,ARE,AS,ASM,ASU,ATM,ATT,AV,AW,AY,AZ,B0,B1,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B2,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B30,B31,B32,B33,B34,B35,B36,B37,B38,B39,B4,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,B5,B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B6,B60,B61,B62,B63,B64,B65,B66,B67,B68,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B80,B81,B82,B83,B84,B85,B86,B87,B88,B89,B9,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BD,BE,BFT,BG,BH,BHP,BIL,BJ,BK,BL,BLD,BLL,BO,BP,BQL,BR,BT,BTU,BUA,BUI,BW,BX,BZ,C0,C1,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C2,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C37,C38,C39,C4,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C5,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C6,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C74,C75,C76,C77,C78,C79,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C98,C99,CA,CCT,CDL,CEL,CEN,CG,CGM,CH,CJ,CK,CKG,CL,CLF,CLT,CMK,CMQ,CMT,cm,CNP,CNT,CO,COU,CQ,CR,CS,CT,CTG,CTM,CTN,CU,CUR,CV,CWA,CWI,CY,CZ,D03,D04,D1,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31,D32,D33,D34,D35,D36,D37,D38,D39,D40,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D64,D65,D66,D67,D68,D69,D7,D70,D71,D72,D73,D74,D75,D76,D77,D78,D79,D8,D80,D81,D82,D83,D85,D86,D87,D88,D89,D9,dyn/cm??,D90,D91,D92,D93,D94,D95,D96,D97,D98,D99,DAA,DAD,DAY,DB,DC,DD,DE,DEC,DG,DI,DJ,DLT,DMA,DMK,DMO,DMQ,DMT,DN,DPC,DPR,DPT,DQ,DR,DRA,DRI,DRL,DRM,DS,DT,DTN,dt or dtn,DU,DWT,DX,DY,DZN,DZP,E01,E07,E08,E09,E10,E11,E12,E14,E15,E16,E17,E18,E19,E2,E20,E21,E22,E23,E25,E27,E28,E3,E30,E31,E32,E33,E34,E35,E36,E37,E38,E39,E4,E40,E41,E42,E43,E44,E45,E46,E47,E48,E49,E5,E50,E51,E52,E53,E54,E55,E56,E57,E58,E59,E60,E61,E62,E63,E64,E65,E66,E67,E68,E69,E70,E71,E72,E73,E74,E75,E76,E77,E78,E79,E80,E81,E82,E83,E84,E85,E86,E87,E88,E89,E90,E91,E92,E93,E94,E95,E96,E97,E98,E99,EA,EB,EC,EP,EQ,EV,F01,F02,F03,F04,F05,F06,F07,F08,F1,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56,F57,F58,F59,F60,F61,F62,F63,F64,F65,F66,F67,F68,F69,F70,F71,F72,F73,F74,F75,F76,F77,F78,F79,F80,F81,F82,F83,F84,F85,F86,F87,F88,F89,F9,F90,F91,F92,F93,F94,F95,F96,F97,F98,F99,FAH,FAR,FB,FBM,FC,FD,FE,FF,FG,FH,FIT,FL,FM,FOT,FP,FR,FS,FTK,FTQ,G01,G04,G05,G06,G08,G09,G10,G11,G12,G13,G14,G15,G16,G17,G18,G19,G2,G20,G21,G23,G24,G25,G26,G27,G28,G29,G3,G30,G31,G32,G33,G34,G35,G36,G37,G38,G39,G40,G41,G42,G43,G44,G45,G46,G47,G48,G49,G50,G51,G52,G53,G54,G55,G56,G57,G58,G59,G60,G61,G62,G63,G64,G65,G66,G67,G68,G69,G7,G70,G71,G72,G73,G74,G75,G76,G77,G78,G79,G80,G81,G82,G83,G84,G85,G86,G87,G88,G89,G90,G91,G92,G93,G94,G95,G96,G97,G98,G99,GB,GBQ,GC,GD,GDW,GE,GF,GFI,GGR,GH,GIA,GIC,GII,GIP,GJ,GK,GL,GLD,GLI,GLL,GM,GN,GO,GP,GQ,GRM,GRN,GRO,GRT,GT,3.1,GV,GW,GWH,GY,GZ,H03,H04,H05,H06,H07,H08,H09,H1,H10,H11,H12,H13,H14,H15,H16,H18,H19,H2,H20,H21,H22,H23,H24,H25,H26,H27,H28,H29,H30,H31,H32,H33,H34,H35,H36,H37,H38,H39,H40,H41,H42,H43,H44,H45,H46,H47,H48,H49,H50,H51,H52,H53,H54,H55,H56,H57,H58,H59,H60,H61,H62,H63,H64,H65,H66,H67,H68,H69,H70,H71,H72,H73,H74,H75,H76,H77,H78,H79,2,H80,H81,H82,H83,H84,H85,H87,H88,H89,H90,H91,H92,H93,H94,H95,H96,H98,H99,HA,HAR,HBA,HBX,HC,HD,HDW,HE,HEA,HF,HGM,HH,HI,HIU,HJ,HK,HKM,HL,HLT,HM,HMQ,HMT,HN,HO,HP,HPA,HS,HT,HTZ,HUR,HY,IA,IC,IE,IF,II,IL,IM,INH,INK,INQ,IP,ISD,IT,IU,IV,J10,J12,J13,J14,J15,J16,J17,J18,J19,J2,J20,J21,J22,J23,J24,J25,J26,J27,J28,J29,J30,J31,J32,J33,J34,J35,J36,J38,J39,J40,J41,J42,J43,J44,J45,J46,J47,J48,J49,J50,J51,J52,J53,J54,J55,J56,J57,J58,J59,J60,J61,J62,J63,J64,J65,J66,J67,J68,J69,J70,J71,J72,J73,J74,J75,J76,J78,J79,J81,J82,J83,J84,J85,J87,J89,J90,J91,J92,J93,J94,J95,J96,J97,J98,J99,JB,JE,JG,JK,JM,JNT,JO,JOU,JPS,JR,JWL,K1,K10,K11,K12,K13,K14,K15,K16,K17,K18,K19,K2,K20,K21,K22,K23,K24,K25,K26,K27,K28,K3,K30,K31,K32,K33,K34,K35,K36,K37,K38,K39,K40,K41,K42,K43,K45,K46,K47,K48,K49,K5,K50,K51,K52,K53,K54,K55,K58,K59,K6,K60,K61,K62,K63,K64,K65,K66,K67,K68,K69,K70,K71,K73,K74,K75,K76,K77,K78,K79,K80,K81,K82,K83,K84,K85,K86,K87,K88,K89,K90,K91,K92,K93,K94,K95,K96,K97,K98,K99,KA,KAT,KB,KBA,KCC,KD,KDW,KEL,KF,KG,KGM,KGS,KHY,KHZ,KI,KIC,KIP,KJ,KJO,KL,KLK,KLX,KMA,KMH,KMK,KMQ,KMT,KNI,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KS,KSD,KSH,KT,KTM,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWO,KWT,KX,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L2,L20,L21,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54,L55,L56,L57,L58,L59,L60,L61,L62,L63,L64,L65,L66,L67,L68,L69,L70,L71,L72,L73,L74,L75,L76,L77,L78,L79,L80,L81,L82,L83,L84,L85,L86,L87,L88,L89,L90,L91,L92,L93,L94,L95,L96,L98,L99,LA,LAC,LBR,LBT,LC,LD,LE,LEF,LF,LH,LI,LJ,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUB,LUM,LUX,LX,LY,M0,M1,M10,M11,M12,M13,M14,M15,M16,M17,M18,M19,M20,M21,M22,M23,M24,M25,M26,M27,M29,M30,M31,M32,M33,M34,M35,M36,M37,M38,M39,M4,M40,M41,M42,M43,M44,M45,M46,M47,M48,M49,M5,M50,M51,2,M52,M53,M55,M56,M57,M58,M59,M60,M61,M62,M63,M64,M65,M66,M67,M68,M69,M7,M70,M71,M72,M73,M74,M75,M76,M77,M78,M79,M80,M81,M82,M83,M84,M85,M86,M87,M88,M89,M9,M90,M91,M92,M93,M94,M95,M96,M97,M98,M99,MA,MAH,MAL,MAM,MAR,MAW,MBE,MBF,MBR,MC,MCU,MD,MF,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MK,MLD,MLT,MMK,MMQ,MMT,MND,MON,MPA,MQ,MQH,MQS,MSK,MT,MTK,MTQ,MTR,MTS,MV,MVA,MWH,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N2,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N3,N30,N31,N32,N33,N34,N35,N36,N37,N38,N39,N40,N41,N42,N43,N44,N45,N46,N47,N48,N49,N50,N51,N52,N53,N54,N55,N56,N57,N58,N59,N60,N61,N62,N63,N64,N65,N66,N67,N68,N69,N70,N71,N72,N73,N74,N75,N76,N77,N78,N79,N80,N81,N82,N83,N84,N85,N86,N87,N88,N89,N90,N91,N92,N93,N94,N95,N96,N97,N98,N99,NA,NAR,NB,NBB,NC,NCL,ND,NE,NEW,NF,NG,NH,NI,NIL,NIU,NJ,NL,NMI,NMP,NN,NPL,NPR,NPT,NQ,NR,NRL,NT,NTT,NU,NV,NX,3.7,NY,OA,ODE,OHM,ON,ONZ,OP,OT,OZ,OZA,OZI,P0,P1,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P2,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P3,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P4,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P5,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P6,P60,P61,P62,P63,P64,P65,P66,P67,P68,P69,P7,P70,P71,P72,P73,P74,P75,P76,P77,P78,P79,P8,P80,P81,P82,P83,P84,P85,P86,P87,P88,P89,P9,P90,P91,P92,P93,P94,P95,P96,P97,P98,P99,PA,PAL,PB,PD,PE,PF,PFL,PG,PGL,PI,PK,3.3,PL,PLA,PM,PN,PO,PQ,PR,PS,PT,PTD,PTI,PTL,PU,PV,PW,PY,PZ,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q3,QA,QAN,QB,QD,QH,QK,QR,QT,QTD,QTI,QTL,QTR,R1,R4,R9,RA,RD,RG,RH,RK,RL,RM,RN,RO,ROM,RP,RPM,RPS,RS,RT,RU,S3,S4,S5,S6,S7,S8,SA,SAN,SCO,SCR,SD,SE,SEC,SET,SG,SHT,SIE,SK,SL,SMI,SN,SO,SP,SQ,SQR,SR,SS,SST,ST,STC,STI,STK,STL,STN,STW,SV,SW,SX,SYR,T0,T1,T3,T4,T5,T6,T7,T8,TA,TAH,TAN,TC,TD,TE,TF,TI,TIC,TIP,TJ,TK,TKM,TL,TMS,TN,TNE,TP,TPR,TQ,TQD,TR,TRL,TS,TSD,TSH,TST,TT,TTS,TU,TV,TW,TY,U1,U2,UA,UB,UC,UD,UE,UF,UH,UM,VA,VI,VLT,VP,VQ,VS,W2,W4,WA,WB,WCD,WE,WEB,WEE,WG,WH,WHR,WI,WM,WR,WSD,3.5,WTT,WW,X1,YDK,YDQ,YL,YRD,YT,Z1,Z11,Z2,Z3,Z4,Z5,Z6,Z8,ZP,ZZ,SM3,NM3,PTN,'"/>
   <xsl:variable name="PaymentMeansCodeTypeList"
                 select="',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,60,61,62,63,64,65,66,67,70,74,75,76,77,78,91,92,93,94,95,96,97,ZZZ,'"/>
   <xsl:variable name="ChannelCodeList"
                 select="',AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,CA,EI,EM,EX,FT,FX,GM,IE,IM,MA,PB,PS,SW,TE,TG,TL,TM,TT,TX,XF,XG,XH,XI,XJ,'"/>
   <xsl:variable name="MimeCodeList"
                 select="',application/CSTAdata+xml,application/EDI-Consent,application/EDI-X12,application/EDIFACT,application/activemessage,application/andrew-inset,application/applefile,application/atomicmail,application/batch-SMTP,application/beep+xml,application/cals-1840,application/cnrp+xml,application/commonground,application/cpl+xml,application/csta+xml,application/cybercash,application/dca-rft,application/dec-dx,application/dialog-info+xml,application/dicom,application/dns,application/dvcs,application/epp+xml,application/eshop,application/fits,application/font-tdpfr,application/http,application/hyperstudio,application/iges,application/im-iscomposing+xml,application/index,application/index.cmd,application/index.obj,application/index.response,application/index.vnd,application/iotp,application/ipp,application/isup,application/kpml-request+xml,application/kpml-response+xml,application/mac-binhex40,application/macwriteii,application/marc,application/mathematica,application/mbox,application/mikey,application/mpeg4-generic,application/msword,application/news-message-id,application/news-transmission,application/ocsp-request,application/ocsp-response,application/octet-stream,application/oda,application/ogg,application/parityfec,application/pdf,application/pgp-encrypted,application/pgp-keys,application/pgp-signature,application/pidf+xml,application/pkcs10,application/pkcs7-mime,application/pkcs7-signature,application/pkix-cert,application/pkix-crl,application/pkix-pkipath,application/pkixcmp,application/postscript,application/prs.alvestrand.titrax-sheet,application/prs.cww,application/prs.nprend,application/prs.plucker,application/qsig,application/rdf+xml,application/reginfo+xml,application/remote-printing,application/resource-lists+xml,application/riscos,application/rls-services+xml,application/rtf,application/samlassertion+xml,application/samlmetadata+xml,application/sbml+xml,application/sdp,application/set-payment,application/set-payment-initiation,application/set-registration,application/set-registration-initiation,application/sgml,application/sgml-open-catalog,application/shf+xml,application/sieve,application/simple-filter+xml,application/simple-message-summary,application/slate,application/soap+xml,application/spirits-event+xml,application/timestamp-query,application/timestamp-reply,application/tve-trigger,application/vemmi,application/vnd.3M.Post-it-Notes,application/vnd.3gpp.pic-bw-large,application/vnd.3gpp.pic-bw-small,application/vnd.3gpp.pic-bw-var,application/vnd.3gpp.sms,application/vnd.FloGraphIt,application/vnd.Kinar,application/vnd.Mobius.DAF,application/vnd.Mobius.DIS,application/vnd.Mobius.MBK,application/vnd.Mobius.MQY,application/vnd.Mobius.MSL,application/vnd.Mobius.PLC,application/vnd.Mobius.TXF,application/vnd.Quark.QuarkXPress,application/vnd.RenLearn.rlprint,application/vnd.accpac.simply.aso,application/vnd.accpac.simply.imp,application/vnd.acucobol,application/vnd.acucorp,application/vnd.adobe.xfdf,application/vnd.aether.imp,application/vnd.amiga.ami,application/vnd.anser-web-certificate-issue-initiation,application/vnd.anser-web-funds-transfer-initiation,application/vnd.audiograph,application/vnd.blueice.multipass,application/vnd.bmi,application/vnd.businessobjects,application/vnd.canon-cpdl,application/vnd.canon-lips,application/vnd.cinderella,application/vnd.claymore,application/vnd.commerce-battelle,application/vnd.commonspace,application/vnd.contact.cmsg,application/vnd.cosmocaller,application/vnd.criticaltools.wbs+xml,application/vnd.ctc-posml,application/vnd.cups-postscript,application/vnd.cups-raster,application/vnd.cups-raw,application/vnd.curl,application/vnd.cybank,application/vnd.data-vision.rdz,application/vnd.dna,application/vnd.dpgraph,application/vnd.dreamfactory,application/vnd.dxr,application/vnd.ecdis-update,application/vnd.ecowin.chart,application/vnd.ecowin.filerequest,application/vnd.ecowin.fileupdate,application/vnd.ecowin.series,application/vnd.ecowin.seriesrequest,application/vnd.ecowin.seriesupdate,application/vnd.enliven,application/vnd.epson.esf,application/vnd.epson.msf,application/vnd.epson.quickanime,application/vnd.epson.salt,application/vnd.epson.ssf,application/vnd.ericsson.quickcall,application/vnd.eudora.data,application/vnd.fdf,application/vnd.ffsns,application/vnd.fints,application/vnd.framemaker,application/vnd.fsc.weblaunch,application/vnd.fujitsu.oasys,application/vnd.fujitsu.oasys2,application/vnd.fujitsu.oasys3,application/vnd.fujitsu.oasysgp,application/vnd.fujitsu.oasysprs,application/vnd.fujixerox.ddd,application/vnd.fujixerox.docuworks,application/vnd.fujixerox.docuworks.binder,application/vnd.fut-misnet,application/vnd.genomatix.tuxedo,application/vnd.grafeq,application/vnd.groove-account,application/vnd.groove-help,application/vnd.groove-identity-message,application/vnd.groove-injector,application/vnd.groove-tool-message,application/vnd.groove-tool-template,application/vnd.groove-vcard,application/vnd.hbci,application/vnd.hcl-bireports,application/vnd.hhe.lesson-player,application/vnd.hp-HPGL,application/vnd.hp-PCL,application/vnd.hp-PCLXL,application/vnd.hp-hpid,application/vnd.hp-hps,application/vnd.httphone,application/vnd.hzn-3d-crossword,application/vnd.ibm.MiniPay,application/vnd.ibm.afplinedata,application/vnd.ibm.electronic-media,application/vnd.ibm.modcap,application/vnd.ibm.rights-management,application/vnd.ibm.secure-container,application/vnd.informix-visionary,application/vnd.intercon.formnet,application/vnd.intertrust.digibox,application/vnd.intertrust.nncp,application/vnd.intu.qbo,application/vnd.intu.qfx,application/vnd.ipunplugged.rcprofile,application/vnd.irepository.package+xml,application/vnd.is-xpr,application/vnd.japannet-directory-service,application/vnd.japannet-jpnstore-wakeup,application/vnd.japannet-payment-wakeup,application/vnd.japannet-registration,application/vnd.japannet-registration-wakeup,application/vnd.japannet-setstore-wakeup,application/vnd.japannet-verification,application/vnd.japannet-verification-wakeup,application/vnd.jisp,application/vnd.kde.karbon,application/vnd.kde.kchart,application/vnd.kde.kformula,application/vnd.kde.kivio,application/vnd.kde.kontour,application/vnd.kde.kpresenter,application/vnd.kde.kspread,application/vnd.kde.kword,application/vnd.kenameaapp,application/vnd.kidspiration,application/vnd.koan,application/vnd.liberty-request+xml,application/vnd.llamagraphics.life-balance.desktop,application/vnd.llamagraphics.life-balance.exchange+xml,application/vnd.lotus-1-2-3,application/vnd.lotus-approach,application/vnd.lotus-freelance,application/vnd.lotus-notes,application/vnd.lotus-organizer,application/vnd.lotus-screencam,application/vnd.lotus-wordpro,application/vnd.mcd,application/vnd.mediastation.cdkey,application/vnd.meridian-slingshot,application/vnd.mfmp,application/vnd.micrografx.flo,application/vnd.micrografx.igx,application/vnd.mif,application/vnd.minisoft-hp3000-save,application/vnd.mitsubishi.misty-guard.trustweb,application/vnd.mophun.application,application/vnd.mophun.certificate,application/vnd.motorola.flexsuite,application/vnd.motorola.flexsuite.adsi,application/vnd.motorola.flexsuite.fis,application/vnd.motorola.flexsuite.gotap,application/vnd.motorola.flexsuite.kmr,application/vnd.motorola.flexsuite.ttc,application/vnd.motorola.flexsuite.wem,application/vnd.mozilla.xul+xml,application/vnd.ms-artgalry,application/vnd.ms-asf,application/vnd.ms-excel,application/vnd.ms-lrm,application/vnd.ms-powerpoint,application/vnd.ms-project,application/vnd.ms-tnef,application/vnd.ms-works,application/vnd.ms-wpl,application/vnd.mseq,application/vnd.msign,application/vnd.music-niff,application/vnd.musician,application/vnd.nervana,application/vnd.netfpx,application/vnd.noblenet-directory,application/vnd.noblenet-sealer,application/vnd.noblenet-web,application/vnd.nokia.landmark+wbxml,application/vnd.nokia.landmark+xml,application/vnd.nokia.landmarkcollection+xml,application/vnd.nokia.radio-preset,application/vnd.nokia.radio-presets,application/vnd.novadigm.EDM,application/vnd.novadigm.EDX,application/vnd.novadigm.EXT,application/vnd.obn,application/vnd.omads-email+xml,application/vnd.omads-file+xml,application/vnd.omads-folder+xml,application/vnd.osa.netdeploy,application/vnd.palm,application/vnd.paos.xml,application/vnd.pg.format,application/vnd.pg.osasli,application/vnd.picsel,application/vnd.powerbuilder6,application/vnd.powerbuilder6-s,application/vnd.powerbuilder7,application/vnd.powerbuilder7-s,application/vnd.powerbuilder75,application/vnd.powerbuilder75-s,application/vnd.previewsystems.box,application/vnd.publishare-delta-tree,application/vnd.pvi.ptid1,application/vnd.pwg-multiplexed,application/vnd.pwg-xhtml-print+xml,application/vnd.rapid,application/vnd.s3sms,application/vnd.sealed.doc,application/vnd.sealed.eml,application/vnd.sealed.mht,application/vnd.sealed.net,application/vnd.sealed.ppt,application/vnd.sealed.xls,application/vnd.sealedmedia.softseal.html,application/vnd.sealedmedia.softseal.pdf,application/vnd.seemail,application/vnd.shana.informed.formdata,application/vnd.shana.informed.formtemplate,application/vnd.shana.informed.interchange,application/vnd.shana.informed.package,application/vnd.smaf,application/vnd.sss-cod,application/vnd.sss-dtf,application/vnd.sss-ntf,application/vnd.street-stream,application/vnd.sus-calendar,application/vnd.svd,application/vnd.swiftview-ics,application/vnd.syncml.+xml,application/vnd.syncml.ds.notification,application/vnd.triscape.mxs,application/vnd.trueapp,application/vnd.truedoc,application/vnd.ufdl,application/vnd.uiq.theme,application/vnd.uplanet.alert,application/vnd.uplanet.alert-wbxml,application/vnd.uplanet.bearer-choice,application/vnd.uplanet.bearer-choice-wbxml,application/vnd.uplanet.cacheop,application/vnd.uplanet.cacheop-wbxml,application/vnd.uplanet.channel,application/vnd.uplanet.channel-wbxml,application/vnd.uplanet.list,application/vnd.uplanet.list-wbxml,application/vnd.uplanet.listcmd,application/vnd.uplanet.listcmd-wbxml,application/vnd.uplanet.signal,application/vnd.vcx,application/vnd.vectorworks,application/vnd.vidsoft.vidconference,application/vnd.visio,application/vnd.visionary,application/vnd.vividence.scriptfile,application/vnd.vsf,application/vnd.wap.sic,application/vnd.wap.slc,application/vnd.wap.wbxml,application/vnd.wap.wmlc,application/vnd.wap.wmlscriptc,application/vnd.webturbo,application/vnd.wordperfect,application/vnd.wqd,application/vnd.wrq-hp3000-labelled,application/vnd.wt.stf,application/vnd.wv.csp+wbxml,application/vnd.wv.csp+xml,application/vnd.wv.ssp+xml,application/vnd.xara,application/vnd.xfdl,application/vnd.yamaha.hv-dic,application/vnd.yamaha.hv-script,application/vnd.yamaha.hv-voice,application/vnd.yamaha.smaf-audio,application/vnd.yamaha.smaf-phrase,application/vnd.yellowriver-custom-menu,application/watcherinfo+xml,application/whoispp-query,application/whoispp-response,application/wita,application/wordperfect5.1,application/x400-bp,application/xhtml+xml,application/xml,application/xml-dtd,application/xml-external-parsed-entity,application/xmpp+xml,application/xop+xml,application/zip,audio/32kadpcm,audio/3gpp,audio/AMR,audio/AMR-WB,audio/BV16,audio/BV32,audio/CN,audio/DAT12,audio/DVI4,audio/EVRC,audio/EVRC-QCP,audio/EVRC0,audio/G.722.1,audio/G722,audio/G723,audio/G726-16,audio/G726-24,audio/G726-32,audio/G726-40,audio/G728,audio/G729,audio/G729D,audio/G729E,audio/GSM,audio/GSM-EFR,audio/L16,audio/L20,audio/L24,audio/L8,audio/LPC,audio/MP4A-LATM,audio/MPA,audio/PCMA,audio/PCMU,audio/QCELP,audio/RED,audio/SMV,audio/SMV-QCP,audio/SMV0,audio/VDVI,audio/basic,audio/clearmode,audio/dsr-es201108,audio/dsr-es202050,audio/dsr-es202211,audio/dsr-es202212,audio/iLBC,audio/mpa-robust,audio/mpeg,audio/mpeg4-generic,audio/parityfec,audio/prs.sid,audio/telephone-event,audio/tone,audio/vnd.3gpp.iufp,audio/vnd.audiokoz,audio/vnd.cisco.nse,audio/vnd.cns.anp1,audio/vnd.cns.inf1,audio/vnd.digital-winds,audio/vnd.everad.plj,audio/vnd.lucent.voice,audio/vnd.nokia.mobile-xmf,audio/vnd.nortel.vbk,audio/vnd.nuera.ecelp4800,audio/vnd.nuera.ecelp7470,audio/vnd.nuera.ecelp9600,audio/vnd.octel.sbc,audio/vnd.qcelp,audio/vnd.rhetorex.32kadpcm,audio/vnd.sealedmedia.softseal.mpeg,audio/vnd.vmx.cvsd,image/cgm,image/fits,image/g3fax,image/gif,image/ief,image/jp2,image/jpeg,image/jpm,image/jpx,image/naplps,image/png,image/prs.btif,image/prs.pti,image/t38,image/tiff,image/tiff-fx,image/vnd.cns.inf2,image/vnd.djvu,image/vnd.dwg,image/vnd.dxf,image/vnd.fastbidsheet,image/vnd.fpx,image/vnd.fst,image/vnd.fujixerox.edmics-mmr,image/vnd.fujixerox.edmics-rlc,image/vnd.globalgraphics.pgb,image/vnd.microsoft.icon,image/vnd.mix,image/vnd.ms-modi,image/vnd.net-fpx,image/vnd.sealed.png,image/vnd.sealedmedia.softseal.gif,image/vnd.sealedmedia.softseal.jpg,image/vnd.svf,image/vnd.wap.wbmp,image/vnd.xiff,message/CPIM,message/delivery-status,message/disposition-notification,message/external-body,message/http,message/news,message/partial,message/rfc822,message/s-http,message/sip,message/sipfrag,message/tracking-status,model/iges,model/mesh,model/vnd.dwf,model/vnd.flatland.3dml,model/vnd.gdl,model/vnd.gs-gdl,model/vnd.gtw,model/vnd.mts,model/vnd.parasolid.transmit.binary,model/vnd.parasolid.transmit.text,model/vnd.vtu,model/vrml,multipart/alternative,multipart/appledouble,multipart/byteranges,multipart/digest,multipart/encrypted,multipart/form-data,multipart/header-set,multipart/mixed,multipart/parallel,multipart/related,multipart/report,multipart/signed,multipart/voice-message,text/RED,text/calendar,text/css,text/csv,text/directory,text/dns,text/enriched,text/html,text/parityfec,text/plain,text/prs.fallenstein.rst,text/prs.lines.tag,text/rfc822-headers,text/richtext,text/rtf,text/sgml,text/t140,text/tab-separated-values,text/troff,text/uri-list,text/vnd.DMClientScript,text/vnd.IPTC.NITF,text/vnd.IPTC.NewsML,text/vnd.abc,text/vnd.curl,text/vnd.esmertec.theme-descriptor,text/vnd.fly,text/vnd.fmi.flexstor,text/vnd.in3d.3dml,text/vnd.in3d.spot,text/vnd.latex-z,text/vnd.motorola.reflex,text/vnd.ms-mediapackage,text/vnd.net2phone.commcenter.command,text/vnd.sun.j2me.app-descriptor,text/vnd.wap.si,text/vnd.wap.sl,text/vnd.wap.wml,text/vnd.wap.wmlscript,text/xml,text/xml-external-parsed-entity,video/3gpp,video/BMPEG,video/BT656,video/CelB,video/DV,video/H261,video/H263,video/H263-1998,video/H263-2000,video/H264,video/JPEG,video/MJ2,video/MP1S,video/MP2P,video/MP2T,video/MP4V-ES,video/MPV,video/SMPTE292M,video/mpeg,video/mpeg4-generic,video/nv,video/parityfec,video/pointer,video/quicktime,video/raw,video/vnd.fvt,video/vnd.motorola.video,video/vnd.motorola.videop,video/vnd.mpegurl,video/vnd.nokia.interleaved-multimedia,video/vnd.objectvideo,video/vnd.sealed.mpeg1,video/vnd.sealed.mpeg4,video/vnd.sealed.swf,video/vnd.sealedmedia.softseal.mov,video/vnd.vivo,application/vnd.openxmlformats-officedocument.wordprocessingml.document,'"/>
   <xsl:template match="text()" priority="-1" mode="M0"/>
   <xsl:template match="@*|node()" priority="-2" mode="M0">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M0"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M0"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN abstracts-->
   <xsl:template match="text()" priority="-1" mode="M1"/>
   <xsl:template match="@*|node()" priority="-2" mode="M1">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M1"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M1"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:variable name="type" select="goruntuleme"/>
   <xsl:variable name="envelopeType"
                 select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:Type"/>
   <xsl:variable name="senderId"
                 select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact"/>
   <xsl:variable name="senderAlias"
                 select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/>
   <xsl:variable name="receiverId"
                 select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:ContactInformation[sh:ContactTypeIdentifier = 'VKN_TCKN']/sh:Contact"/>
   <xsl:variable name="receiverAlias"
                 select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier"/>
   <xsl:variable name="responseCode"
                 select="//apr:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode"/>

	  <!--RULE -->
   <xsl:template match="//cbc:IdentificationCode" priority="112" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($CountryCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri:</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text> Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:SourceCurrencyCode" priority="111" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri:</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text> Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:TargetCurrencyCode" priority="110" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri:</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text> Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:CurrencyCode" priority="109" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri:</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text> Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//@currencyID" priority="108" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz currencyID niteli??i : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//@unitCode" priority="107" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(//cbc:UBLVersionID = '2.1') or contains($UnitCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz unitCode niteli??i : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:ChannelCode" priority="106" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(//cbc:UBLVersionID = '2.1') or contains($ChannelCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri:</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text> Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:IssueDate" priority="105" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:date(.) le xs:date(current-date())"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:IssueDate de??eri : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>' cbc:IssueDate alan?? g??n??n tarihinden ileri bir tarih olamaz</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:date('2005-01-01+04:00')  le xs:date(.)"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:IssueDate de??eri : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>' cbc:IssueDate alan?? 01.01.2005 tarihinden ??nce bir tarih olamaz</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//@mimeCode" priority="104" mode="M0">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($MimeCodeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz mimeCode niteli??i : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M0"/>
   </xsl:template>

   <!--PATTERN invoice-->


	  <!--RULE -->
   <xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature"
                 priority="133"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ds:SignedInfo/ds:Reference/ds:Transforms"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:SignedInfo/ds:Reference/ds:Transforms eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ds:KeyInfo"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:KeyInfo eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ds:KeyInfo) or ds:KeyInfo/ds:X509Data"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:KeyInfo eleman?? i??erisindeki ds:X509Data eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ds:Object"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:Object eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>xades:SigningTime eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ds:Object) or ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>xades:SigningCertificate eleman?? zorunlu bir elemand??r</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ds:SignedInfo/ds:Reference[@URI = '']) = 1 "/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:SignedInfo elaman?? i??erisinde URI niteli??i bo??lu??a("") e??it olan sadece bir tane ds:Reference eleman?? bulunmald??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../../../../cbc:UBLVersionID = '2.1') or ds:SignedInfo/ds:SignatureMethod/@Algorithm !='http://www.w3.org/2000/09/xmldsig#rsa-sha1'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:SignatureMethod alan??n??n Algorithm niteli??i "http://www.w3.org/2000/09/xmldsig#rsa-sha1" olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data"
                 priority="132"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ds:X509Certificate"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:X509Data eleman?? i??erisindeki ds:X509Certificate eleman?? zorunlu bir elemand??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509SubjectName"
                 priority="131"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) != 0 "/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text> ds:X509SubjectName eleman??n??n de??eri bo??luk olmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice" priority="130" mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:UBLVersionID = '2.1'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:UBLVersionID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:UBLVersionID"/>
               <xsl:text>'. cbc:UBLVersionID de??eri '2.1' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:CustomizationID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:CustomizationID"/>
               <xsl:text>' cbc:CustomizationID eleman?? de??eri 'TR1.2' veya 'TR1.2.1' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($type = 'efatura') and not($type = '') or contains($ProfileIDType, concat(',',cbc:ProfileID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ProfileID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:ProfileID"/>
               <xsl:text>'. Ge??erli cbc:ProfileID de??erleri i??in ProfileIDType listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($type = 'earchive') or contains($ProfileIDTypeEarchive, concat(',',cbc:ProfileID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ProfileID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:ProfileID"/>
               <xsl:text>'. Ge??erli cbc:ProfileID de??erleri i??in ProfileIDTypeEarchive listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($type = 'goruntuleme') or contains($ProfileIDTypeGoruntuleme, concat(',',cbc:ProfileID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ProfileID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:ProfileID"/>
               <xsl:text>'. Ge??erli cbc:ProfileID de??erleri i??in ProfileIDTypeGoruntuleme listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@xsi:schemaLocation) or contains(@xsi:schemaLocation,'UBL-Invoice-2.1.xsd')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Invoice alan??n xsi:schemaLocation ??zeli??i 'UBL-Invoice-2.1.xsd' olmal??d??r</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:CopyIndicator = 'false'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:CopyIndicator eleman?? de??eri. cbc:CopyIndicator eleman?? 'false' de??erine e??it olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($InvoiceTypeCodeList, concat(',',cbc:InvoiceTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:InvoiceTypeCode eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:InvoiceTypeCode"/>
               <xsl:text>'. Ge??erli cbc:InvoiceTypeCode de??erleri i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:InvoiceTypeCode='IADE') or cbc:ProfileID='TEMELFATURA' or cbc:ProfileID='EARSIVFATURA' "/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Fatura tipi IADE iken fatura profili sadece TEMELFATURA veya EARSIVFATURA olabilir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($CurrencyCodeList, concat(',',cbc:DocumentCurrencyCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:DocumentCurrencyCode eleman?? de??eri. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:TaxCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:TaxCurrencyCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:TaxCurrencyCode eleman?? de??eri. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:PricingCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PricingCurrencyCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:PricingCurrencyCode eleman?? de??eri. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:PaymentCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentCurrencyCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:PaymentCurrencyCode eleman?? de??eri. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:PaymentAlternativeCurrencyCode) or contains($CurrencyCodeList, concat(',',cbc:PaymentAlternativeCurrencyCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:PaymentAlternativeCurrencyCode eleman?? de??eri. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cac:Signature) &lt;= 1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>En fazla bir tane cac:Signature eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:WithholdingTaxTotal)) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'SGK'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Uyumsuz fatura tipi: '</xsl:text>
               <xsl:value-of select="cbc:InvoiceTypeCode"/>
               <xsl:text>'. cac:WithholdingTaxTotal elaman?? varken fatura tipi TEVKIFAT,IADE,veya SGK olabilir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '4171'])) or cbc:InvoiceTypeCode = 'TEVKIFAT' or cbc:InvoiceTypeCode = 'IADE' or cbc:InvoiceTypeCode = 'SGK'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Uyumsuz fatura tipi: '</xsl:text>
               <xsl:value-of select="cbc:InvoiceTypeCode"/>
               <xsl:text>'. cbc:TaxTypeCode de??eri 4171 ise fatura tipi TEVKIFAT,IDAE veya SGK olabilir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:UBLVersionID ='2.1') or not(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '4171'])) or          exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[text() = '0071'])"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:TaxTypeCode de??eri 4171 olan cac:TaxSubtotal alan?? varken cbc:TaxTypeCode de??eri 0071 olan cac:TaxSubtotal alan?? da olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or contains($DeliveryTermCodeList, concat(',',cac:Delivery/cac:DeliveryTerms/cbc:ID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, schemeID niteli??i INCOTERMS olan Ge??ersiz cac:Delivery/cac:DeliveryTerms/cbc:ID de??eri : '</xsl:text>
               <xsl:value-of select="cac:Delivery/cac:DeliveryTerms/cbc:ID"/>
               <xsl:text>' Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode)) or contains($PackageTypeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz : cbc:PackagingTypeCode de??eri : '</xsl:text>
               <xsl:value-of select="cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode"/>
               <xsl:text>' Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode)) or contains($TransportModeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:TransportModeCode : '</xsl:text>
               <xsl:value-of select="cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode"/>
               <xsl:text>' Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ProfileID='YOLCUBERABERFATURA') or count(cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='ARACIKURUMVKN' and (string-length(normalize-space(string(text()))) = 10 or string-length(normalize-space(string(text()))) = 11) ]) = 1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri YOLCUBERABERFATURA iken, cac:TaxRepresentativeParty/cac:PartyIdentification eleman?? schemeID niteli??i de??eri 'ARACIKURUMVKN' olan ve de??eri ge??erli bir vkn/tckn olan bir tane cbc:ID eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ProfileID='YOLCUBERABERFATURA') or count(cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='ARACIKURUMETIKET' and string-length(normalize-space(string(text()))) &gt; 0 ])=1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri YOLCUBERABERFATURA iken, cac:TaxRepresentativeParty/cac:PartyIdentification eleman?? schemeID niteli??i de??eri 'ARACIKURUMETIKET' olan ve de??eri bo?? olmayan bir tane cbc:ID eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cbc:UUID" priority="129" mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? UUID format??nda olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:Signature" priority="128" mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:ID/@schemeID='VKN_TCKN'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:Signature eleman?? i??erisindeki cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN_TCKN' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN_TCKN') or string-length(cbc:ID) = 11 or string-length(cbc:ID) = 10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i 'VKN_TCKN' ye e??it olan eleman??n uzunlu??u vergi kimlik numaras?? i??in 10 karakter TC kimlik numras?? i??in 11 karakter olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:WithholdingTaxTotal/cac:TaxSubtotal"
                 priority="127"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and             (string-length(normalize-space(string(cbc:Percent)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:WithholdingTaxTotal eleman?? ge??erli ve bo?? de??er i??ermeyen cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode ve cac:TaxSubtotal/cbc:Percent elemanlar??na sahip olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode eleman?? : '</xsl:text>
               <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text> Uyumsuz vergi tipi y??zdesi: '</xsl:text>
               <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
               <xsl:text>' vergi tipinin y??zdesi '</xsl:text>
               <xsl:value-of select="cbc:Percent"/>
               <xsl:text>' olamaz </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"
                 priority="126"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz schemeID niteli??i : '</xsl:text>
               <xsl:value-of select="@schemeID"/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification"
                 priority="125"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? g??nderen kullan??c??(</xsl:text>
               <xsl:value-of select="$senderId"/>
               <xsl:text>) ile belgeyi d??zenleyen kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? g??nderen kullan??c??(</xsl:text>
               <xsl:value-of select="$senderId"/>
               <xsl:text>) ile belgeyi d??zenleyen kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:AccountingSupplierParty/cac:Party"
                 priority="124"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanlar?? bulunmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri 'VKN' olmas?? durumunda cac:PartyName eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:PartyName eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:Name eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cac:Person eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:Person eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:FirstName ve cbc:FamilyName elemanlar??na sahip olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:PartyTaxScheme/cac:TaxScheme/cbc:Name))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name elaman?? dolu olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                 priority="123"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($PartyIdentificationIDType, concat(',',@schemeID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz schemeID niteli??i : '</xsl:text>
               <xsl:value-of select="@schemeID"/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification"
                 priority="122"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? alan kullan??c??(</xsl:text>
               <xsl:value-of select="$receiverId"/>
               <xsl:text>) ile belgeyi alan kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? alan kullan??c??(</xsl:text>
               <xsl:value-of select="$receiverId"/>
               <xsl:text>) ile belgeyi alan kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID ='1460415308') or not(../../../cbc:ProfileID!='YOLCUBERABERFATURA') or not(../../../cbc:ProfileID!='IHRACAT') or not(../../../cbc:ProfileID!='OZELFATURA') or not(../../../cbc:ProfileID!='KAMU')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text> 1460415308 vergi Numaral?? m??kellefe (G??MR??K VE T??CARET BAKANLI??I B??LG?? ????LEMDA??RES?? BA??KANLI??I) yollanan fatura senaryosu 'YOLCUBERABERFATURA' veya IHRACAT olabilir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:AccountingCustomerParty/cac:Party"
                 priority="121"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri 'VKN' ve ya 'TCKN' olan bir tane cbc:ID eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN'])=1 and count(cac:PartyIdentification/cbc:ID[@schemeID='VKN'])=1)"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri hem 'VKN' hem de 'TCKN' olan cbc:ID elemanlar?? bulunmamal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or cac:PartyName"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri 'VKN' olmas?? durumunda cac:PartyName eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='VKN') or not(cac:PartyName) or string-length(normalize-space(string(cac:PartyName/cbc:Name))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:PartyName eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:Name eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or cac:Person"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cac:Person eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:PartyIdentification/cbc:ID/@schemeID='TCKN') or not(cac:Person) or (string-length(normalize-space(string(cac:Person/cbc:FirstName))) != 0   and string-length(normalize-space(string(cac:Person/cbc:FamilyName))) != 0)"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:Person eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:FirstName ve cbc:FamilyName elemanlar??na sahip olmal??d??r.(??sim En Az Bir Bo??luk Olacak ??ekilde Yap??land??r??lmal??d??r.)</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"
                 priority="120"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($TaxType, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:TaxTypeCode de??eri : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"
                 priority="119"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($TaxType, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:TaxTypeCode de??eri : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal"
                 priority="118"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="../../cbc:InvoiceTypeCode = 'IADE' or ../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or not(cbc:TaxAmount = 0) or not(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode = '0015') or string-length(normalize-space(cac:TaxCategory/cbc:TaxExemptionReason)) &gt; 0 "/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Vergi miktar?? 0 olan 0015 vergi kodlu KDV i??in cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) eleman?? bulunmal??d??r ve bo?? de??er i??ermemelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory"
                 priority="117"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReason)))) &gt; 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) eleman?? bo?? de??er i??ermemelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:TaxExemptionReason) or not(../../../cbc:UBLVersionID ='2.1') or (string-length(normalize-space(string(cbc:TaxExemptionReasonCode)))) != 0 and contains($TaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:TaxExemptionReasonCode niteli??i : '</xsl:text>
               <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
               <xsl:text>' cbc:TaxExemptionReason(vergi istisna muhafiyet sebebi) eleman?? varken cbc:TaxExemptionReasonCode elaman?? dolu ve ge??erli bir de??er olmal??d??r. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($istisnaTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'ISTISNA' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'SGK'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Uyumsuz fatura tipi: '</xsl:text>
               <xsl:value-of select="../../../cbc:InvoiceTypeCode"/>
               <xsl:text>'. Vergi istisna muhafiyet kodu : '</xsl:text>
               <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
               <xsl:text>' i??in fatura tipi ISTISNA,IADE,IHRACKAYITLI veya SGK olabilir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ozelMatrahTaxExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'OZELMATRAH' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'SGK'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Uyumsuz fatura tipi: '</xsl:text>
               <xsl:value-of select="../../../cbc:InvoiceTypeCode"/>
               <xsl:text>'. Vergi istisna muhafiyet kodu : '</xsl:text>
               <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
               <xsl:text>' i??in fatura tipi OZELMATRAH,IADE veya SGK olabilir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../../../cbc:UBLVersionID ='2.1') or not(contains($ihracExemptionReasonCodeType, concat(',',cbc:TaxExemptionReasonCode,','))) or ../../../cbc:InvoiceTypeCode = 'IHRACKAYITLI' or ../../../cbc:InvoiceTypeCode = 'IADE' or ../../../cbc:InvoiceTypeCode = 'SGK' "/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Uyumsuz fatura tipi: '</xsl:text>
               <xsl:value-of select="../../../cbc:InvoiceTypeCode"/>
               <xsl:text>'. Vergi istisna muhafiyet kodu : '</xsl:text>
               <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
               <xsl:text>' i??in fatura tipi IHRACKAYITLI,IADE veya SGK olabilir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:InvoiceLine" priority="116" mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Price/cbc:PriceAmount))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:InvoiceLine eleman?? ge??erli ve bo?? de??er i??ermeyen cac:Price/cbc:PriceAmount eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cbc:LineExtensionAmount))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:InvoiceLine eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:LineExtensionAmount eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or count(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or count(../cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) &gt; 0 "/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:InvoiceLine/cac:Delivery/cac:DeliveryTerms elaman?? schemeID niteli??i de??eri 'INCOTERMS' olan en az bir cbc:ID eleman?? i??ermiyorsa, Invoice/cac:Delivery/cac:DeliveryTerms elaman?? schemeID niteli??i de??eri 'INCOTERMS' olan en az bir cbc:ID eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or cac:Delivery/cac:DeliveryAddress or ../cac:Delivery/cac:DeliveryAddress"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken Invoice ve cac:InvoiceLine elemanlar??ndan en az bir tanesi cac:Delivery/cac:DeliveryAddress eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode))) != 0 or string-length(normalize-space(string(../cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:InvoiceLine eleman?? Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode elaman?? i??ermiyorsa Invoice eleman?? Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Delivery/cac:Shipment/cac:GoodsItem/cbc:RequiredCustomsID))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:InvoiceLine eleman?? ge??erli ve bo?? de??er i??ermeyen ccac:Delivery/cac:Shipment/cac:GoodsItem/cbc:RequiredCustomsID eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cbc:InvoicedQuantity))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:InvoiceLine eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:InvoicedQuantity eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Delivery/cac:DeliveryTerms/cbc:ID[@schemeID='INCOTERMS']) or contains($DeliveryTermCodeList, concat(',',cac:Delivery/cac:DeliveryTerms/cbc:ID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, schemeID niteli??i INCOTERMS olan Ge??ersiz cac:Delivery/cac:DeliveryTerms/cbc:ID de??eri : '</xsl:text>
               <xsl:value-of select="cac:Delivery/cac:DeliveryTerms/cbc:ID"/>
               <xsl:text>' Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode)) or contains($PackageTypeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz : cbc:PackagingTypeCode de??eri : '</xsl:text>
               <xsl:value-of select="cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cac:ActualPackage/cbc:PackagingTypeCode"/>
               <xsl:text>' Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(exists(cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode)) or contains($TransportModeCodeList, concat(',',cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:TransportModeCode : '</xsl:text>
               <xsl:value-of select="cac:Delivery/cac:Shipment/cac:ShipmentStage/cbc:TransportModeCode"/>
               <xsl:text>' Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:InvoiceLine/cac:WithholdingTaxTotal/cac:TaxSubtotal"
                 priority="115"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(string-length(normalize-space(string(cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode)))) != 0 and             (string-length(normalize-space(string(cbc:Percent)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:WithholdingTaxTotal eleman?? ge??erli ve bo?? de??er i??ermeyen cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode ve cac:TaxSubtotal/cbc:Percent elemanlar??na sahip olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($WithholdingTaxType, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode eleman?? : '</xsl:text>
               <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($WithholdingTaxTypeWithPercent, concat(',',cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode,cbc:Percent,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text> Uyumsuz vergi tipi y??zdesi: '</xsl:text>
               <xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
               <xsl:text>' vergi tipinin y??zdesi '</xsl:text>
               <xsl:value-of select="cbc:Percent"/>
               <xsl:text>' olamaz </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity"
                 priority="114"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(@unitCode)=1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:InvoicedQuantity eleman?? ge??erli ve bo?? de??er i??ermeyen bir adet unitCode niteli??ine sahip olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount"
                 priority="113"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"
                 priority="112"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"
                 priority="111"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount"
                 priority="110"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount"
                 priority="109"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature/ds:SignedInfo/ds:Reference/ds:Transforms"
                 priority="108"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ds:Transform) &lt;= 1"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>ds:Transforms eleman?? i??erisinde en fazla bir tane ds:Transform eleman?? bulunmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:TaxTotal/cbc:TaxAmount"
                 priority="107"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:Signature/cac:SignatoryParty"
                 priority="106"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cac:PartyIdentification/cbc:ID[@schemeID='TCKN']) &gt; 0 or count(cac:PartyIdentification/cbc:ID[@schemeID='VKN']) &gt; 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:SignatoryParty alan?? schemeID niteli??i de??eri 'VKN' veya 'TCKN' olan en az bir cac:PartyIdentification/cbc:ID eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:TaxTotal/cbc:TaxAmount"
                 priority="105"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^(\s)*?[0-9][0-9]{0,16}(,[0-9]{3})*(\.[0-9]{1,2}(\s)*?)?(\s)*?$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? noktadan ??nce en fazla 15 , noktadan sonra(kuru??) en fazla 2 haneli olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode"
                 priority="104"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../../cbc:UBLVersionID = '2.1') or contains($PaymentMeansCodeTypeList, concat(',',.,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:PaymentMeansCode de??eri : '</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>'. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:BillingReference/cac:AdditionalDocumentReference"
                 priority="103"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or cbc:DocumentType = 'OKCBilgiFisi'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBilgiFisi' olmald??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentType = 'OKCBilgiFisi') or cbc:DocumentTypeCode = 'OKCBF'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBilgiFisi' iken cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF olmald??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cbc:IssueDate)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cbc: eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cbc:ID)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cbc:ID eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or contains($DocumentDescriptionType, concat(',',cbc:DocumentDescription,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:DocumentDescription eleman?? : '</xsl:text>
               <xsl:value-of select="cbc:DocumentDescription"/>
               <xsl:text>'. cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cbc:DocumentDescription eleman?? i??ermelidir. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:Attachment/cac:ExternalReference/cbc:URI)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cac:Attachment/cac:ExternalReference/cbc:URI eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:ValidityPeriod/cbc:StartDate)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cac:ValidityPeriod/cbc:StartDate eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or cac:ValidityPeriod/cbc:StartDate = cbc:IssueDate"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text> cac:BillingReference/cac:AdditionalDocumentReference/cac:ValidityPeriod/cbc:StartDate eleman??n??n de??eri ile cac:BillingReference/cac:AdditionalDocumentReference/cbc:IssueDate eleman??n??n de??eri ayn?? olmal??d??r. </xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DocumentTypeCode = 'OKCBF') or (string-length(normalize-space(string(cac:IssuerParty/cbc:EndpointID)))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:BillingReference/cac:AdditionalDocumentReference/cbc:DocumentTypeCode eleman??n??n de??eri 'OKCBF' iken cac:BillingReference/cac:AdditionalDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cac:IssuerParty/cbc:EndpointID eleman?? i??ermelidir</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cbc:ProfileID" priority="102" mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($receiverAlias = 'urn:mail:yolcuberaberpk@gtb.gov.tr') or (.='YOLCUBERABERFATURA')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier eleman??n??n de??eri 'urn:mail:yolcuberaberpk@gtb.gov.tr' iken inv:Invoice/cbc:ProfileID eleman??n??n de??eri 'YOLCUBERABERFATURA' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($receiverAlias = 'urn:mail:ihracatpk@gtb.gov.tr') or (.='IHRACAT') or (.='OZELFATURA')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier eleman??n??n de??eri 'urn:mail:ihracatpk@gtb.gov.tr' iken inv:Invoice/cbc:ProfileID eleman??n??n de??eri 'IHRACAT' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(.='YOLCUBERABERFATURA') or (../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID='TAXFREE' and ../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>inv:Invoice/cbc:ProfileID eleman??n??n de??eri 'YOLCUBERABERFATURA' iken cbc:ID eleman??n??n de??eri TAXFREE ve schemeID ??zelli??i PARTYTYPE olan bir cac:BuyerCustomerParty i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(.='IHRACAT') or (../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID='EXPORT' and ../cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>inv:Invoice eleman?? inv:Invoice/cbc:ProfileID eleman??n??n de??eri 'IHRACAT' iken, schemeID ??zelli??i PARTYTYPE olan ve de??eri EXPORT olan cbc:ID eleman?? i??eren bir cac:BuyerCustomerParty eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(.='KAMU') or matches(../cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID,'^TR\d{7}[A-Z0-9]{17}$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>inv:Invoice/cbc:ProfileID eleman??n??n de??eri 'KAMU' iken cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID alan??na ge??erli bir T??rkiye IBAN numaras?? yaz??lmal??d??r</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="inv:Invoice/cac:BuyerCustomerParty"
                 priority="101"
                 mode="M32">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Party/cac:PartyIdentification/cbc:ID = 'TAXFREE') or not(cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE') or contains($CountryCodeList, concat(',',cac:Party/cac:Person/cbc:NationalityID,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Invoice/BuyerCustomerParty/Party/PartyIdentification/cbc:ID eleman??n??n de??eri TAXFREE ve schemeID ??zelli??i PARTYTYPE iken cac:Party/cac:Person/cbc:NationalityID elaman?? dolu ve ge??erli bir de??er olmal??d??r. Ge??erli de??erler i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Party/cac:PartyIdentification/cbc:ID = 'TAXFREE') or not(cac:Party/cac:PartyIdentification/cbc:ID/@schemeID='PARTYTYPE') or (string-length(normalize-space(string(cac:Party/cac:Person/cac:IdentityDocumentReference/cbc:ID)))) !=0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Invoice/BuyerCustomerParty/Party/PartyIdentification/cbc:ID eleman??n??n de??eri TAXFREE ve schemeID ??zelli??i PARTYTYPE iken cac:Party/cac:Person/cac:IdentityDocumentReference elaman?? ge??erli ve bo?? de??er i??ermeyen bir cbc:ID eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../cbc:ProfileID='IHRACAT') or string-length(normalize-space(string(cac:Party/cac:PartyLegalEntity/cbc:RegistrationName))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ProfileID eleman??n??n de??eri IHRACAT iken, cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName elaman?? dolu olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M32"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M32"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN despatchadvice-->


	  <!--RULE -->
   <xsl:template match="desp:DespatchAdvice" priority="106" mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($DespatchAdviceTypeCodeList, concat(',',cbc:DespatchAdviceTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:DespatchAdviceTypeCode eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:DespatchAdviceTypeCode"/>
               <xsl:text>'. Ge??erli cbc:DespatchAdviceTypeCode de??erleri i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:DespatchAdviceTypeCode = 'MATBUDAN') or (count(cac:AdditionalDocumentReference[string-length(normalize-space(string(cbc:ID))) &gt; 0  and string-length(normalize-space(string(cbc:IssueDate))) &gt; 0 ]) &gt; 0)"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>DespatchAdviceTypeCode de??eri 'MATBUDAN' iken cbc:ID ve cbc:IssueDate alanlar?? dolu olan en az bir tane cac:AdditionalDocumentReference alan?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:CustomizationID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:CustomizationID"/>
               <xsl:text>' cbc:CustomizationID eleman?? de??eri 'TR1.2' veya 'TR1.2.1' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ActualDespatchDate eleman?? ge??erli ve bo?? olmayan bir de??er i??ermelidir.'</xsl:text>
               <xsl:value-of select="cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate"/>
               <xsl:text>'</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate,'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ActualDespatchDate de??eri : '</xsl:text>
               <xsl:value-of select="cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate"/>
               <xsl:text>'. cbc:ActualDespatchDate elaman?? YYYY-MM-DD format??nda ge??erli bir tarih i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="desp:DespatchAdvice/cbc:UUID" priority="105" mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? UUID format??nda olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="desp:DespatchAdvice/cac:DespatchLine"
                 priority="104"
                 mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cbc:DeliveredQuantity))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:DespatchLine eleman?? ge??erli ve bo?? de??er i??ermeyen cbc:DeliveredQuantity eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cbc:DeliveredQuantity/@unitCode))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:DeliveredQuantity eleman?? dolu ve ge??erli de??er i??eren unitCode niteli??ine sahip olmal??d??r</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cac:Item/cbc:Name))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:Item eleman?? bo?? de??er i??ermeyen cbc:Name eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cbc:ID))) != 0 and string(number(cbc:ID)) != 'NaN'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ID eleman?? de??eri. cbc:ID eleman?? dolu ve ger??ek say?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="desp:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification"
                 priority="103"
                 mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or not(string-length(cbc:ID)=10) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? g??nderen kullan??c??(</xsl:text>
               <xsl:value-of select="$senderId"/>
               <xsl:text>) ile belgeyi d??zenleyen kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or not(string-length(cbc:ID)=11) or not($senderId) or $senderId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? g??nderen kullan??c??(</xsl:text>
               <xsl:value-of select="$senderId"/>
               <xsl:text>) ile belgeyi d??zenleyen kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="desp:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification"
                 priority="102"
                 mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=10) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? alan kullan??c??(</xsl:text>
               <xsl:value-of select="$receiverId"/>
               <xsl:text>) ile belgeyi alan kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or $receiverId='3900892152' or not(string-length(cbc:ID)=11) or not($receiverId) or $receiverId = cbc:ID"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Zarf?? alan kullan??c??(</xsl:text>
               <xsl:value-of select="$receiverId"/>
               <xsl:text>) ile belgeyi alan kullan??c??(</xsl:text>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text>) ayn?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="desp:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification"
                 priority="101"
                 mode="M33">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M33"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M33"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN receiptadvice-->


	  <!--RULE -->
   <xsl:template match="recp:ReceiptAdvice" priority="106" mode="M34">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="contains($ReceiptAdviceTypeCodeList, concat(',',cbc:ReceiptAdviceTypeCode,','))"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ReceiptAdviceTypeCode eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:ReceiptAdviceTypeCode"/>
               <xsl:text>'. Ge??erli cbc:ReceiptAdviceTypeCode de??erleri i??in kod listesine bak??n??z.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:CustomizationID = 'TR1.2' or cbc:CustomizationID = 'TR1.2.1'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:CustomizationID eleman?? de??eri : '</xsl:text>
               <xsl:value-of select="cbc:CustomizationID"/>
               <xsl:text>' cbc:CustomizationID eleman?? de??eri 'TR1.2' veya 'TR1.2.1' olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="recp:ReceiptAdvice/cbc:UUID" priority="105" mode="M34">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(.,'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? de??eri. </xsl:text>
               <xsl:value-of select="name(.)"/>
               <xsl:text> eleman?? UUID format??nda olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="recp:ReceiptAdvice/cac:ReceiptLine"
                 priority="104"
                 mode="M34">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cac:Item/cbc:Name))) != 0"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cac:Item eleman?? bo?? de??er i??ermeyen cbc:Name eleman?? i??ermelidir.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(string(cbc:ID))) != 0 and string(number(cbc:ID)) != 'NaN'"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>Ge??ersiz cbc:ID eleman?? de??eri. cbc:ID eleman?? dolu ve ger??ek say?? olmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="recp:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification"
                 priority="103"
                 mode="M34">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="recp:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification"
                 priority="102"
                 mode="M34">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="recp:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification"
                 priority="101"
                 mode="M34">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='VKN') or string-length(cbc:ID)=10"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'VKN' olmas?? durumunda cbc:ID eleman??na 10 haneli vergi kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:ID/@schemeID='TCKN') or string-length(cbc:ID)=11"/>
         <xsl:otherwise>
            <Error xmlns:xs="http://www.w3.org/2001/XMLSchema">
               <xsl:text>cbc:ID eleman??n??n schemeID niteli??i de??eri 'TCKN' olmas?? durumunda cbc:ID eleman??na 11 haneli TC kimlik numaras?? yaz??lmal??d??r.</xsl:text>
            </Error>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M34"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M34"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>


