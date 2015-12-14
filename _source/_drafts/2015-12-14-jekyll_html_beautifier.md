---
layout: page
title: JekyllのHTMLを読みやすいように整形するプラグイン
date: 2015-12-14 19:08:28 +0900
category: blog
tags: jekyll
description: JekyllのHTMLを読みやすいように整形するプラグイン
---

Jekyll を使ってると、ファイル内で Liquid のタグにあわせてインデントすると
見やすくて分かりやすくなっていい感じです。

{% raw %}
    <ul>
      {% for post in site.posts %}
        <li><a href="{{ post.url }}">{{ post.title }}</a></li>
      {% endfor %}
    </ul>
{% endraw %}

しかし、layout や include でファイルが結合されると、
できあがった HTML 内でのインデントはメチャクチャになります。

そこで

いわゆるbeautifierとかpretty printとかいわれる機能です。

{% gist saasan/7c92d15e7ebb4870f581 %}

_plugins フォルダに入れれば
