#import "../template.typ": *

= 模板说明

#link("https://github.com/a-kkiri/SimpleNote")[SimpleNote] #cite(<SimpleNote>) 修改自 #link("https://github.com/jskherman/jsk-lecnotes")[jsk-lecnotes]，是一个简单的 Typst 模板。本模板主要适用于编写课程笔记，默认页边距为2.5cm，默认使用的中文字体为 Noto Sans CJK SC，英文字体为 Linux Libertine，字号为12pt（小四），你可以根据自己的需求进行更改，如需使用伪粗体或伪斜体，可以使用外部包 #link("https://typst.app/universe/package/cuti")[cuti]。封面图片由 #link("https://tabbied.com/")[Tabbied] 生成。

默认模板文件由主要以下六部分组成：

#list(
  [main.typ 主文件],
  [template.typ 文档格式控制，包括一些基础的设置、函数],
  [refs.bib 参考文献],
  [content 正文文件夹，存放正文章节],
  [fonts 字体文件夹],
  [figures 图片文件夹]
)\ #v(-16pt)

使用模板首先需配置 main.typ，设置标题、描述、作者等信息。如需要进一步更改文档格式，请修改 template.typ。