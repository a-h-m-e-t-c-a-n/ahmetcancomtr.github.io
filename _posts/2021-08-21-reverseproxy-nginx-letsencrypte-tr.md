---
layout: post
title:  "Docker,Nginx ve Letsencypte(ücretsiz SSL) reverse proxy configurasyonu"
summary: "Mid,Senior seviyesindeki bu makalede hızlı ve pratik bir şekilde ücretsiz SSL konfigurasyonu ile birlikte bir reverse-proxy nasıl yapılandırılır öğreneceksin"
author: ahmetcan
date: '2021-08-21 18:00:00 +2'
category: [backend,tr]
thumbnail: /assets/img/playstore.jpg
keywords: reverse-proxy, nginx, letsencrypte ,ssl,docker
permalink: /blog/reverseproxy-nginx-letsencrypte-tr/
usemathjax: true
---

Referrer API android uygulamanızı indiren kullanıcının hangi ortam üzerinden playstore ulaştığını bilmenizi sağlar.
Organik vs ayrımlarını yapmamızı kolaylaştırır.Bu bilgiyi çeşitli şekillerde kullanabiliriz en basiti kampanyalarımızı buna göre şekillendirebiliriz.


```html
https://play.google.com/store/apps/details?id=com.example.application
&referrer=utm_source%3Dgoogle
%26utm_medium%3Dcpc
%26utm_term%3Drunning%252Bshoes
%26utm_content%3Dlogolink
%26utm_campaign%3Dspring_sale
```

Detaylı bilgiye aşağıdaki linkten ulaşabilirsiniz

**[https://developers.google.com/analytics/devguides/collection/android/v4/campaigns](https://developers.google.com/analytics/devguides/collection/android/v4/campaigns)**

