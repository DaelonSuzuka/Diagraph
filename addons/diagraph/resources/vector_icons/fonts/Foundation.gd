
const FontData = preload("Foundation.ttf")
const Cheatsheet = {
	"address-book": "\uF100",
	"alert": "\uF101",
	"align-center": "\uF102",
	"align-justify": "\uF103",
	"align-left": "\uF104",
	"align-right": "\uF105",
	"anchor": "\uF106",
	"annotate": "\uF107",
	"archive": "\uF108",
	"arrow-down": "\uF109",
	"arrow-left": "\uF10A",
	"arrow-right": "\uF10B",
	"arrow-up": "\uF10C",
	"arrows-compress": "\uF10D",
	"arrows-expand": "\uF10E",
	"arrows-in": "\uF10F",
	"arrows-out": "\uF110",
	"asl": "\uF111",
	"asterisk": "\uF112",
	"at-sign": "\uF113",
	"background-color": "\uF114",
	"battery-empty": "\uF115",
	"battery-full": "\uF116",
	"battery-half": "\uF117",
	"bitcoin": "\uF119",
	"bitcoin-circle": "\uF118",
	"blind": "\uF11A",
	"bluetooth": "\uF11B",
	"bold": "\uF11C",
	"book": "\uF11E",
	"book-bookmark": "\uF11D",
	"bookmark": "\uF11F",
	"braille": "\uF120",
	"burst": "\uF123",
	"burst-new": "\uF121",
	"burst-sale": "\uF122",
	"calendar": "\uF124",
	"camera": "\uF125",
	"check": "\uF126",
	"checkbox": "\uF127",
	"clipboard": "\uF12A",
	"clipboard-notes": "\uF128",
	"clipboard-pencil": "\uF129",
	"clock": "\uF12B",
	"closed-caption": "\uF12C",
	"cloud": "\uF12D",
	"comment": "\uF131",
	"comment-minus": "\uF12E",
	"comment-quotes": "\uF12F",
	"comment-video": "\uF130",
	"comments": "\uF132",
	"compass": "\uF133",
	"contrast": "\uF134",
	"credit-card": "\uF135",
	"crop": "\uF136",
	"crown": "\uF137",
	"css3": "\uF138",
	"database": "\uF139",
	"die-five": "\uF13A",
	"die-four": "\uF13B",
	"die-one": "\uF13C",
	"die-six": "\uF13D",
	"die-three": "\uF13E",
	"die-two": "\uF13F",
	"dislike": "\uF140",
	"dollar": "\uF142",
	"dollar-bill": "\uF141",
	"download": "\uF143",
	"eject": "\uF144",
	"elevator": "\uF145",
	"euro": "\uF146",
	"eye": "\uF147",
	"fast-forward": "\uF148",
	"female": "\uF14A",
	"female-symbol": "\uF149",
	"filter": "\uF14B",
	"first-aid": "\uF14C",
	"flag": "\uF14D",
	"folder": "\uF150",
	"folder-add": "\uF14E",
	"folder-lock": "\uF14F",
	"foot": "\uF151",
	"foundation": "\uF152",
	"graph-bar": "\uF153",
	"graph-horizontal": "\uF154",
	"graph-pie": "\uF155",
	"graph-trend": "\uF156",
	"guide-dog": "\uF157",
	"hearing-aid": "\uF158",
	"heart": "\uF159",
	"home": "\uF15A",
	"html5": "\uF15B",
	"indent-less": "\uF15C",
	"indent-more": "\uF15D",
	"info": "\uF15E",
	"italic": "\uF15F",
	"key": "\uF160",
	"laptop": "\uF161",
	"layout": "\uF162",
	"lightbulb": "\uF163",
	"like": "\uF164",
	"link": "\uF165",
	"list": "\uF169",
	"list-bullet": "\uF166",
	"list-number": "\uF167",
	"list-thumbnails": "\uF168",
	"lock": "\uF16A",
	"loop": "\uF16B",
	"magnifying-glass": "\uF16C",
	"mail": "\uF16D",
	"male": "\uF170",
	"male-female": "\uF16E",
	"male-symbol": "\uF16F",
	"map": "\uF171",
	"marker": "\uF172",
	"megaphone": "\uF173",
	"microphone": "\uF174",
	"minus": "\uF176",
	"minus-circle": "\uF175",
	"mobile": "\uF178",
	"mobile-signal": "\uF177",
	"monitor": "\uF179",
	"mountains": "\uF17A",
	"music": "\uF17B",
	"next": "\uF17C",
	"no-dogs": "\uF17D",
	"no-smoking": "\uF17E",
	"page": "\uF18E",
	"page-add": "\uF17F",
	"page-copy": "\uF180",
	"page-csv": "\uF181",
	"page-delete": "\uF182",
	"page-doc": "\uF183",
	"page-edit": "\uF184",
	"page-export": "\uF188",
	"page-export-csv": "\uF185",
	"page-export-doc": "\uF186",
	"page-export-pdf": "\uF187",
	"page-filled": "\uF189",
	"page-multiple": "\uF18A",
	"page-pdf": "\uF18B",
	"page-remove_at": "\uF18C",
	"page-search": "\uF18D",
	"paint-bucket": "\uF18F",
	"paperclip": "\uF190",
	"pause": "\uF191",
	"paw": "\uF192",
	"paypal": "\uF193",
	"pencil": "\uF194",
	"photo": "\uF195",
	"play": "\uF198",
	"play-circle": "\uF196",
	"play-video": "\uF197",
	"plus": "\uF199",
	"pound": "\uF19A",
	"power": "\uF19B",
	"previous": "\uF19C",
	"price-tag": "\uF19D",
	"pricetag-multiple": "\uF19E",
	"print": "\uF19F",
	"prohibited": "\uF1A0",
	"projection-screen": "\uF1A1",
	"puzzle": "\uF1A2",
	"quote": "\uF1A3",
	"record": "\uF1A4",
	"refresh": "\uF1A5",
	"results": "\uF1A7",
	"results-demographics": "\uF1A6",
	"rewind": "\uF1A9",
	"rewind-ten": "\uF1A8",
	"rss": "\uF1AA",
	"safety-cone": "\uF1AB",
	"save": "\uF1AC",
	"share": "\uF1AD",
	"sheriff-badge": "\uF1AE",
	"shield": "\uF1AF",
	"shopping-bag": "\uF1B0",
	"shopping-cart": "\uF1B1",
	"shuffle": "\uF1B2",
	"skull": "\uF1B3",
	"social-500px": "\uF1B4",
	"social-adobe": "\uF1B5",
	"social-amazon": "\uF1B6",
	"social-android": "\uF1B7",
	"social-apple": "\uF1B8",
	"social-behance": "\uF1B9",
	"social-bing": "\uF1BA",
	"social-blogger": "\uF1BB",
	"social-delicious": "\uF1BC",
	"social-designer-news": "\uF1BD",
	"social-deviant-art": "\uF1BE",
	"social-digg": "\uF1BF",
	"social-dribbble": "\uF1C0",
	"social-drive": "\uF1C1",
	"social-dropbox": "\uF1C2",
	"social-evernote": "\uF1C3",
	"social-facebook": "\uF1C4",
	"social-flickr": "\uF1C5",
	"social-forrst": "\uF1C6",
	"social-foursquare": "\uF1C7",
	"social-game-center": "\uF1C8",
	"social-github": "\uF1C9",
	"social-google-plus": "\uF1CA",
	"social-hacker-news": "\uF1CB",
	"social-hi5": "\uF1CC",
	"social-instagram": "\uF1CD",
	"social-joomla": "\uF1CE",
	"social-lastfm": "\uF1CF",
	"social-linkedin": "\uF1D0",
	"social-medium": "\uF1D1",
	"social-myspace": "\uF1D2",
	"social-orkut": "\uF1D3",
	"social-path": "\uF1D4",
	"social-picasa": "\uF1D5",
	"social-pinterest": "\uF1D6",
	"social-rdio": "\uF1D7",
	"social-reddit": "\uF1D8",
	"social-skillshare": "\uF1D9",
	"social-skype": "\uF1DA",
	"social-smashing-mag": "\uF1DB",
	"social-snapchat": "\uF1DC",
	"social-spotify": "\uF1DD",
	"social-squidoo": "\uF1DE",
	"social-stack-overflow": "\uF1DF",
	"social-steam": "\uF1E0",
	"social-stumbleupon": "\uF1E1",
	"social-treehouse": "\uF1E2",
	"social-tumblr": "\uF1E3",
	"social-twitter": "\uF1E4",
	"social-vimeo": "\uF1E5",
	"social-windows": "\uF1E6",
	"social-xbox": "\uF1E7",
	"social-yahoo": "\uF1E8",
	"social-yelp": "\uF1E9",
	"social-youtube": "\uF1EA",
	"social-zerply": "\uF1EB",
	"social-zurb": "\uF1EC",
	"sound": "\uF1ED",
	"star": "\uF1EE",
	"stop": "\uF1EF",
	"strikethrough": "\uF1F0",
	"subscript": "\uF1F1",
	"superscript": "\uF1F2",
	"tablet-landscape": "\uF1F3",
	"tablet-portrait": "\uF1F4",
	"target": "\uF1F6",
	"target-two": "\uF1F5",
	"telephone": "\uF1F8",
	"telephone-accessible": "\uF1F7",
	"text-color": "\uF1F9",
	"thumbnails": "\uF1FA",
	"ticket": "\uF1FB",
	"torso": "\uF1FE",
	"torso-business": "\uF1FC",
	"torso-female": "\uF1FD",
	"torsos": "\uF203",
	"torsos-all": "\uF200",
	"torsos-all-female": "\uF1FF",
	"torsos-female-male": "\uF201",
	"torsos-male-female": "\uF202",
	"trash": "\uF204",
	"trees": "\uF205",
	"trophy": "\uF206",
	"underline": "\uF207",
	"universal-access": "\uF208",
	"unlink": "\uF209",
	"unlock": "\uF20A",
	"upload": "\uF20C",
	"upload-cloud": "\uF20B",
	"usb": "\uF20D",
	"video": "\uF20E",
	"volume": "\uF211",
	"volume-none": "\uF20F",
	"volume-strike": "\uF210",
	"web": "\uF212",
	"wheelchair": "\uF213",
	"widget": "\uF214",
	"wrench": "\uF215",
	"x": "\uF217",
	"x-circle": "\uF216",
	"yen": "\uF218",
	"zoom-in": "\uF219",
	"zoom-out": "\uF21A"
}
