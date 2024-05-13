## 模板介绍

SimpleNote 是为撰写简易课程笔记而设计的 Typst 模板，修改自 [jsk-lecnotes](https://github.com/jskherman/jsk-lecnotes)，有问题欢迎提交 Issue。

## 使用方法

> [!NOTE]
>
> 此模板需要使用 Typst 0.11.0 及以上版本进行编译。

页面右边点击：**Clone or download -> Download Zip**，将模板文件下载到本地并解压

模板文件夹内主要包含以下七部分：
- main.typ 主文件
- refs.bib 参考文献
- template.typ 文档格式控制，包括一些基础的设置、函数
- resource.typ 存放模板 svg 资源
- /content 正文文件夹，存放正文章节
- /fonts 字体文件夹
- /figures 图片文件夹

使用模板首先需配置 `main.typ`，设置标题、描述、作者等信息，如需要进一步更改文档格式，请修改 `template.typ`。撰写文档请修改 `/content` 文件夹内的文件。

本地编辑建议使用 VSCode 编辑器，并推荐安装 [Tinymist](https://marketplace.visualstudio.com/items?itemName=mgt19937.typst-preview) 与 [Typst Preview](https://marketplace.visualstudio.com/items?itemName=mgt19937.typst-preview) 插件。

## 模板预览

| [封面](https://github.com/a-kkiri/SimpleNote/blob/main/figures/cover.jpg) | [正文1](https://github.com/a-kkiri/SimpleNote/blob/main/figures/content1.jpg) | [正文2](https://github.com/a-kkiri/SimpleNote/blob/main/figures/content2.jpg) |
|:---:|:---:|:---:|
| ![cover](https://github.com/a-kkiri/SimpleNote/blob/main/figures/cover.jpg?raw=true) | ![content1](https://github.com/a-kkiri/SimpleNote/blob/main/figures/content1.jpg?raw=true) | ![content2](https://github.com/a-kkiri/SimpleNote/blob/main/figures/content2.jpg?raw=true) |

> [!CAUTION]
>
>如果要将文档拆分为多个文件进行组织，需要将 `#import "../template.typ": *` 添加到每个文件的顶部，以使某些函数（例如 `blockquote()`）正常工作。
>
> 例如，假设你在项目根目录下有一个 `./content/chapter.typ` 文件和一个 `./template.typ` 文件，那么你需要在 `chapter.typ` 文件顶部添加 `#import "../template.typ": *`。

## 更改记录

2024-5-13
- 修复页眉章节标题显示问题
- 修复公式编号记数问题
- 调整定理环境标题显示位置

2024-4-30
- 更新 typst 包
    - codelst: 2.0.0 ——> 2.0.1
    - ctheorems: 1.1.0 ——> 1.1.2
    - 移除 mitex 包
- 替换默认封面图片
- 更改封面日期显示格式
- 优化页眉章节标题显示逻辑
- 将变量名中的下横线替换为连字号
- 默认使用 codelst 包显示行间代码块