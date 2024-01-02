#import "../template.typ": *

= 使用示例

== 特殊记号

你可以 Typst 的语法对文本进行特殊标记，我们为如下标记设定了样式：

#enum(
  [*突出*],
  [_强调_],
  [引用 @figure],
  [脚注 #footnote("脚注例")],
)

== 代码

行内代码使用例 `main()`

#figure(caption: [代码块插入例])[#sourcecode(
```cpp
#include <iostream>
int main() {
  std::cout << "Hello, world!" << std::endl;
}
```
)] <cpp-example>

== 图片 <figure>

#figure(caption: [图片插入例], image("../figures/typst.png")) <image-example>

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


#definition(
  "定义",
)[
  #lorem(25)
]

#example(
  "示例",
)[
  #lorem(25)
]

#tip(
  "提示",
)[
  #lorem(25)
]

#attention(
  "注意",
)[
  #lorem(25)
]

#quote(
  "引用",
)[
  #lorem(25)
]

#theorem(
  "定理",
)[
  #lorem(25)
]

#proposition(
  "命题",
)[
  #lorem(25)
]

#sectionline