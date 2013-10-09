# Nimrod RSS (Really Simple Syndication) module

# Written by Adam Chesak.
# Code released under the MIT open source license.

# Import modules.
import httpclient
import strutils
import xmlparser
import xmltree
import streams


# Create the types.
type TRSSEnclosure* = tuple[url : string, length : string, enclosureType : string]

type TRSSCloud* = tuple[domain : string, port : string, path : string, registerProcedure : string,
                        protocol : string]

type TRSSImage* = tuple[url : string, title : string, link : string, width : string, height : string,
                        description : string]

type TRSSTextInput* = tuple[title : string, description : string, name : string, link : string]

type TRSSItem* = tuple[title : string, link : string, description : string, author : string, category : seq[string],
                       comments : string, enclosure : TRSSEnclosure, guid : string, pubDate : string, 
                       sourceUrl : string, sourceText : string]

type TRSS* = tuple[title : string, link : string, description : string, language : string, copyright : string,
                   managingEditor : string, webMaster : string, pubDate : string, lastBuildDate : string, 
                   category : seq[string], generator : string, docs : string, cloud : TRSSCloud, ttl : string,
                   image : TRSSImage, rating : string, textInput : TRSSTextInput, skipHours : seq[string],
                   skipDays : seq[string], items: seq[TRSSItem]]


proc interpretRSS(data : string): TRSS = 
    # Parses the RSS (internal function).
    
    # Parse into XML.
    var xml : PXmlNode = parseXML(newStringStream(data)).child("channel")
    
    # Create the return object.
    var rss : TRSS
    
    # Fill the required fields.
    rss.title = xml.child("title").innerText
    rss.link = xml.child("link").innerText
    rss.description = xml.child("description").innerText
    
    # Fill the optional fields.
    if xml.child("language") != nil:
        rss.language = xml.child("language").innerText
    if xml.child("copyright") != nil:
        rss.copyright = xml.child("copyright").innerText
    if xml.child("managingEditor") != nil:
        rss.managingEditor = xml.child("managingEditor").innerText
    if xml.child("webMaster") != nil:
        rss.webMaster = xml.child("webMaster").innerText
    if xml.child("pubDate") != nil:
        rss.pubDate = xml.child("pubDate").innerText
    if xml.child("lastBuildDate") != nil:
        rss.lastBuildDate  = xml.child("lastBuildDate").innerText
    if xml.child("category") != nil:
        var catSeq = newSeq[string](len(xml.findAll("category")))
        for i in 0..high(xml.findAll("category")):
            catSeq[i] = xml.findAll("category")[i].innerText
        rss.category = catSeq
    if xml.child("generator") != nil:
        rss.generator = xml.child("generator").innerText
    if xml.child("docs") != nil:
        rss.docs = xml.child("docs").innerText
    if xml.child("cloud") != nil:
        var cloud : TRSSCloud
        cloud.domain = xml.child("cloud").attr("domain")
        cloud.port = xml.child("cloud").attr("port")
        cloud.path = xml.child("cloud").attr("path")
        cloud.registerProcedure = xml.child("cloud").attr("registerProcedure")
        cloud.protocol = xml.child("cloud").attr("protocol")
        rss.cloud = cloud
    if xml.child("ttl") != nil:
        rss.ttl = xml.child("ttl").innerText
    if xml.child("image") != nil:
        var image : TRSSImage
        image.url = xml.child("image").child("url").innerText
        image.title = xml.child("image").child("title").innerText
        image.link = xml.child("image").child("link").innerText
        if xml.child("image").child("width") != nil:
            image.width = xml.child("image").child("width").innerText
        if xml.child("image").child("height") != nil:
            image.height = xml.child("image").child("height").innerText
        if xml.child("image").child("description") != nil:
            image.description = xml.child("image").child("description").innerText
        rss.image = image
    if xml.child("rating") != nil:
        rss.rating = xml.child("rating").innerText
    if xml.child("textInput") != nil:
        var textInput : TRSSTextInput
        textInput.title = xml.child("textInput").child("title").innerText
        textInput.description = xml.child("textInput").child("description").innerText
        textInput.name = xml.child("textInput").child("name").innerText
        textInput.link = xml.child("textInput").child("link").innerText
        rss.textInput = textInput
    if xml.child("skipHours") != nil:
        var skipHours = newSeq[string](len(xml.findAll("hour")))
        for i in 0..high(xml.findAll("hour")):
            skipHours[i] = xml.findAll("hour")[i].innerText
        rss.skipHours = skipHours
    if xml.child("skipDays") != nil:
        var skipDays = newSeq[string](len(xml.findAll("day")))
        for i in 0..high(xml.findAll("day")):
            skipDays[i] = xml.findAll("day")[i].innerText
        rss.skipDays = skipDays
    
    # If there are no items:
    if xml.child("item") == nil:
        rss.items = @[]
        return rss
    
    # Otherwise, add the items.
    var itemsXML : seq[PXmlNode] = xml.findAll("item")
    var items = newSeq[TRSSItem](len(itemsXML))
    for i in 0..high(itemsXML):
        var item : TRSSItem
        if itemsXML[i].child("title") != nil:
            item.title = itemsXML[i].child("title").innerText
        if itemsXML[i].child("link") != nil:
            item.link = itemsXML[i].child("link").innerText
        if itemsXML[i].child("description") != nil:
            item.description = itemsXML[i].child("description").innerText
        if itemsXML[i].child("author") != nil:
            item.author = itemsXML[i].child("author").innerText
        if itemsXML[i].child("category") != nil:
            var itemCat = newSeq[string](len(itemsXML[i].findAll("category")))
            for j in 0..high(itemsXML[i].findAll("category")):
                itemCat[j] = itemsXML[i].findAll("category")[j].innerText
            item.category = itemCat
        if itemsXML[i].child("comments") != nil:
            item.comments = itemsXML[i].child("comments").innerText
        if itemsXML[i].child("enclosure") != nil:
            var encl : TRSSEnclosure
            encl.url = itemsXML[i].child("enclosure").attr("url")
            encl.length = itemsXML[i].child("enclosure").attr("length")
            encl.enclosureType = itemsXML[i].child("enclosure").attr("type")
            item.enclosure = encl
        if itemsXML[i].child("guid") != nil:
            item.guid = itemsXML[i].child("guid").innerText
        if itemsXML[i].child("pubDate") != nil:
            item.pubDate = itemsXML[i].child("pubDate").innerText
        if itemsXML[i].child("source") != nil:
            item.sourceUrl = itemsXML[i].child("source").attr("url")
            item.sourceText = itemsXML[i].child("source").innerText
        items[i] = item
    
    # Add the items to the rest of the data.
    rss.items = items
    
    # Return the RSS data.
    return rss


proc parseRSS*(rss : string): TRSS = 
    # Parses the RSS from a string.
    
    return interpretRSS(rss)


proc loadRSS*(filename : string): TRSS = 
    # Loads the RSS from a file.
    
    # Load the data from the file.
    var rss : string = readFile(filename)
    
    return interpretRSS(rss)


proc getRSS*(url : string): TRSS = 
    # Gets the RSS over HTTP.
    
    # Get the data.
    var rss : string = getContent(url)
    
    return interpretRSS(rss)
