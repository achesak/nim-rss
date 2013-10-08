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

type TRSSItem* = tuple[title : string, link : string, description : string, author : string, category : seq[string],
                       comments : string, enclosure : TRSSEnclosure, guid : string, pubDate : string, 
                       sourceUrl : string, sourceText : string]

#type TRSS* = tuple[



