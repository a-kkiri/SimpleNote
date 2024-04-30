#import "../template.typ": *

= 使用示例

== 特殊记号

你可以 Typst 的语法对文本进行#highlight[特殊标记]，我们为如下标记设定了样式：

#enum(
  [*突出*],
  [_强调_],
  [引用 @figure],
  [脚注 #footnote("脚注例")],
)

== 代码

行内代码使用例 `println!("Hello, typst!")`，下面是代码块使用例：

#figure(
```rust
fn main() {
    println!("Hello, typst!");
}
```,

caption: [代码块插入例]
) <cpp-example>

== 图片 <figure>

#figure(caption: [图片插入例])[#image("../figures/typst.png")]<image-example>

== 表格

#figure(caption: [表格插入例])[
  #table(
    columns: (1fr, 1fr, 1fr),
    [表头1]  , [表头2]  , [表头3],
    [单元格1], [单元格2], [单元格3],
    [单元格1], [单元格2], [单元格3],
    [单元格1], [单元格2], [单元格3],
)]

== 引用块

#blockquote[
  引用块例

  #blockquote[
    二级引用块
  ]
]

== 公式

行内公式，例如 $integral_123^123a+b+c$ $a^2 + b^2 = c^2$。行内公式使用 `$$` 包裹，公式和两端的 `$$` 之间没有空格$$。

行间公式，例如：$ integral.triple_(Omega)\(frac(diff P, diff x) + frac(diff Q, diff y) + frac(diff R, diff z)\)d v = integral.surf_(Sigma)P d y d z + Q d z d x + R d x d y $<eq> @eq 是高斯公式。行间公式使用 `$$` 环境包裹，公式和两端的 `$$` 之间至少有一个空格。

以上仅为一些简单的公式示例，更多的公式使用方法可以查看 #link("https://typst.app/docs/reference/math/")[typst/docs/math]

另外，如果需要插入 LaTeX 公式可以使用外部包 #link("https://typst.app/universe/package/mitex")[mitex]。


== 定理环境


#definition("定义")[#lorem(30)]

#example("示例")[#lorem(30)]

#tip("提示")[#lorem(30)]

#attention("注意")[#lorem(30)]

#quote("引用")[#lorem(30)]

#theorem("定理")[#lorem(30)]

#proposition("命题")[#lorem(30)]

#sectionline