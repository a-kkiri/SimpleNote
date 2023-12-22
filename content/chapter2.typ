#import "../template.typ": *

= 使用示例

== 特殊记号

你可以 Typst 的语法对文本进行特殊标记，我们为如下标记设定了样式：

#enum(
  [*突出*],
  [_强调_],
  [引用 @netwok2020],
  [脚注 #note[脚注例]],
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

== 图片

#figure(caption: [图片插入例], image("../figures/typst.png")) <image-example>

== 引用块

#blockquote[
  引用块例

  #blockquote[
    二级引用块
  ]
]

== 公式

  $ e^(i x) = cos x + i sin x $ <schrodinger>

== 定理环境


#definition(
  "定义",
  footer: "定义"
)[
  #lorem(30)
]

#example(
  "示例",
  footer: "示例"
)[
  #lorem(30)
]

#tip(
  "提示",
  footer: "提示"
)[
  #lorem(30)
]

#attention(
  "注意",
  footer: "注意"
)[
  #lorem(30)
]

#quote(
  "引用",
  footer: "引用"
)[
  #lorem(30)
]

#theorem(
  "定理",
  footer: "定理"
)[
  #lorem(30)
]

#proposition(
  "命题",
  footer: "命题"
)[
  #lorem(30)
]

#sectionline