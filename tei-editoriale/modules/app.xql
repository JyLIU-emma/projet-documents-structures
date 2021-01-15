xquery version "3.1";

module namespace app="http://exist-db/apps/ebook/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db/apps/ebook/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = 'http://www.functx.com';

import module namespace kwic = "http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute data-template="app:test" 
 : or class="app:test" (deprecated). The function has to take at least 2 default
 : parameters. Additional parameters will be mapped to matching request or session parameters.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)



declare function functx:substring-after-last
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {

   replace ($arg,concat('^.*',$delim),'')
 } ;

(:La fonction suivante génère la liste des livres dans notre app:)
declare function app:sommaire($node as node(), $model as map(*)) {
(:    for $doc in collection(concat($config:app-root, "/data"))//tei:TEI:)
    for $doc in collection(concat($config:app-root, "/data"))
    let $docName := functx:substring-after-last(document-uri(root($doc)), '/')
    where $docName != "index.xml"
    return
        <li><a href="{concat('show.html?document=',$docName)}">{substring-before($docName,".xml")}</a></li>
};


(:Transformer le fichier tei en html:)
declare function app:XMLtoHTML ($node as node(), $model as map (*), $query as xs:string?) {
let $ref := xs:string(request:get-parameter("document", ""))
let $xml := doc(concat($config:app-root, "/data/", $ref)) 
(:let $xml := doc(concat("/db/apps/ebook/data/",$ref)):)
let $xsl := doc(concat($config:app-root, "/resources/xslt/teiToHtml.xsl"))
let $params :=
<parameters>
   {for $p in request:get-parameter-names()
    let $val := request:get-parameter($p,())
    where  not($p = ("document","directory","stylesheet"))
    return
       <param name="{$p}"  value="{$val}"/>
   }
</parameters>

return
    transform:transform($xml, $xsl, $params)
};

(:Transformer le fichier index.xml en html:)
declare function app:IndexToHTML ($node as node(), $model as map (*)) {
    let $xml := doc(concat($config:app-root, "/data/index.xml")) 
    let $xsl := doc(concat($config:app-root, "/resources/xslt/index.xsl"))
    let $params :=
        <parameters>
           {for $p in request:get-parameter-names()
            let $val := request:get-parameter($p,())
            where  not($p = ("document","directory","stylesheet"))
            return
               <param name="{$p}"  value="{$val}"/>
           }
        </parameters>
return
    transform:transform($xml, $xsl, $params)
};






