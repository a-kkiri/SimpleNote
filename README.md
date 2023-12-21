# README

SimpleNote 是为编写简易课程笔记创建的 Typst 模板，修改自 [jsk-lecnotes]("https://github.com/jskherman/jsk-lecnotes")

## 模板下载

- 页面右边点击：**Clone or download -> Download Zip**

## 使用方法

默认模板文件由主要以下六部分组成：
- main.typ 主文件
- template.typ 文档格式控制，包括一些基础的设置、函数
- refs.bib 参考文献
- content 正文文件夹，存放正文章节
- fonts 字体文件夹
- figures 图片文件夹

使用模板首先需配置 main.typ，设置标题、描述、作者等信息。如需要进一步更改文档格式，请修改 template.typ。

文档编写过程中，在终端中使用 `make watch` 进行即时预览；文档编写完成后，使用 `make compile` 生成 PDF 文件。

## 模板预览

|  [封面](https://github.com/a-kkiri/SimpleNote/blob/main/figures/cover.jpg) |  [正文](https://github.com/a-kkiri/SimpleNote/blob/main/figures/content.jpg)| 
|:---:|:---:|
| ![cover](https://github.com/a-kkiri/SimpleNote/blob/main/figures/cover.jpg?raw=true) | ![content](https://github.com/a-kkiri/SimpleNote/blob/main/figures/content.jpg?raw=true)|

## 注意

 >如果要将文档拆分为多个文件进行组织，需要将 `#import "../template.typ": *` 添加到每个文件的顶部，以使某些函数（例如 `blockquote()`）正常工作。

> 例如，假设你在项目根目录下有一个 `./content/chapter.typ` 文件和一个 `./template.typ` 文件，那么你需要在 `chapter.typ` 文件顶部添加 `#import "../template.typ": *`。