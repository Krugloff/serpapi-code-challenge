Code Challenge
==========================================================================================

Intro
------------------------------------------------------------------------------------------

Original description of the challenge placed [here](CHALLENGE.md)

I guess it's a good challenge so I play with that for a bit. I tried different styles of parsing and added solutions for actual responses (initial response is 5 years old I guess), including a few types of carousel and one type of masonry (for the same request Google can return different layouts sometimes).

**Yeah, I know "you shouldn't use regexp for parsing html"**

I'm agreed with two exceptions:

+ you need parse something as fast as possible (Nokogiri and alternatives will spent some time to parse large html tree even if you need only a few elements)
+ regexp working good for custom components w/o nested levels (ok, it's possible to use recursive regexp but that's not so easy)
+ Looks like string scanner is good and fast for parsing script elements. It will be interesting to compare that with any of javascript syntax tree parsers.

Results
------------------------------------------------------------------------------------------

Average results based on parsing of 1000 html files (see `/benchmarks/time.rb`).

```
FIRST VARIANT 
(van-gogh-paintings.html)
51 entries
RegexpBased:        2.66
NokogiriBased:      7.74 (nokogiri spents 5sec to parse 1000 html files)
NokolexborBased:    2.95
StringScannerBased: 1.32
```

```
SECOND VARIANT (us-presidents.html, tries to find FIRST VARIANT then switch to SECOND)
46 entries
RegexpBased:        3.26
NokogiriBased:      8.26
NokolexborBased:    3.31
StringScannerBased: 1.62
```

```
THIRD VARIANT 
(dune-actors.html, tries FIRST, then SECOND, then THIRD)
11 entries
RegexpBased:        1.37
NokogiriBased:      7.73
NokolexborBased:    2.78
StringScannerBased: 1.04
```

```
FOURTH VARIANT 
(colorado-cities.html, tries to find FIRST VARIANT then switch to SECOND)
51 entries
RegexpBased:        3.84
NokogiriBased:      9.04
NokolexborBased:    3.73
StringScannerBased: 1.98
```

```
MASONRY VARIANT 
(van-gogh-paintings.html, tries to find carousel then switch to Masonry)
46 entries
RegexpBased:        4.76
NokogiriBased:     11.04
NokolexborBased:    4.42
StringScannerBased: 1.97
```

```
UNKNOWN VARIANT
(unknown-variant.html, tries to find Carousel, then tries to find Masonry, then fail)
It's useful to check how much time we need to fail so I removed some chars from carousel tag.
For example Nokogiri and Nokolexbor will spent time to build html tree
even without correct variants.

RegexpBased:        2.60
NokogiriBased:      7.29
NokolexborBased:    2.60
StringScannerBased: 0.69
```

Notes
------------------------------------------------------------------------------------------

+ See ya, Nokogiri.
+ I tried to not use generated classes. It is hard is some cases and looks like Google have a plan to use them a lot. I guess it's fine to use them if you have a hourly/daily jobs that checking used class has not be refreshed or you have a stats that changes have been never happened in a five years.
+ String scanner based parsing is fastest but it strictly depends on order of elements/attrs and can produce garbage data more often than other solutions. Also I don't know how it will work if you need to convert full page to JSON result (I imagine this variant can be powered with parallel workers). Complexity and time of creation also are bigger.

Installation
------------------------------------------------------------------------------------------

You need to install some gems (nokogiri, nokolexbor, memory_profiler, rspec) with a bundler. I used ruby-3.2.4.

`bunle install`

Index
------------------------------------------------------------------------------------------

+ `/benchmarks` - run this scripts to check the average time or memory allocated.
+ `/files` - google search result html files, its prettified versions, expected parsing result and screenshots.
+ `/specs` - a lot of tests general for each variant of parsing.
+ `/src` - ruby code.

Actual vs Original
------------------------------------------------------------------------------------------

### Van gogh paintings Masonry

![Van Gogh Paintings Masonry](/files/van-gogh-paintings-masonry.png)

The page does not contain custom components like 'g-carousel' and contains only generated classes basically so it's difficult to parse something with the Regular expressions or StringScanner (I'm not master of the recursive regexp unfortunately).

Then current version is not so safe and good.

### US presidents

![US Presidents](/files/us-presidents.png)

#### Cards

+ Link element `<a>` doesn't have `klitem` class attribute. It has `klitem-tr` class attribute and contains `<div class='klitem'>` child instead.
+ `href` attributed placed before `aria-label` attribute it can be important for code that based on explicit order.

