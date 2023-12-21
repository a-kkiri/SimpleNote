/*
  本模板修改自 jsk-lecnotes
    + 添加中文环境
    + 修改封面布局
    + 添加必要字体
*/

#import "@preview/whalogen:0.1.0": ce
#import "@preview/codelst:1.0.0": sourcecode, codelst
#import "@preview/showybox:2.0.1": showybox
#import "@preview/ctheorems:1.0.0": *

#let template(
  // 笔记标题
  title: "Lecture Notes Title",

  // 在页眉展示的短标题
  short_title: none,

  // 笔记描述（可选），例如:
  // description: [A template for simple notes]
  description: none,

  // 笔记创建日期（可选），例如：
  // datetime(year: 2020, month: 02, day: 02)
  date: none,

  // 作者信息（除 name 外，其他参数可选）
  authors: (
      // name: "",
      // github: "",
      // link: "",
      // affiliations: "1,2",
  ),

  // 所属机构列表，每一项包括一个 id 和 name。这些将显示在作者下方。
  affiliations: (
    // (id: "1", name: "Organization 1"),
    // (id: "2", name: "Organization 2"),
  ),

  // 参考书目文件路径
  bibliography_file: none,
  // 参考文献引用样式
  bibstyle: "apa",

  // 页面尺寸，同时会影响页边距。
  paper_size: "a4",

  // 页面的列数
  cols: 1,

  // 文本和代码的字体
  text_font: "Linux Libertine",
  sc_font: "Noto Sans CJK SC",
  code_font: "DejaVu Sans Mono",

  // 主题颜色，必须是 HEX 颜色.
  accent: "#000000",

  // 笔记内容
  body

) = {

  // 使用 ctheorems 包
  show: thmrules

  // 中文粗体，斜体
  show strong: set text(font: (text_font, sc_font))
  show emph: text.with(font: (text_font, sc_font))
  // set text(cjk-latin-spacing: auto)

  // Github Logo
  let githubSvg = ```<svg xmlns="http://www.w3.org/2000/svg" width="32" height="24" viewBox="0 0 24 24"><path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/></svg>```.text

  let accent_color = rgb(accent)

  // 设置文档元数据
  set document(title: title, author: authors.map(author => author.name))

  // 设置正文和代码的字体
  set text(font: (text_font, sc_font), size: 12pt, lang: "zh", region: "cn")
  show raw: set text(font: code_font, 10pt)

  // 将链接设置蓝色并加下划线，并且对于作者列表禁用此设置。
  show link: it => {
    let author_names = ()
    for author in authors {
      author_names.push(author.name)
    }

    if it.body.has("text") and it.body.text in author_names {
      it
    } else {
      underline(stroke: (dash: "densely-dotted"), text(fill: blue, it)) 
    }
  }

  // 配置页面
  set page(
    paper: paper_size,
    columns: cols,
    numbering: "1 / 1",
    number-align: center,
    // 页边距
    margin: auto,

    header: locate(loc => {
      if loc.page() == 1{return}
      let footers = query(selector(<__footer__>).after(loc), loc)

      let elems = query(
        heading.where(level: 1).before(footers.first().location()), footers.first().location()
      )

      let head_title = text(fill: accent_color)[
        #if short_title != none { short_title } else { title }
      ]
      
      if calc.even(loc.page()) == true {
        emph(elems.last().body) + h(1fr) + emph(head_title)
      }else{
        emph(head_title) + h(1fr) + emph(elems.last().body)
      }
      
      v(-7pt)
      align(center)[#line(length: 105%, stroke: (thickness: 1pt, paint: accent_color, dash: "solid"))]
      
    }),

    footer: locate(loc => {
      if loc.page() == 1 {return}
      [
      #if calc.even(loc.page()) == true {
        align(left)[#counter(page).display("1 / 1",both: true,)]
      }else{
        align(right)[#counter(page).display("1 / 1",both: true,)]
      }
      #label("__footer__")
      ]
    })
  )

  // 配置列表
  set enum(tight:false, indent: 2em, body-indent: 6pt)
  set list(tight:false, indent: 2em, body-indent: 6pt)

  // 章节计数器
  let chaptercounter = counter("chapter")

  // 配置标题
  set heading(numbering: "1.1.1.1.1.")

  show heading: it => box(width: 100%)[
    #if it.numbering != none { counter(heading).display() }
    #it.body
    #v(12pt, weak: true)

    #if it.level == 1 and it.numbering != none{
      chaptercounter.step()
    }
  ]

  // 配置一级标题
  show heading.where(
    level: 1
  ): it => box(width: 100%)[
    #set align(left)
    #set heading(numbering: "章节 1. ")
    #it
    #v(-8pt)
    #line(length:100%, stroke: gray)
    #v(8pt)
  ]

  // 配置公式的编号和间距
  set math.equation(
    numbering: (..nums) => locate(loc => {
      numbering("(1.1)", chaptercounter.at(loc).first(), ..nums)
    })
  )
  
  show math.equation: eq => {
    set block(spacing: 0.65em)
    eq
  }

  // 配置图像和图像编号
  set figure(
    numbering: (..nums) => locate(loc => {
      numbering("1.1", chaptercounter.at(loc).first(), ..nums)
    })
  )

  // set figure(placement: auto)
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  show figure.where(
    kind: raw
  ): it => {
    set block(width: 100%, breakable: true)
    it
  }

  // 配置行内代码块
  show raw.where(
    block: false,
  ): it => box(fill: luma(240), inset: (x: 2pt), outset: (y: 3pt), radius: 1pt)[#it]

  show: codelst(reversed: true)

  //------------------------------------------------------------------

  v(175pt)
  // 显示论文的标题和描述。
  align(right, [
    #set text(36pt, weight: "bold")
    #title
    ])
  if description != none {
    align(right, box(width: 90%)[
      #set text(size: 16pt, style: "italic")
      #description
    ])
  }
  v(18pt, weak: true)

  // 作者和所属机构
  align(right)[
    #if authors.len() > 0 {
      box(inset: (y: 10pt), {
        authors.map(author => {
          text(16pt, weight: "semibold")[
            #if "homepage" in author {
              [#link(author.homepage)[#author.name]]
            } else { author.name }]
          if "affiliations" in author {
            super(author.affiliations)
          }
          if "github" in author {
            link(author.github, box(height: 1.1em, baseline: 13.5%)[#image.decode(githubSvg)])
          }
        }).join(", ", last: {
          if authors.len() > 2 {
            ", and"
          } else {
            " and"
          }
        })
      })
    }
    #v(-2pt, weak: true)
    #if affiliations.len() > 0 {
      box(inset: (bottom: 10pt), {
        affiliations.map(affiliation => {
          text(12pt)[
            #super(affiliation.id)#h(1pt)#affiliation.name
          ]
        }).join(", ")
      })
    }
  ]

  v(300pt, weak: true)

  // 显示笔记的最后更新日期。
  if date != none {
  align(left, table(
    columns: (auto),
    stroke: none,
    gutter: 0pt,
    align: (right, left),
    [
      #text(size: 12pt, "最初写作于")
      #text(
        size: 12pt,
        fill: accent_color,
        weight: "semibold",
        date.display("[month repr:long] [day padding:zero], [year repr:full]")
      )
    ],
    [
      #text(size: 12pt, "最后更新于")
      #text(
        size: 12pt,
        fill: accent_color,
        weight: "semibold",
        datetime.today().display("[month repr:long] [day padding:zero], [year repr:full]")
      )
    ]
  ))
  } else {
    align(center,
    text(size: 11pt)[Last updated:#h(5pt)] + text(
      size: 11pt,
      fill: accent_color,
      weight: "semibold",
      datetime.today().display(
        "[month repr:long] [day padding:zero], [year repr:full]"
      )
    )
    )
  }
  v(18pt, weak: true)

  pagebreak()

  show outline.entry: it => {
    text(fill: accent_color)[#it]
  }

  // 显示笔记的目录
  outline(indent: auto)

  
  v(24pt, weak: true)

  // 将段落设置为两端对齐，并设置换行。
  set par(justify: true, linebreaks: "optimized", leading: 0.8em)

  pagebreak()

  // 显示笔记的内容
  body

  pagebreak()

  // 显示参考文献
  if bibliography_file != none {
    show bibliography: set text(10.5pt)
    bibliography(bibliography_file, title: "参考文献", style: "gb-7714-2015-numeric")
  }
}


// 函数===========================================================

// 配置块引用
#let blockquote(cite: none, body) = [
  #set text(size: 10.5pt)
  #pad(left: 0.5em)[
    #block(
    breakable: true,
    width: 100%,
    fill: gray.lighten(95%),
    radius: (left: 2pt, right: 5pt),
    stroke: (left: 4pt + eastern, rest: 1pt + silver),
    inset: 1em
    )[#body]
  ]
]

