# Nim RSS (Really Simple Syndication) module

# Written by Adam Chesak.
# Released under the MIT open source license.


# Import modules.
import httpclient
import strutils
import xmlparser
import xmltree
import streams


# Create the types.
type
  RSS* = object
    title* : string
    link* : string
    description* : string
    language* : string
    copyright* : string
    managingEditor* : string
    webMaster* : string
    pubDate* : string
    lastBuildDate* : string
    category* : seq[string]
    generator* : string
    docs* : string
    cloud* : RSSCloud
    ttl* : string
    image* : RSSImage
    rating* : string
    textInput* : RSSTextInput
    skipHours* : seq[string]
    skipDays* : seq[string]
    items* : seq[RSSItem]

  RSSEnclosure* = object
    url* : string
    length* : string
    enclosureType* : string

  RSSCloud* = object
    domain* : string
    port* : string
    path* : string
    registerProcedure* : string
    protocol* : string

  RSSImage* = object
    url* : string
    title* : string
    link* : string
    width* : string
    height* : string
    description* : string

  RSSTextInput* = object
    title* : string
    description* : string
    name* : string
    link* : string

  RSSItem* = object
    title* : string
    link* : string
    description* : string
    author* : string
    category* : seq[string]
    comments* : string
    enclosure* : RSSEnclosure
    guid* : string
    pubDate* : string
    sourceUrl* : string
    sourceText* : string

proc parseRSS*(data : string): RSS =
  ## Parses the RSS from the given string.

  # Parse into XML.
  let root : XmlNode = parseXML(newStringStream(data))
  let channel : XmlNode = root.child("channel")

  # Create the return object.
  var rss : RSS = RSS()

  # Fill the required fields.
  rss.title = channel.child("title").innerText
  rss.link = channel.child("link").innerText
  rss.description = channel.child("description").innerText

  # Fill the optional fields.
  for key in @["language", "dc:language"]:
    if channel.child(key) != nil:
      rss.language = channel.child(key).innerText
  if channel.child("copyright") != nil:
    rss.copyright = channel.child("copyright").innerText
  if channel.child("managingEditor") != nil:
    rss.managingEditor = channel.child("managingEditor").innerText
  if channel.child("webMaster") != nil:
    rss.webMaster = channel.child("webMaster").innerText
  for key in @["pubDate", "dc:date"]:
    if channel.child(key) != nil:
      rss.pubDate = channel.child(key).innerText
  if channel.child("lastBuildDate") != nil:
    rss.lastBuildDate  = channel.child("lastBuildDate").innerText
  if channel.child("category") != nil:
    var catSeq = newSeq[string](len(channel.findAll("category")))
    for i in 0..high(channel.findAll("category")):
      catSeq[i] = channel.findAll("category")[i].innerText
    rss.category = catSeq

  for key in @["generator", "dc:publisher"]:
    if channel.child(key) != nil:
      rss.generator = channel.child(key).innerText
  if channel.child("docs") != nil:
    rss.docs = channel.child("docs").innerText
  if channel.child("cloud") != nil:
    var cloud : RSSCloud = RSSCloud()
    cloud.domain = channel.child("cloud").attr("domain")
    cloud.port = channel.child("cloud").attr("port")
    cloud.path = channel.child("cloud").attr("path")
    cloud.registerProcedure = channel.child("cloud").attr("registerProcedure")
    cloud.protocol = channel.child("cloud").attr("protocol")
    rss.cloud = cloud
  if channel.child("ttl") != nil:
    rss.ttl = channel.child("ttl").innerText
  if channel.child("image") != nil:
    var image : RSSImage = RSSImage()
    let img = channel.child("image")
    if img.child("url") != nil:
      image.url = img.child("url").innerText
    if img.attr("rdf:resource") != nil and img.attr("rdf:resource") != "":
      image.url = img.attr("rdf:resource")
    if img.child("title") != nil:
      image.title = img.child("title").innerText
    if img.child("link") != nil:
      image.link = img.child("link").innerText
    if img.child("width") != nil:
        image.width = img.child("width").innerText
    if img.child("height") != nil:
        image.height = img.child("height").innerText
    if img.child("description") != nil:
        image.description = img.child("description").innerText
    rss.image = image
  if channel.child("rating") != nil:
    rss.rating = channel.child("rating").innerText
  if channel.child("textInput") != nil:
    var textInput : RSSTextInput = RSSTextInput()
    textInput.title = channel.child("textInput").child("title").innerText
    textInput.description = channel.child("textInput").child("description").innerText
    textInput.name = channel.child("textInput").child("name").innerText
    textInput.link = channel.child("textInput").child("link").innerText
    rss.textInput = textInput
  if channel.child("skipHours") != nil:
    var skipHours = newSeq[string](len(channel.findAll("hour")))
    for i in 0..high(channel.findAll("hour")):
      skipHours[i] = channel.findAll("hour")[i].innerText
    rss.skipHours = skipHours
  if channel.child("skipDays") != nil:
    var skipDays = newSeq[string](len(channel.findAll("day")))
    for i in 0..high(channel.findAll("day")):
      skipDays[i] = channel.findAll("day")[i].innerText
    rss.skipDays = skipDays

  # If there are no items:
  if channel.child("item") == nil and root.child("item") == nil:
    rss.items = @[]
    return rss

  # Otherwise, add the items.
  var itemsXML : seq[XmlNode]
  if channel.child("item") != nil:
    itemsXML = channel.findAll("item")
  else:
    itemsXML = root.findAll("item")
  var items = newSeq[RSSItem](len(itemsXML))
  for i in 0..high(itemsXML):
    var item : RSSItem = RSSItem()
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
      var encl : RSSEnclosure = RSSEnclosure()
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


proc loadRSS*(filename : string): RSS =
  ## Loads the RSS from the given ``filename``.

  # Load the data from the file.
  var rss : string = readFile(filename)

  return parseRSS(rss)


proc getRSS*(url : string): RSS =
  ## Gets the RSS over from the specified ``url``.

  # Get the data.
  var rss : string = newHttpClient().getContent(url)

  return parseRSS(rss)
