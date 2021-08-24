---
layout: post
title:  "Docker,Nginx ve Letsencypt(ücretsiz SSL) reverse proxy Konfigurasyonu"
summary: "Ücretsiz SSL konfigurasyonu ile birlikte bir reverse-proxy  yapılandırılırması ile ilgili sample proje sunuluyor"
author: ahmetcan
date: '2021-08-21 18:00:00 +2'
category: [backend,tr]
thumbnail: /assets/img/reverse-proxy.png
keywords: reverse-proxy, nginx, letsencrypt ,ssl,docker
permalink: /blog/reverseproxy-nginx-letsencrypt-tr/
usemathjax: true
---

**[Github Repo](https://github.com/ahmetcancomtr/reverseproxy.git)**


## Reverse Proxy
Eğer hala windows altında IIS rahatlığı içinde web hizmetlerini host ediyorsan reverse-proxy ihtiyaç duymamışsındır ama dünya değişti ve teknoloji de onla birlikte giderek değişiyor.
Web servisleri daha karmaşık ölçeklenebilir ve güvenliğin üst seviyede olması gereken bir yapılandırma ihtiyacı duyuyor, tabi bir de ucuz(mümkünse ücretsiz).Dünyada  Web Servislerin  büyük bir çoğunmluğu ,linux işletim sistemi üstünde koşturuluyor ve dünyada bu yapılandırmaların büyük bir kısmı open source ürünler üzerinden oluyor.Peki, Reverse Proxy ne işe yarar ? .Server a dışardan gelen istekleri ,farklı portlar üstünde hizmet veren, farklı frameworkler ve farklı programlama dilleri ile yazılmış bir çok web servisine yönlendiriyor.(bkz micro service mimarisi). En bilinenenleri nginx,High Availablity Proxy,Apache Traffic Server, Traefik, Caddy(Golang), Envoy. vs.. ,yaptıkları işler aynı olmasına rağmen yetenekleri ve performans farklılıkları var. 

Nginx static html server ve aynı zamanda bir reverse proxy/load balancer olarak yapılandırabilirsin. Bu projede nginx kullandık. Yapılandırması nispeten daha kolay ve anlaşılır ve çok karmaşık gereksinizmler olmadığı sürece işini görür.(eğer karmaşık case ler mevcut ise HA proxy'e bakmanı tavsiye ederim)

## Ücretsiz SSL.
SSL fiyatları aldı başını gitti. SSL flow'da  3. bir tarafın yani bir otoritenin işin içine girmesi ve ben bu domain e kefilim demesi gerekiyor. Bu işi yapan hatırı sayılır comodo,rapidssl vs.. gibi bir çok firma var. Fakat eğer çok küçük çaplı bir hobi projesi yürütüyorsan ve SSL için yıllık domain başına 50$+ ,wildcard(tüm subdomainler dahil)  200$+ gibi rakamlar için bütçe ayıramıyorsan güzel bir haberim var bu işi ücretsiz yapmanın bir yol mevcut.

**[LetsEncypt](https://letsencrypt.org)**

Bu organizasyon  bazı sponsorlar tarafından destekleniyor ve bağışlar ile ayakta duruyor sana tamamen ücretsiz bir ssl sertifikası veriyor. Bu sertifikanın süresi 1 ay gibi kısa bir süre fakat korkacak birşey yok bu sertifikayı belli limitler dahilinde nerseyse 2 günde bir yenileyebilirsin. Bu yüzden geçersiz kalması gibi beklenmedik bir durum olması pek mümkün değil. Hatta ücretli sertifiklardan daha uzun süre kullanabilirsin.
Peki nasıl yapıyor bu işi. Sizin domain iniz aldındaki web server üzerinde certbot isminde bir uygulama ,domain 'in size ait olduğunu doğrulayacak bir akıştan sonra (validation) size sertifiklarınızı indirip veriyor. Bu yaklaşık 2-3 dk gibi sürede gerçekleşiyor.

## Docker
Bu projede herşey docker-compose üzerinde  tanımlanmış durumda bu yüzden kullanımı oldukça kolay.

önce projeyi indirelim
```console
git clone https://github.com/ahmetcancomtr/reverseproxy.git
cd reverseproxy
```

config.env'da  kaç tane domain e ihtiyacınız varsa bunları aralarında boşluk ile belirtebilirsin bir limit yok. Biliyoruz ki subdomain de farklı bir domain olarak algılanır bu yüzden onları da yazmalısın.

```console
//config.env 

DOMAINS=domain1.xmachine.uk domain2.xmachine.uk
CERTBOT_EMAILS=admin@xmachine.uk
```


```console

DOMAINS=domain1.xmachine.uk domain2.xmachine.uk
CERTBOT_EMAILS=admin@xmachine.uk
```

reverse proxy konfigurasyonunuzu aşağıdaki nginx config dosyaları üzerinden yapabilirsin , her bir domain "domains" klasörü altında bir config dosyası eklemen yeterli otomatik olarak nginx config dosyasına eklenecektir.default.config içinde de bu yeni eklenen config dosyasını  dahil etmiş olacaksın

```console
//nginx/default.config
//nginx/domains/domain1.config
//nginx/domains/domain1.config
```
! Bu aşamada dikkat etmen gereken bir şey var. Certbot doğrulama için  senin domain in  üzerindeki http servisine bir istek gönderecek bu yüzden bu isteği karşılaman ve certbot'a yönlendirmen gerekiyor.Domains altındaki örnek config dosyalarında bunu görebilirsin

```console
//nginx/domains/domain1.config

location /.well-known/acme-challenge/ {
    root /var/www/certbot/domain1.xmachine.uk;
}
```
görmüş olduğun gibi gelen isteğe cerbot un oluşturmuş olduğu geçici bir unique-id yi veriyor.Bu gerekli bir konfigurasyon,olmaması validasyon işlemini başarısız sonuçlanmasına neden olur.

```console
docker-compose build
docker-compose up
```
şimdi certbot un işini yapması için bir iki dakika bekleyelim
hata alırsa birşeyler yanlış gidiyorsa logları takip edersen kolayca farkedersin.

bir aksilik çıkarsa bana yazmayı unutma elimden geldiğince yardımcı olurum.

github da yıldızlarını bekliyorum :)

iyi çalışmalar.