// 水平标尺
#let horizontalrule = [#v(0.5em) #line(start: (20%,0%), end: (80%,0%)) #v(0.5em)]

// 另外的水平标尺
#let sectionline = align(center)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]

// 尝试添加 LaTeX 中的 \boxed{} 命令
#let dboxed(con) = box(stroke: 0.5pt + black, outset: (x: 2pt), inset: (y: 8pt), baseline: 11pt, $display(#con)$)
#let iboxed(con) = box(stroke: 0.5pt + black, outset: (x: 2pt), inset: (y: 3pt), baseline: 2pt, $#con$)

// ==== 使用 showybox 和 ctheorems 包创建盒子 ====
//
// |   环境   |  强调色                |
// |---------|-----------------------|
// |   定义   |  olive                |
// |   示例   |  purple               |
// |   提示   |  blue                 |
// |   注意   |  red / rgb("#DC143C") |
// |   引用   |  black                |
// |   定理   |  navy                 |  
// |   命题   |  maroon               |

#let boxnumbering = "1.1.1.1.1.1"
#let boxcounting = "heading"

#let definition = thmenv(
  "definition",
  "Definition",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) #text[定义 #number]],
      frame: (
        border-color: olive,
        title-color:  olive.lighten(30%),
        body-color:   olive.lighten(95%),
        footer-color: olive.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let example = thmenv(
  "example",
  "Example",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) 示例 #number],
      frame: (
        border-color: purple,
        title-color:  purple.lighten(30%),
        body-color:   purple.lighten(95%),
        footer-color: purple.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let tip = thmenv(
  "tip",
  "Tip",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) 提示 #number],
      frame: (
        border-color: blue,
        title-color:  blue.lighten(30%),
        body-color:   blue.lighten(95%),
        footer-color: blue.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let attention = thmenv(
  "attention",
  "Attention",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) 注意 #number],
      frame: (
        border-color: rgb("#DC143C"),
        title-color:  rgb("#DC143C").lighten(30%),
        body-color:   rgb("#DC143C").lighten(95%),
        footer-color: rgb("#DC143C").lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let quote = thmenv(
  "quote",
  "Quote",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) 引用 #number],
      frame: (
        border-color: black,
        title-color:  black.lighten(30%),
        body-color:   black.lighten(95%),
        footer-color: black.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let theorem = thmenv(
  "theorem",
  "Theorem",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) 定理 #number],
      frame: (
        border-color: navy,
        title-color:  navy.lighten(30%),
        body-color:   navy.lighten(95%),
        footer-color: navy.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)

#let proposition = thmenv(
  "proposition",
  "Proposition",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      title: [#name #h(1fr) 命题 #number],
      frame: (
        border-color: maroon,
        title-color:  maroon.lighten(30%),
        body-color:   maroon.lighten(95%),
        footer-color: maroon.lighten(80%),
      ),
      ..args.named(),
      body
    )
  }
).with(numbering: boxnumbering)