```HTML
<a
  jscontroller="e8Ezlf"
  jsname="I4kCu"
  CLASS="ct5Ked klitem-tr PZPZlf"
  aria-selected="false"
  aria-setsize="46"
  data-entityid="/m/012gx2"
  data-entityname="Joe Biden"
  HREF="/search?something"
  role="tab"
  title="Joe Biden (2021-)"
  ARIA-LABEL="Joe Biden"
  jsdata="Cls7rd;_;B+9CXg"
  jsaction="rcuQ6b:npT2md"
  data-hveid="CCMQBw"
  data-ved="2ahUKEwj82tmG4pCHAxV3MTQIHQ5xAZYQ-BZ6BAgjEAc"
>
```

#### Thumbnails

Each thumbnail blob placed inside own `<script>` element instead one big `<script>` in the original example.

```HTML
<script nonce="aX9jIq1cdIXQinWOtdsHrA">
  window._setImagesSrc...
</script>
<script nonce="aX9jIq1cdIXQinWOtdsHrA">
  (function () {
    var s =
      "data:image/jpeg;base64,...";
    var ii = ["dimg_1"];
    _setImagesSrc(ii, s);
  })();
</script>
...
```

#### Images

A half of carousel cards don't contain `<img>` (for optimization purposes I guess). Ideally we should find a way to fetch it but I will skip this functional for now.

```HTML
<a
  jscontroller="e8Ezlf"
  jsname="I4kCu"
  class="ct5Ked klitem-tr PZPZlf"
  aria-selected="false"
  aria-setsize="46"
  data-entityid="/m/034rd"
  data-entityname="George Washington"
  href="/search?something"
  id="_JluIZvyvF_fi0PEPjuKFsAk_109"
  role="tab"
  title="George Washington (1789-1797)"
  aria-label="George Washington"
  jsdata="Cls7rd;_;B+9CXg"
  jsaction="rcuQ6b:npT2md"
  data-hveid="CCMQjgE"
  data-ved="2ahUKEwj82tmG4pCHAxV3MTQIHQ5xAZYQ-BZ6BQgjEI4B"
></a>
```

#### Extensions

Extension's `<div>` doesn't have a `klmeta` class. It has a generated not uniqal class `FozYP` and placed in the last `<div>` before link close tag `</a>`

```HTML
...
      <div jsname="QUk9kd" class="WGwSK SoZvjb">
        <div class="dAassd">
          <div><div class="FozYP">Joe Biden</div></div>
          <div class="cp7THd"><div class="FozYP">2021-</div></div>
        </div>
      </div>
    </div>
  </div>
</a>
```

A lot of data placed in a scripts (for lazy loading maybe?). I will skip it for now.

```HTML
<a
  jscontroller="e8Ezlf"
  jsname="I4kCu"
  class="ct5Ked klitem-tr PZPZlf"
  aria-selected="false"
  aria-setsize="46"
  data-entityid="/m/02yy8"
  data-entityname="Franklin D. Roosevelt"
  href="/search?something"
  id="_JluIZvyvF_fi0PEPjuKFsAk_47"
  role="tab"
  title="Franklin D. Roosevelt (1933-1945)"
  aria-label="Franklin D. Roosevelt"
  jsdata="Cls7rd;_;B+9CXg"
  jsaction="rcuQ6b:npT2md"
  data-hveid="CCMQMQ"
  data-ved="2ahUKEwj82tmG4pCHAxV3MTQIHQ5xAZYQ-BZ6BAgjEDE"
></a>
```

```JS
// see a[id]
(function () {
  window.jsl.dh(
    "_JluIZvyvF_fi0PEPjuKFsAk_47",
    "\x3cdiv jsname\x3d\x22tc98Ke\x22 aria-hidden\x3d\x22true\x22 class\x3d\x22klitem EsIlz\x22 tabindex\x3d\x22-1\x22\x3e\x3cdiv jsname\x3d\x22vgzRDe\x22 class\x3d\x22UnFsfe SoZvjb\x22 aria-hidden\x3d\x22true\x22\x3e\x3cdiv jsname\x3d\x22mfX1bc\x22 class\x3d\x22keP9hb\x22\x3e\x3c/div\x3e\x3cdiv jsname\x3d\x22fmfJsc\x22 class\x3d\x22XAOBve\x22\x3e\x3cg-img class\x3d\x22ZGomKf\x22 style\x3d\x22height:120px;width:120px;background-color:#27211B\x22\x3e\x3cimg data-src\x3d\x22https://encrypted-tbn0.gstatic.com/images?q\x3dtbn:ANd9GcSPJ_0t1v3fLwEbR5-vVgMp1YAdfRLdeIV_gB5UNuXR0plsBUX-KERc\x26amp;s\x3d0\x22 src\x3d\x22data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw\x3d\x3d\x22 jscontroller\x3d\x22TSZEqd\x22 jsaction\x3d\x22load:K1e2pe;BUYwVb:eNYuKb;LsLGHf:KpWyKc;rcuQ6b:npT2md\x22 class\x3d\x22YQ4gaf\x22 height\x3d\x22120\x22 width\x3d\x22120\x22 alt\x3d\x22Franklin D. Roosevelt\x22\x3e\x3c/g-img\x3e\x3c/div\x3e\x3cdiv jsname\x3d\x22QUk9kd\x22 class\x3d\x22WGwSK SoZvjb\x22\x3e\x3cdiv class\x3d\x22dAassd\x22\x3e\x3cdiv\x3e\x3cdiv class\x3d\x22FozYP\x22\x3eFranklin D. \x3c/div\x3e\x3cdiv class\x3d\x22FozYP\x22\x3eRoosevelt\x3c/div\x3e\x3c/div\x3e\x3cdiv class\x3d\x22cp7THd\x22\x3e\x3cdiv class\x3d\x22FozYP\x22\x3e1933-1945\x3c/div\x3e\x3c/div\x3e\x3c/div\x3e\x3c/div\x3e\x3c/div\x3e\x3c/div\x3e"
  );
})();
```

