#import "@preview/codelst:2.0.0": sourcecode, codelst
#import "@preview/showybox:2.0.1": showybox
#import "@preview/ctheorems:1.1.0": *
#import "@preview/mitex:0.2.0": *
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

  let accent_color = rgb(accent)

  // 使用 ctheorems 包
  show: thmrules

  // 中文粗体，斜体
  show strong: set text(fill: accent_color.lighten(20%), font: (text_font, sc_font))
  show emph: text.with(font: (text_font, sc_font))
  // set text(cjk-latin-spacing: auto)

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

  // 计数器
  let chaptercounter = counter("chapter")
  let footnotecounter = counter(footnote)

  // 配置页面
  set page(
    paper: paper_size,
    columns: cols,
    numbering: "1 / 1",
    number-align: center,
    // 页边距
    margin: (x:1.6cm, y:2.3cm),

    header: locate(loc => {
      if loc.page() == 1{return}
      let footers = query(selector(<__footer__>).after(loc), loc)

      let elems = query(
        heading.where(level: 1).before(footers.first().location()), footers.first().location()
      )
      if elems == () {return}
      let head_title = text()[
        #if short_title != none { short_title } else { title }
      ]
      
      if calc.even(loc.page()) == true {
        emph(elems.last().body) + h(1fr) + emph(head_title)
      }else{
        emph(head_title) + h(1fr) + emph(elems.last().body)
      }
      
      v(-7pt)
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
      #footnotecounter.update(())
      #label("__footer__")
      ]
    })
  )

  // 配置列表
  show list: it => [
    #set list(tight: false, indent: 2em)
    #set text(top-edge: "ascender")
    #it
  ]

  show enum: it => [
    #set enum(tight: false, indent: 2em)
    #set text(top-edge: "ascender")
    #it
  ]

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
    #set text(fill: accent_color)
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
        fill: accent_color,
        weight: "semibold",
        date.display("[month repr:long] [day padding:zero], [year repr:full]")
      )
      parbreak()
      text(size: 12pt, "最后更新于：")
      text(
        size: 12pt,
        fill: accent_color,
        weight: "semibold",
        datetime.today().display("[month repr:long] [day padding:zero], [year repr:full]")
      )
    } else {
      text(size: 11pt)[最后更新于：#h(5pt)] + text(
        size: 11pt,
        fill: accent_color,
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

// 尝试添加 LaTeX 中的 \boxed{} 命令
#let dboxed(con) = box(stroke: 0.5pt + black, outset: (x: 2pt), inset: (y: 8pt), baseline: 11pt, $display(#con)$)
#let iboxed(con) = box(stroke: 0.5pt + black, outset: (x: 2pt), inset: (y: 3pt), baseline: 2pt, $#con$)

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

#let notebox(name, number, body, _type, _icon, _color) = {
  showybox(
    title-style: (
      weight: 1000,
      color: _color.darken(20%),
      sep-thickness: 0pt,
    ),
    frame: (
      border-color: _color.darken(20%),
      title-color:  _color.lighten(80%),
      body-color:   _color.lighten(80%),
      thickness: (left: 4pt),
      radius: 4pt
    ),
    title: [#name #h(1fr) #box(height: 0.85em)[#image.decode(_icon)] #_type #number],
    body
  )
}

#let definition = thmenv(
  "definition",
  boxcounting, //base counter name
  2, // number of base number levels to use
  (name, number, body) => {
    notebox(name, number, body, "定义", _def, orange)
  }
).with(numbering: boxnumbering)

#let example = thmenv(
  "example",
  boxcounting,
  2,
  (name, number, body, ..args) => {
    notebox(name, number, body, "示例", e_g_, blue)
  }
).with(numbering: boxnumbering)

#let tip = thmenv(
  "tip",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "提示", lightbulb, olive)
  }
).with(numbering: boxnumbering)

#let attention = thmenv(
  "attention",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "注意", _caution, red)
  }
).with(numbering: boxnumbering)

#let quote = thmenv(
  "quote",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "引用", _quote, eastern)
  }
).with(numbering: boxnumbering)

#let theorem = thmenv(
  "theorem",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "定理", _thm, yellow)
  }
).with(numbering: boxnumbering)

#let proposition = thmenv(
  "proposition",
  boxcounting,
  2,
  (name, number, body) => {
    notebox(name, number, body, "命题", _prop, navy)
  }
).with(numbering: boxnumbering)