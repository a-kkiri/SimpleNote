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

行内代码使用例 `#include`，下面是代码块使用例：

#code(caption: [代码块插入例])[
```cpp
#include <iostream>
int main() {
  std::cout << "Hello, world!" << std::endl;
}
```
] <cpp-example>

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

使用 `#mi('LaTeX equation')` 编写行内公式 #mi(`e^{ix} = \cos x + i \sin x`)

使用 `#mitex('LaTeX equation')` 编写行间公式：#mitex(`e^{ix} = cos x + i sin x`)


== 定理环境


#definition("定义")[#lorem(30)]

#example("示例")[#lorem(30)]

#tip("提示")[#lorem(30)]

#attention("注意")[#lorem(30)]

#quote("引用")[#lorem(30)]

#theorem("定理")[#lorem(30)]

#proposition("命题")[#lorem(30)]

#sectionline