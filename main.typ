#import "template.typ": *

#show: template.with(
  title: [SimpleNote],
  short_title: "SimepleNote",
  description: [
    此模板修改自 #link("https://github.com/jskherman/jsk-lecnotes")[jsk-lecnotes]  \ Winter 2023
  ],
  date: datetime(year: 2023, month: 12, day: 19),
  authors: (
    (
      name: "Akkiri",
      github: "https://github.com/a-kkiri",
      homepage: "https://github.com/a-kkiri", // 个人主页
      affiliations: "1,2",
    ),
  ),
  affiliations: (
    (id: "1", name: "Example University"),
    (id: "2", name: "Example Inc."),
  ),

  bibliography_file: "refs.bib",
  paper_size: "a4",
  cols: 1,
  text_font: "Linux Libertine",
  sc_font: "Noto Sans CJK SC",
  code_font: "DejaVu Sans Mono",
  accent: orange, // 主题色
)

#include "content/chapter1.typ"
#include "content/chapter2.typ"