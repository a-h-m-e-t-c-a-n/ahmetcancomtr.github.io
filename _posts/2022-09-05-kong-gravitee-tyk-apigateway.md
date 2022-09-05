---
layout: post
title:  "What API Gateway to choose: Kong, Gravitee, Tyk or HAProxy?"
summary: "API Gateways are more and more used nowadays: it permits you to have a single component to handle authentication and not code it several times, manages CORS etc. But it’s not an easy task to choose the one which matches the most your context and to do so, I compared 4 API Gateways: Kong, Gravitee, Tyk, and HAProxy.
"
author: ahmetcan
date: '2021-08-21 18:00:00 +2'
category: [backend,tr]
thumbnail: /assets/img/reverse-proxy.png
keywords: apigateway, kong, gravitee ,haproxy,docker,apisix
permalink: /blog/kong-gravitee-tyk-apigateway/
usemathjax: true
---


<img width="1420" height="540" src="/assets/img/posts/api-gateway-kong-gravitee-haprox_c91c7eb465c446a49.webp"/>

# <a id="hs_cos_wrapper_name"></a>What API Gateway to choose: Kong, Gravitee, Tyk or HAProxy?

## 

API Gateways are more and more used nowadays: it permits you to have a single component to handle authentication and not code it several times, manages CORS etc. But it’s not an easy task to choose the one which matches the most your context and to do so, I compared 4 API Gateways: Kong, Gravitee, Tyk, and HAProxy.

Summary

