---
layout: post
title: '[Jekyll] Liquidのタグをエスケープする方法'
date: 2015-12-15 19:13:07 +0900
category: blog
tags: [ Jekyll ]
---

```{{ "{% raw " }}%}``` と ```{{ "{% endraw " }}%}``` で囲むと
Liquidのタグもそのまま出力されます。

例えば

```liquid
{{ "{% raw " }}%}{% raw %}
<ul>
  {% for post in site.posts %}
    <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>{% endraw %}
{{ "{% endraw " }}%}
```

と書いた場合の出力は以下のようになります。

```liquid
{% raw %}<ul>
  {% for post in site.posts %}
    <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>{% endraw %}
```
