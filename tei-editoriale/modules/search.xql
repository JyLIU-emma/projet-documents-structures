xquery version "3.1";

module namespace search="http://exist-db/apps/ebook/search";

import module namespace config="http://exist-db/apps/ebook/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";

declare function functx:ddmmyyyy-to-date
  ( $dateString as xs:string? )  as xs:date? {

   if (empty($dateString))
   then ()
   else if (not(matches($dateString,
                        '^\D*(\d{2})\D*(\d{2})\D*(\d{4})\D*$')))
   then error(xs:QName('functx:Invalid_Date_Format'))
   else xs:date(replace($dateString,
                        '^\D*(\d{2})\D*(\d{2})\D*(\d{4})\D*$',
                        '$3-$2-$1'))
 } ;

declare function search:meta($node as node(), $model as map(*)){
    let $queryMeta := request:get-parameter("queryMeta", ())
    let $infotype := request:get-parameter("infotype", ())
    let $date := request:get-parameter("date", ())
    let $date-comp := request:get-parameter("date-comp", ())

    return
    if ($queryMeta) then
        if ($date-comp = "no-info" or not($date)) then
            <p>Le {$infotype} du livre est: {$queryMeta}<br/>
            Sans info du temps de publication.</p>
         else
            <p>Le {$infotype} du livre est: {$queryMeta}<br/>
            Livre publié {$date-comp} l'an {$date}.</p>
    else
        if ($date) then
            <p>Livre publié {$date-comp} la date {$date}, aucune info sur le titre et auteur.</p>
        else
            <p>Il faut au moins un temps de publication.</p>
};

declare function search:res($node as node(), $model as map(*)){
    let $queryMeta := request:get-parameter("queryMeta", ())
    let $infotype := request:get-parameter("infotype", ())
    let $date := request:get-parameter("date", ())
    let $date-comp := request:get-parameter("date-comp", ())
    
    for $doc in collection(concat($config:app-root, "/data"))
    let $titre := $doc//tei:fileDesc/tei:titleStmt/tei:title/text()
    let $auteur := $doc//tei:fileDesc/tei:titleStmt/tei:author/text()
    let $dateXml := functx:ddmmyyyy-to-date($doc//tei:publicationStmt/tei:date/text())
    return 
        if ($infotype = "titre" and lower-case($queryMeta) = lower-case($titre)) then
                <li>Titre: {$titre}, Auteur: {$auteur}, Date: {$dateXml}</li>
        else 
            if ($infotype = "auteur" and lower-case($queryMeta) = lower-case($auteur)) then
             <li>Titre: {$titre}, Auteur: {$auteur}, Date: {$dateXml}</li>
            else 
                if ($infotype = "no-info" and $date-comp = "avant" and functx:ddmmyyyy-to-date($date) > $dateXml) then
                    <li>Titre: {$titre}, Auteur: {$auteur}, Date: {$dateXml}</li>
                else if ($infotype = "no-info" and $date-comp = "apres" and functx:ddmmyyyy-to-date($date) < $dateXml) then
                    <li>Titre: {$titre}, Auteur: {$auteur}, Date: {$dateXml}</li>
                    else ()
};

declare function search:liste(){
    let $queryMeta := request:get-parameter("queryMeta", ())
    let $infotype := request:get-parameter("infotype", ())
    let $date := request:get-parameter("date", ())
    let $date-comp := request:get-parameter("date-comp", ())
    
    for $doc in collection(concat($config:app-root, "/data"))
    let $titre := $doc//tei:fileDesc/tei:titleStmt/tei:title/text()
    let $auteur := $doc//tei:fileDesc/tei:titleStmt/tei:author/text()
    let $dateXml := functx:ddmmyyyy-to-date($doc//tei:publicationStmt/tei:date/text())
    return 
        if ($infotype = "titre" and lower-case($queryMeta) = lower-case($titre)) then
             $doc
        else if ($infotype = "auteur" and lower-case($queryMeta) = lower-case($auteur)) then
             $doc
        else if ($infotype = "no-info" and $date-comp = "avant" and functx:ddmmyyyy-to-date($date) > $dateXml) then
             $doc
        else if ($infotype = "no-info" and $date-comp = "apres" and functx:ddmmyyyy-to-date($date) < $dateXml) then
             $doc
        else ()
};

declare function local:filter($node as node(), $mode as xs:string) as xs:string? {
  if ($mode eq 'before') then 
      concat($node, ' ')
  else 
      concat(' ', $node)
};

declare function search:pleintexte($node as node(), $model as map(*)){
    if (request:get-parameter("queryWord", "")) then
        let $queryWord := xs:string(request:get-parameter("queryWord", ""))
        let $filtered-q := replace($queryWord, "[&amp;&quot;-*;-`~!@#$%^*()_+-=\[\]\{\}\|';:/.,?(:]", "")
(:        let $scope := search:liste()//tei:body:)
        let $scope := collection(concat($config:app-root, "/data"))/*
        for $hit in $scope//tei:div[ft:query(.,$queryWord)]
(:        let $expanded := kwic:expand($hit):)
        
        return 
            kwic:summarize($hit, <config width="40" table="yes"/>)
(:            kwic:get-summary($expanded, ($expanded//exist:match)[1], <config width="40" />, util:function(xs:QName("local:filter"),2)):)
    else ()
};


























