#import "@preview/showybox:2.0.1": showybox
#import "@preview/codelst:2.0.1": sourcecode
#import "@preview/ctheorems:1.1.2": *
#import "resource.typ": *

/*
  本模板修改自 jsk-lecnotes
    + 添加中文环境
    + 修改封面布局
    + 添加必要字体
*/

#let template(
  // 笔记标题
  title: "Lecture Notes Title",
  short-title: none,
  description: none,
  date: none,

  authors: (

  ),

  affiliations: (

  ),

  bibliography-file: none,
  bibstyle: "gb-7714-2015-numeric",

  paper-size: "a4",

  fonts: (
    (
      en-font: "Linux Libertine",
      zh-font: "Noto Sans CJK SC",
      code-font: "DejaVu Sans Mono",
    )
  ),

  accent: "#000000",
  cover-image: none,
  background-color: none,

  body
) = {

  let accent-color = rgb(accent)

  // 使用 ctheorems 包
  show: thmrules

  // 设置正文和代码的字体
  set text(font: (fonts.en-font, fonts.zh-font), size: 12pt, lang: "zh", region: "cn")
  show raw: set text(font: fonts.code-font, 10pt)

  // 设置中文粗体，斜体
  show strong: set text(fill: accent-color, font: (fonts.en-font, fonts.zh-font))
  show emph: set text(font: (fonts.en-font, fonts.zh-font))

  // 设置文档元数据
  set document(title: title, author: authors.map(author => author.name))

  // 将链接设置蓝色并加下划线，并且对于作者列表禁用此设置。
  show link: it => {
    let author-names = ()
    for author in authors {
      author-names.push(author.name)
    }

    if it.body.has("text") and it.body.text in author-names {
      it
    } else {
      underline(stroke: (dash: "densely-dotted"), text(fill: blue, it)) 
    }
  }

  // 文本高亮
  // set highlight(fill: accent-color.lighten(50%))

  // 计数器
  let chaptercounter = counter("chapter")

  // 配置页面
  set page(
    paper: paper-size,
    numbering: "1 / 1",
    number-align: center,
    // 页边距
    margin: (x:1.6cm, y:2.3cm),

    // 封面图片和背景图片
    background: locate(loc => {
      if loc.page() == 1 and cover-image != none {
        block(width:100%, height: 100%)[#image(cover-image, width: 100%, height: 100%)]
      } else if background-color != none{
        block(width:100%, height:100%, fill: rgb(background-color))
      }
    }),

    header: locate(loc => {
      if loc.page() == 1{return}

      let elems = query(heading.where(level: 1).after(loc))

      let chapter-title = ""

      if(elems == () or elems.first().location().page() != loc.page()){
        let elems = query(heading.where(level: 1).before(loc))
        chapter-title = elems.last().body
      }else{
        chapter-title = elems.first().body
      }
      
      let head-title = text()[
        #if short-title != none {short-title} else {title}
      ]
      
      if calc.even(loc.page()) == true {
        emph(chapter-title) + h(1fr) + emph(head-title)
      }else{
        emph(head-title) + h(1fr) + emph(chapter-title)
      }
      
      v(-8pt)
      align(center)[#line(length: 105%, stroke: (thickness: 1pt, dash: "solid"))]
      
    }),

    footer: locate(loc => {
      if loc.page() == 1 {return}
      [
        #if calc.even(loc.page()) == true {
            align(left)[#counter(page).display("1 / 1",both: true,)]
        }else{
            align(right)[#counter(page).display("1 / 1",both: true,)]
        }
      ]
    })
  )

  // 配置列表
  set list(tight: true, indent: 2em)
  show list: it => [
    #set text(top-edge: "ascender")
    #it
  ]

  set enum(tight: true, indent: 2em)
  show enum: it => [
    #set text(top-edge: "ascender")
    #it
  ]

  // 配置标题
  set heading(numbering: "1.1.1.1.1.")

  show heading: it => box(width: 100%)[
    #if it.numbering != none { counter(heading).display() }
    #it.body

    #if it.level == 1 and it.numbering != none{
      chaptercounter.step()
      counter(math.equation).update(0)
    }
  ]

  // 配置一级标题
  show heading.where(
    level: 1
  ): it => box(width: 100%)[
    #set align(left)
    #set text(fill: accent-color)
    #set heading(numbering: "章节 1. ")
    #it
    #v(-12pt)
    #line(length:100%, stroke: gray)
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

  // 配置表格
  set table(
    fill: (_, row) => if row == 0 {accent-color.lighten(40%)} else {accent-color.lighten(80%)},
    stroke: 1pt + white
  )

  // set figure(placement: auto)
  show figure.where(
    kind: table
  ): set figure.caption(position: bottom)
  show figure.where(
    kind: raw
  ): it => {
    set block(width: 100%, breakable: true)
    it
  }

  // 配置行内代码块
  show raw.where(
    block: false,
  ): it => box(fill: luma(245), inset: (x: 2pt), outset: (y: 3pt), radius: 1pt)[#it]

  show raw.where(block: true): it => sourcecode[#it]


  //------------------------------------------------------------------
  box(width: 100%, height: 40%)[
    // 显示论文的标题和描述。
    #align(right+bottom)[
      #text(36pt, weight: "bold")[#title]
      #parbreak()
      #if description != none {
        text(size: 16pt, style: "italic")[#description]
      }
    ]
  ]

  box(width: 100%, height: 50%)[
    #align(right+top)[
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
  ]

  box(width: 100%)[
    #if date != none {
      text(size: 12pt, "最初写作于：")
      text(
        size: 12pt,
        fill: accent-color,
        weight: "semibold",
        date.display("[year]年[month]月[day]日")
      )
      parbreak()
      text(size: 12pt, "最后更新于：")
      text(
        size: 12pt,
        fill: accent-color,
        weight: "semibold",
        datetime.today().display("[year]年[month]月[day]日")
      )
    } else {
      text(size: 11pt)[最后更新于：#h(5pt)] + text(
        size: 11pt,
        fill: accen-color,
        weight: "semibold",
        datetime.today().display("[month repr:long] [day padding:zero], [year repr:full]")
      )
    }
  ]
  
  pagebreak()

  // 显示笔记的目录
  outline(indent: auto)

  
  v(24pt, weak: true)

  // 将段落设置为两端对齐，并设置换行。
  set par(justify: true, linebreaks: "optimized", first-line-indent:2em, leading: 0.8em)

  pagebreak()

  // 显示笔记的内容
  body

  // 显示参考文献
  if bibliography-file != none {
    pagebreak()
    show bibliography: set text(10.5pt)
    bibliography(bibliography-file, title: "参考文献", style: "gb-7714-2015-numeric")
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
    radius: (left: 4pt, right: 4pt),
    stroke: (left: 4pt + eastern.darken(20%), rest: 1pt + silver),
    inset: 1em
    )[#body]
  ]
]

// 水平标尺
#let horizontalrule = [#v(0.5em) #line(start: (20%,0%), end: (80%,0%)) #v(0.5em)]

// 另外的水平标尺
#let sectionline = align(center)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]

// ==== 使用 showybox 和 ctheorems 包创建盒子 ====
//
// |   环境   |  强调色                |
// |---------|-----------------------|
// |   定义   |  orange               |
// |   示例   |  blue                 |
// |   提示   |  olive                |
// |   注意   |  red                  |
// |   引用   |  eastern              |
// |   定理   |  yellow               |  
// |   命题   |  navy                 |

#let boxnumbering = "1.1.1.1.1.1"
#let boxcounting = "heading"

#let notebox(name, number, body, ntype, nicon, ncolor) = {
  showybox(
    title-style: (
      weight: 1000,
      color: ncolor.darken(20%),
      sep-thickness: 0pt,
    ),
    frame: (
      border-color: ncolor.darken(20%),
      title-color:  ncolor.lighten(80%),
      body-color:   ncolor.lighten(80%),
      thickness: (left: 4pt),
      radius: 4pt
    ),
    title: [#box(height: 0.85em)[#image.decode(nicon)] #name #h(1fr) #ntype #number],
    body
  )
}

#let definition = thmenv(
  "definition",
  boxcounting, //base counter name
  2, // number of base number levels to use
  (name, number, body) => {
    notebox(name, number, body, "定义", defSvg, orange)
  }
).with(numbering: boxnumbering)

#let example = thmenv(
  "example",
  boxcounting,
  2,
  (name, number, body, ..args) => {
    notebox(name, number, body, "示例", egSvg, blue)
  }
).with(numbering: boxnumbering)

#let tip = thmenv(
  "tip",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "提示", tipSvg, olive)
  }
).with(numbering: boxnumbering)

#let attention = thmenv(
  "attention",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "注意", cautionSvg, red)
  }
).with(numbering: boxnumbering)

#let quote = thmenv(
  "quote",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "引用", quoteSvg, eastern)
  }
).with(numbering: boxnumbering)

#let theorem = thmenv(
  "theorem",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "定理", thmSvg, yellow)
  }
).with(numbering: boxnumbering)

#let proposition = thmenv(
  "proposition",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "命题", propSvg, navy)
  }
).with(numbering: boxnumbering)