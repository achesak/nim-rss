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
                   skipDays : seq[string]]


proc interpretRSS(data : string): TRSS = 
    # Parses the RSS (internal function).
    
    # Parse into XML.
    var xml : PXmlNode = parseXML(newStringStream(data)).child("channel")
    
    # Create the return object.
    var rss : TRSS
    
    # Fill the required fields.
    rss.title = xml.child("title").innerText
    
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


var test : TRSS = loadRSS("test.xml")
echo(test.title)
