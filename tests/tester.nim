import rss
import unittest

test "parse rss file":
  let feed = loadRSS("./tests/test.rss")
  check(feed.title == "FeedForAll Sample Feed")
  check(feed.link == "http://www.feedforall.com/industry-solutions.htm")
  check(feed.description == "RSS is a fascinating technology. The uses for RSS are expanding daily. Take a closer look at how various industries are using the benefits of RSS in their businesses.")
  check(feed.language == "en-us")
  check(feed.copyright == "Copyright 2004 NotePage, Inc.")
  check(feed.managingEditor == "marketing@feedforall.com")
  check(feed.pubDate == "Tue, 19 Oct 2004 13:38:55 -0400")
  check(feed.webMaster == "webmaster@feedforall.com")
  check(feed.lastBuildDate == "Tue, 19 Oct 2004 13:39:14 -0400")
  check(feed.category == @["Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management", "Computers/Software/Internet/Site Management/Content Management"])
  check(feed.generator == "FeedForAll Beta1 (0.0.1.8)")
  check(feed.docs == "http://blogs.law.harvard.edu/tech/rss")
  check(feed.cloud == RSSCloud())
  check(feed.ttl == nil)
  check(feed.image == RSSImage(url: "http://www.feedforall.com/ffalogo48x48.gif", title: "FeedForAll Sample Feed", link: "http://www.feedforall.com/industry-solutions.htm", width: "48", height: "48", description: "FeedForAll Sample Feed"))
  check(feed.rating == nil)
  check(feed.textInput == RSSTextInput())
  check(feed.skipHours == nil)
  check(feed.skipDays == nil)
  check(feed.items.len == 9)
  let item = feed.items[0]
  check(item.title == "RSS Solutions for Restaurants")
  check(item.link == "http://www.feedforall.com/restaurant.htm")
  check(item.description == """<b>FeedForAll </b>helps Restaurant's communicate with customers. Let your customers know the latest specials or events.<br>
<br>
RSS feed uses include:<br>
<i><font color="#FF0000">Daily Specials <br>
Entertainment <br>
Calendar of Events </i></font>""")
  check(item.author == nil)
  check(item.category == @["Computers/Software/Internet/Site Management/Content Management"])
  check(item.comments == "http://www.feedforall.com/forum")
  check(item.enclosure == RSSEnclosure())
  check(item.guid == nil)
  check(item.pubDate == "Tue, 19 Oct 2004 11:09:11 -0400")
  check(item.sourceUrl == nil)
  check(item.sourceText == nil)

test "parse rdf file":
  let feed = loadRSS("./tests/test.rdf")
  check(feed.title == "cs updates on arXiv.org")
  check(feed.link == "http://arxiv.org/")
  check(feed.description == "Computer Science (cs) updates on the arXiv.org e-print archive")
  check(feed.language == "en-us")
  check(feed.copyright == nil)
  check(feed.managingEditor == nil)
  check(feed.pubDate == "2018-08-30T20:30:00-05:00")
  check(feed.webMaster == nil)
  check(feed.lastBuildDate == nil)
  check(feed.category == nil)
  check(feed.generator == "www-admin@arxiv.org")
  check(feed.docs == nil)
  check(feed.cloud == RSSCloud())
  check(feed.ttl == nil)
  check(feed.image == RSSImage(url: "http://arxiv.org/icons/sfx.gif", title: nil, link: nil, width: nil, height: nil, description: nil))
  check(feed.rating == nil)
  check(feed.textInput == RSSTextInput())
  check(feed.skipHours == nil)
  check(feed.skipDays == nil)
  check(feed.items.len == 185)
  let item = feed.items[0]
  check(item.title == "QuasarNET: Human-level spectral classification and redshifting with Deep Neural Networks. (arXiv:1808.09955v1 [astro-ph.IM])")
  check(item.link == "http://arxiv.org/abs/1808.09955")
  check(item.description == """<p>We introduce QuasarNET, a deep convolutional neural network that performs
    classification and redshift estimation of astrophysical spectra with
    human-expert accuracy. We pose these two tasks as a \emph{feature detection}
    problem: presence or absence of spectral features determines the class, and
    their wavelength determines the redshift, very much like human-experts proceed.
    When ran on BOSS data to identify quasars through their emission lines,
    QuasarNET defines a sample $99.51\pm0.03$\% pure and $99.52\pm0.03$\% complete,
    well above the requirements of many analyses using these data. QuasarNET
    significantly reduces the problem of line-confusion that induces catastrophic
    redshift failures to below 0.2\%. We also extend QuasarNET to classify spectra
    with broad absorption line (BAL) features, achieving an accuracy of
    $98.0\pm0.4$\% for recognizing BAL and $97.0\pm0.2$\% for rejecting non-BAL
    quasars. QuasarNET is trained on data of low signal-to-noise and medium
    resolution, typical of current and future astrophysical surveys, and could be
    easily applied to classify spectra from current and upcoming surveys such as
    eBOSS, DESI and 4MOST.
    </p>
    """)
  check(item.author == """<a href="http://arxiv.org/find/astro-ph/1/au:+Busca_N/0/1/0/all/0/1">Nicolas Busca</a>, <a href="http://arxiv.org/find/astro-ph/1/au:+Balland_C/0/1/0/all/0/1">Christophe Balland</a>""")
  check(item.category == nil)
  check(item.comments == nil)
  check(item.enclosure == RSSEnclosure())
  check(item.guid == nil)
  check(item.pubDate == nil)
  check(item.sourceUrl == nil)
  check(item.sourceText == nil)