- [<a id="hs_cos_wrapper_name"></a>What API Gateway to choose: Kong, Gravitee, Tyk or HAProxy?](#what-api-gateway-to-choose-kong-gravitee-tyk-or-haproxy)
  - [](#)
  - [Kong](#kong)
    - [Architecture](#architecture)
    - [Performances](#performances)
  - [Gravitee](#gravitee)
    - [Architecture](#architecture-1)
    - [Performances](#performances-1)
  - [Tyk](#tyk)
    - [Architecture](#architecture-2)
    - [Performances](#performances-2)
  - [HAProxy](#haproxy)
    - [Architecture](#architecture-3)
    - [Performances](#performances-3)

<a id="hs_cos_wrapper_post_body"></a>

## Kong

<img width="250" height="81" src="/assets/img/posts/Copie_de_API_Gateway_2110ffdd6c99412696d74c7a5d633.png"/>

[Kong](https://konghq.com/solutions/gateway/) is an Open Source API Gateway **coded in Lua and Perl by Kong Inc** since 2017. The Open Source solution is **Kong API Gateway** and the enterprise version **Kong Enterprise** gathers more tools around the gateway, such as **dashboards** or **monitoring tools**.

### Architecture

![API Gateway kong architecture](/assets/img/posts/API-Gateway-kong-architecture_f528785c5ed948b69b1a.png)

Kong only needs a PostgreSQL to save its configurations and [can be installed in lots of environments and OS](https://konghq.com/install/).

As you can see with the architecture blueprint, **Kong incorporates a plugin part**. That is his biggest advantage: **Kong Inc and its community** (more than 20k stars on GitHub) are developing plugins for almost everything you can need: **authentication**, **logs**, **monitoring**, **rate limiting**, etc. The community is active and Kong is evolving quickly. Furthermore, Kong is **easy to understand** **and to deploy**: only 1h is required for someone who has never used it, less if you are used to, and a few minutes for a custom install script.

### Performances

Kong **needs less than 300MB of RAM to run**, even with a high number of connections. On the contrary, it needs CPU, and increasing your number of CPU will increase its performance. Kong can scale horizontally: the API Gateway is stateless and the database is unique. It means when you make a change, it applies to every gateway linked to the database. **The horizontal scaling is really effective**: I specify it because it’s not the case for every solution.

Kong can answer almost every need thanks to the plugins available, and the community is a solid point.

## Gravitee

<img width="150" height="150" src="/assets/img/posts/Copie_de_API_Gateway-1_16b160de171d48d78d8644e7f82.png"/>

[Gravitee](https://gravitee.io/) is an Open-source API Gateway developed **using Java** by Gravitee Source since January 2015. The system is **more complex than Kong**: it depends on 3 apps. The first two are part of the **Management block**: the portal is an Angular front which interacts with the Management API to manage all the configuration of the Gateway. The configuration is **saved in a MongoDB** and used by the third app, the **Gateway**.

### Architecture

![API Gateway haproxy architecture](/assets/img/posts/API-Gateway-haproxy-architecture_2169e86bcbcf4334a.png)

One of the **advantages of Gravitee is the dashboard**: it is **clear**, **easily understandable** for a developer, and manages everything you can do with Gravitee (routes, authentication, alerting, etc.). Gravitee provides fewer features than Kong, but if you don’t have exotic needs, it will be satisfying.

With Gravitee, the **pain point is the installation and the documentation**. The first time you install it you may struggle because the procedure isn’t clear, you have at least 3 components to install and a MongoDB and you may need an ElasticSearch. Search for troubleshooting in the documentation isn’t easy and as the community isn’t large (around 1k stars on GitHub) there isn’t much activity.

### Performances

Unlike the other API Gateway, **Gravitee needs RAM** (as usual for Java application). You have to **run your Management API on a machine on its own** if you don’t want your Gateway to impact it. Each Gateway needs at least 4GB of the heap for Java if you want to handle a high number of connections. Horizontal scaling works but vertical scaling even more (if you increase your CPU and RAM the performances increase a lot). Note that **the performances of this solution are really impressive once the Gateway uses the RAM**.

Gravitee can be hard to install but offers **great performances and a complete interface**.

## Tyk

[Tyk.io](https://tyk.io/features/api-gateway/) is an Open Source API Gateway written in Go by Tyk Technologie since 2014. As for Gravitee, there are **3 processes to run**, but Tyk also **needs a Redis and a MongoDB**.

The 3 apps are the **gateway**, the **dashboard** to configure the gateway, and the **pump** which extracts data from the Redis and injects it in the MongoDB.

### Architecture

The **strong point of the solution is the dashboard**. As a developer, you can do almost everything you can imagine with it (alerting, rate-limiting, update requests, etc.) and the **interface is easy to understand**.

It’s **longer to install than Kong** because you have to set up a Redis and a MongoDB, but since the documentation is well written you shouldn’t encounter a problem with the 3 parts of the application. The community isn’t large (5k stars on GitHub) so there aren't many issues but the support is reactive and willing to help you: don’t hesitate to contact them if you are in need of something.

### Performances

Tyk **doesn’t need much RAM** (less than 250 Mo) but **consumes a lot of CPU**. Scaling vertically and horizontally increases the performances, but to get straight to the point: **Tyk performances are his drawback**. Tyk documentation estimates the max capacity to be 4000 requests/sec: it’s far lower than the other solutions. I made perf tests for more than 4000 requests and the solution couldn’t handle it.

To resume, Tyk can be a wonderful API Gateway with a **complete and ergonomic dashboard** if your traffic isn’t more than its specifications.

## HAProxy

[HAProxy](https://www.haproxy.com/blog/using-haproxy-as-an-api-gateway-part-1/) is an Open source solution developed in Lua and C. HAProxy is quite different from the other solution because its **first use is to be a load balancer and not an API Gateway**, but it can be used as such. The architecture is simple: only **one process to start** which reads a configuration file when it starts.

### Architecture

As HAProxy main use isn’t to be an API Gateway, the solution is **lacking a complete interface to manage API Gateway functionalities**. However, HAProxy knows this fact and is working on a dashboard to overcome this weakness.

Not every basic feature is available (OpenId authentication for example) but the most is if you add plugins or code available on their website. **If a feature is lacking, you can code it in Lua** thanks to the configuration file which is **highly customizable**.

The **installation is the simplest**, the documentation is complete and community and support are both good.

### Performances

The **key point of this solution is its performances**: it uses **fewer resources (CPU and RAM)** than the others for **better performances**. It seems normal when we think that the first use of HAProxy is to be a load balancer, and its reputation is not to make. It can also be scaled horizontally and vertically.

HAProxy is a good API Gateway **if you already have it as a load balancer**: you already know how it works and likely coded a configuration using Lua, so adding an authentication configuration will be easier for you.

Here is a recapitulative array:

For most of your use cases, Kong is the best choice but other API Gateways can be more suitable **depending on your context**:

- HAProxy if you already use it as a load balancer
- Tyk if your traffic is below 4000 connections by sec
- Gravitee if you prefer a without plugin solution and are familiar with the JVM

Of course, there are other API Gateway you can use and I just showed you the tip of the iceberg so if you have comments don’t hesitate to share it with us!

Yohan is a Site Reliability Engineer (SRE) at Padok. New technologies enthusiast, he is working with technologies such as Docker, Kubernetes or Terraform.

CLOUD & KUBERNETES