#### Fields Naming

Since it is not artworks anymore we should rename this field to neutral or dynamically change the file name based on queries. I will skip this issue for now.

### Dune actors

![Dune Actors](/files/dune-actors.png)

#### Cards

Link elements don't have `aria-label` attribute. We can use `title` attribute instead.

```HTML
<a
  class="ttwCMe"
  style="width: 92px;"
  title="Christopher Walken"
  href="/search?something"
>
```

Carousel ended with a link element that not a card.

```HTML
<div class="VgWAtf">
  <a
    class="LcmtUb oRJe3d"
    jscontroller="PCqCoe"
    data-ti="FilmCast"
    role="link"
    tabindex="0"
    jsaction="rcuQ6b:npT2md;KjsqPd"
    data-ved="2ahUKEwjHqJ-64ZCHAxWmweYEHb3nAHkQ9JYCKAt6BAhJEBk"
  >
    <div>
      <div class="VDgVie btku5b k0Jjg fCrZyc NQYJvc x2GJWb OJeuxf PrjL8c">
        ...
        <div class="QuU3Wb sjVJQd">View all</div>
      </div>
    </div>
  </a>
</div>
```

Important links placed inside of `<div role="listitem">` elements.

```HTML
<div
  jsname="ibnC6b"
  data-attrid="kc:/film/film:cast"
  role="listitem"
  jscontroller="qlogIf"
  class="PZPZlf FQ7nIf nZWEZc ojFefc Si5xMe"
  jsaction="rcuQ6b:npT2md"
  data-item-card="true"
  data-hveid="CEkQFw"
  data-ved="2ahUKEwjHqJ-64ZCHAxWmweYEHb3nAHkQ_uMBKAp6BAhJEBc"
>
  <a ...
```

#### Extensions

Extension's `<div>` doesn't have a `klmeta` class. It has a few generated classes and `ellip` class and placed in the last `<div>` before link close tag `</a>`

```HTML
      <div class="Bo9xMe">
        <div class="oyj2db OSrXXb" aria-level="3" role="heading">Dave Bautista</div>
        <div class="wwLdc"><div class="MVXjze ellip buTsJf">Rabban</div></div>
      </div>
    </div>
  </div>
</a>
```

#### Images

+ images don't placed inside `<g-img>` elements
+ a half of images don't have `id` attribute for thumbnails search (We can download images through `data-src` to fetch it but I will skip this functional for now).

#### Fields Naming

Since it is not artworks anymore we should rename this field to neutral or dynamically change the file name based on queries. I will skip this issue for now.

### Colorado Cities

![Colorado Cities](/files/colorado-cities.png)

#### Cards

Unfortunately, cards contains city name info inside the same `FozYP` element that we used to find a meta. Then we can't simple use this class or last div. 

There is a two solutions I see: 

+ we can check that name doesn't include meta
+ or we can use `a['title'] - a['aria-label']`

```HTML
        </g-img>
      </div>
      <div jsname="QUk9kd" class="WGwSK ghJsNe">
        <div class="dAassd">
          <div>
            <div class="FozYP">Colorado</div>
            <div class="FozYP">Springs</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</a>
```

TODO
------------------------------------------------------------------------------------------

+ What exactly will happens if carousel is found, `a.klmeta` link is found but order of attributes was changed or `aria-label` attribute is missing?
  + we need add more specs for each component and false cases (see commented specs)
  + there is a two exceptions should exists
    + ElementNotFound means we need to try masonry
    + ElemenInvalid means we need to stop with the error (for example the carousel card format is invalid)
+ Both layouts - carousel and masonry require the same thumbnails map. So if this part is missing we need to stop execution with the error instead trying next associated layout.
+ 'artworks' field name is not correct for all cases
+ the quotes are matter, so single instead double will destroy the city
+ we need to check more masonry examples
+ there is a good chance to play with the RBS files
+ constants overloading for carousel cards can be refactored