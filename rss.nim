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



