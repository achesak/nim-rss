# Nim RSS (Really Simple Syndication) module

# Written by Adam Chesak.
# Released under the MIT open source license.


# Import modules.
import httpclient
import strutils
import sequtils
import xmlparser
import xmltree
import streams
import future


# Create the types.
type
  RSS* = object
    title*: string
    link*: string
    description*: string
    language*: string
    copyright*: string
    managingEditor*: string
    webMaster*: string
    pubDate*: string
    lastBuildDate*: string
    category*: seq[string]
    generator*: string
    docs*: string
    cloud*: RSSCloud
    ttl*: string
    image*: RSSImage
    rating*: string
    textInput*: RSSTextInput
    skipHours*: seq[string]
    skipDays*: seq[string]
    items*: seq[RSSItem]

  RSSEnclosure* = object
    url*: string
    length*: string
    enclosureType*: string

  RSSCloud* = object
    domain*: string
    port*: string
    path*: string
    registerProcedure*: string
    protocol*: string

  RSSImage* = object
    url*: string
    title*: string
    link*: string
    width*: string
    height*: string
    description*: string

  RSSTextInput* = object
    title*: string
    description*: string
    name*: string
    link*: string

  RSSItem* = object
    title*: string
    link*: string
    description*: string
    author*: string
    category*: seq[string]
    comments*: string
    enclosure*: RSSEnclosure
    guid*: string
    pubDate*: string
    sourceUrl*: string
    sourceText*: string

proc parseItem(node: XmlNode): RSSItem =
  var item: RSSItem = RSSItem()
  if not isNil(node.child("title")):
    item.title = node.child("title").innerText
  if not isNil(node.child("link")):
    item.link = node.child("link").innerText
  if not isNil(node.child("description")):
    item.description = node.child("description").innerText
  for key in @["author", "dc:creator"]:
    if not isNil(node.child(key)):
      item.author = node.child(key).innerText
  if not isNil(node.child("category")):
    item.category = map(node.findAll("category"), (x: XmlNode) -> string => x.innerText)
  if not isNil(node.child("comments")):
    item.comments = node.child("comments").innerText
  if not isNil(node.child("enclosure")):
    var encl: RSSEnclosure = RSSEnclosure()
    encl.url = node.child("enclosure").attr("url")
    encl.length = node.child("enclosure").attr("length")
    encl.enclosureType = node.child("enclosure").attr("type")
    item.enclosure = encl
  if not isNil(node.child("guid")):
    item.guid = node.child("guid").innerText
  if not isNil(node.child("pubDate")):
    item.pubDate = node.child("pubDate").innerText
  if not isNil(node.child("source")):
    item.sourceUrl = node.child("source").attr("url")
    item.sourceText = node.child("source").innerText
  return item

proc parseRSS*(data: string): RSS =
  ## Parses the RSS from the given string.
  # Parse into XML.
  let root: XmlNode = parseXML(newStringStream(data))
  let channel: XmlNode = root.child("channel")

  # Create the return object.
  var rss: RSS = RSS()

  # Fill the required fields.
  rss.title = channel.child("title").innerText
  rss.link = channel.child("link").innerText
  rss.description = channel.child("description").innerText

  # Fill the optional fields.
  for key in @["language", "dc:language"]:
    if not isNil(channel.child(key)):
      rss.language = channel.child(key).innerText
  if not isNil(channel.child("copyright")):
    rss.copyright = channel.child("copyright").innerText
  if not isNil(channel.child("managingEditor")):
    rss.managingEditor = channel.child("managingEditor").innerText
  if not isNil(channel.child("webMaster")):
    rss.webMaster = channel.child("webMaster").innerText
  for key in @["pubDate", "dc:date"]:
    if not isNil(channel.child(key)):
      rss.pubDate = channel.child(key).innerText
  if not isNil(channel.child("lastBuildDate")):
    rss.lastBuildDate  = channel.child("lastBuildDate").innerText
  if not isNil(channel.child("category")):
    rss.category = map(channel.findAll("category"), (x: XmlNode) -> string => x.innerText)

  for key in @["generator", "dc:publisher"]:
    if not isNil(channel.child(key)):
      rss.generator = channel.child(key).innerText
  if not isNil(channel.child("docs")):
    rss.docs = channel.child("docs").innerText
  if not isNil(channel.child("cloud")):
    var cloud: RSSCloud = RSSCloud()
    cloud.domain = channel.child("cloud").attr("domain")
    cloud.port = channel.child("cloud").attr("port")
    cloud.path = channel.child("cloud").attr("path")
    cloud.registerProcedure = channel.child("cloud").attr("registerProcedure")
    cloud.protocol = channel.child("cloud").attr("protocol")
    rss.cloud = cloud
  if not isNil(channel.child("ttl")):
    rss.ttl = channel.child("ttl").innerText
  if not isNil(channel.child("image")):
    var image: RSSImage = RSSImage()
    let img = channel.child("image")
    if not isNil(img.child("url")):
      image.url = img.child("url").innerText
    if img.attr("rdf:resource").len != 0 and img.attr("rdf:resource") != "":
      image.url = img.attr("rdf:resource")
    if not isNil(img.child("title")):
      image.title = img.child("title").innerText
    if not isNil(img.child("link")):
      image.link = img.child("link").innerText
    if not isNil(img.child("width")):
        image.width = img.child("width").innerText
    if not isNil(img.child("height")):
        image.height = img.child("height").innerText
    if not isNil(img.child("description")):
        image.description = img.child("description").innerText
    rss.image = image
  if not isNil(channel.child("rating")):
    rss.rating = channel.child("rating").innerText
  if not isNil(channel.child("textInput")):
    var textInput: RSSTextInput = RSSTextInput()
    textInput.title = channel.child("textInput").child("title").innerText
    textInput.description = channel.child("textInput").child("description").innerText
    textInput.name = channel.child("textInput").child("name").innerText
    textInput.link = channel.child("textInput").child("link").innerText
    rss.textInput = textInput
  if not isNil(channel.child("skipHours")):
    rss.skipHours = map(channel.findAll("hour"), (x: XmlNode) -> string => x.innerText)
  if not isNil(channel.child("skipDays")):
    rss.skipDays = map(channel.findAll("day"), (x: XmlNode) -> string => x.innerText)

  # If there are no items:
  if isNil(channel.child("item")) and isNil(root.child("item")):
    rss.items = @[]
    return rss

  # Otherwise, add the items.
  if not isNil(channel.child("item")):
    rss.items = map(channel.findAll("item"), parseItem)
  else:
    rss.items = map(root.findAll("item"), parseItem)

  # Return the RSS data.
  return rss


proc loadRSS*(filename: string): RSS =
  ## Loads the RSS from the given ``filename``.

  # Load the data from the file.
  var rss: string = readFile(filename)

  return parseRSS(rss)


proc getRSS*(url: string): RSS =
  ## Gets the RSS over from the specified ``url``.

  # Get the data.
  var rss: string = newHttpClient().getContent(url)

  return parseRSS(rss)
