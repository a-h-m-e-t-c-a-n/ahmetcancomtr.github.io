---
layout: post
title:  "Flutter, Rust ve gRPC ile Işık Hızına Çıkın"
summary: "Rust gRPC ve Flutter kullanarak donanımı en yüksek verimlilikte kullanabileceğiniz http/2 temelli mobil-fullstack uygulama geliştirme"
author: ahmetcan
date: '2020-12-29 04:52:00 +2'
category: [rust,flutter,gRPC]
thumbnail: /assets/img/rust.png
keywords: flutter, rust, grpc ,android,ios,development, dart, macos, linux, protobuf
permalink: /blog/flutter-rust-grpc/
usemathjax: true
---


    
    Geliştirme Ortamı:
    Ubuntu 20.04 
    Visual Studio Code
    Flutter SDK
    Rust SDK


**Kodların tamamını github üzerinden indirebilirsiniz!**
**[https://github.com/ahmetcancomtr/flutter_rust_grpc](https://github.com/ahmetcancomtr/flutter_rust_grpc)**


Yazıya başlamadan önce Günümüzde popularitesini arttıran Rust ve gRPC gibi teknolojileri neden kullanmalıyız değinmek istiyorum. 

Rust Mayıs/2015 te 1.0 versionu çıkmış 2016 stackoverflow da en populer dil olarak seçilmiştir. Peki bu hızlı yükselişin ardında ne var. Performans olarak en hızlı programlama dili dediğimizde aklımıza  C dili geliyor.C dilide yazılan kodlar derlendiği zaman öz ve doğrudan araya bir katman girmeden çok hızlı çalışabilecek makine kodlarına dönüştürülüyor.C dili bu yüzden sistem programlamada ağırlıklı olarak kullanıyor. Günümüzde uygulama programlama alanında c ve c++ gibi diller pek pratik tercih edilmiyor. C#,java JavaScript gibi üst seviye diller, yazım kolaylığı açışından uygulama programcıları tarafından daha çok tercih ediliyor.CLR,JVM,JIT gibi runtime katmanları üzerine kurgulanmış bu diller cross platform ve moduler geliştirme konusunda yüksek uyumluluk sağlıyor. Peki neler kaybettiriyor ? Tabi ki performanstan ödün vermek zorunda kalıyoruz. Günümüzde Net framework 5 çıkmasıyla optimizasyonu çok iyi duruma gelen .Net Framework en hızlı haliyle bile C programlama dilinin oluşturduğu kodlardan çok daha yavaş çalışıyor ve donanım kaynaklarını daha fazla tüketiyor. Bunun nedeni CLR runtime tarafından yorumlanan ara kodların makine kodlarına dönüştürülme safhası.Ayrıca programcıların kolay memory management yapabilmesi açısından Garbage Collection bir mekanizmanın olması çok büyük bir etken.

  **O zaman ihtiyacımız olan şey C kadar hızlı aynı zamanda C#,jAVA vs.. gibi üst seviye diller kadar kolay 
    yazım  ve effektif memory management sunabilecek bir programalma dili.**
    

RUST performansını C dili karşılaştırabilriz,Özellikle C++ demiyorum kendi denemelerimde C++ dan daha hızlı çalıştığını gördüm. Şöyle ki yazılmış bir benchmark kodunda oluşturulan algoritma 

1. C....................0.7 sn
2. **Rust**...............0.8 sn
3. C++................1.5 sn
4. Go..................3.9 sn
5. C#(net5)........5.1 sn


gibi bir sürede tamamlandı
Peki bu kadar hızlı olmasının nedeni nedir ?... Tabi ki C dili gibi araya hiçbir katman girmeden, doğrudan makine kodlarına dönüştürülmesi ve garbage collection gibi yöntemler yerine referance-ownership ve borrow-check gibi yöntemlerle maliyeti düşük memory management yapabilmesi. Şimdilik bu kadar yeterli **RUST** hakkında daha detaylı bilgilere [referans dökümanlardan](https://doc.rust-lang.org/book/) ulaşabilirsiniz.


Peki Rest/websocket yerine neden gRPC kullanıyorum derseniz ona da kısaca değinmekte fayda var. Daha henüz tam anlamıyla desteklenmeyen, http/2 ile gelen yeniliklerden biri olan gRPC, performans açısından rest arasında çok ciddi farklar var . Bunun hakkında yapılmış benchmark çalışmalarını incelemenizi tavsiye ederim.gRPC, web tararında, tüm browserlar tarafından henüz tam olarak desteklenmiyor fakat mobil istemcilerde kullanmamız, çok büyük sorun yaratmayacaktır.


    Basit olarak senaryo şu şekilde olacak...
    Flutter uygulaması yazacağım,iki text alanı olacak.
    Bu uygulama  gRPC istemicisi olarak çalışacak. 
    Text kutularından birine yazı yazıldığında server a gidecek ve dönen cevap diğer text kutusuna yazılacak.
    Server içerik üzerinde bir değişiklik yapmayacağı için "echo server" server diyebiliriz.

## RUST ile gRPC sunucu uygulaması


**Rust** üzerinde gRPC kullanabilmemizi sağlayacak framework'ün ismi **[tonic](https://github.com/hyperium/tonic)** 
    
    Bu aşamada,RUST geliştirme ortamının kurulmuş olduğunu varsayıyorum.

Aşağıdaki shell komutlarını çalıştırıyoruz

```console
$ cargo new echo-server
```
Şimdi oluşturalan proje dizinini visual studio code ile açalım

ardından proto isminde bir dizin oluşturalım. Onun altına da echo.proto isminde bir dosya oluşturuyoruz. içeriği şu şekilde olacak.

```protobuf
syntax = "proto3";
package echopackage;

service Echo {
    rpc do_echo (EchoRequest) returns (EchoReply);
}

message EchoRequest {
   string  source_content = 1;
}

message EchoReply {
    string reply_content= 1;
}
```

ve aşağıdaki gibi görünecek
![alt text](/assets/img/posts/echo_proto.png "echo.proto")

Bu tanım , **tonic** tarafından gRPC server proxy kodlarının üretilmesinde kullanılacak.Ayrıca bu proto tanımı flutter uygulamasının kullanacağı gRPC client proxy kodlarının üretilmesinde de kullanılacak. Böylece sunucu ve istemci arasında gerçekleşecek haberleşme protobuf formatında tam uyumlu olmuş olacak. Hala henüz bu konuda bilmediğiniz bazı şeyler olduğunu düşünüyorsanız, [protobuf](https://developers.google.com/protocol-buffers) formatına detaylı bakabilirsiniz.***(JSON yerine kullanılan binary format)***


Şimdi rust ın kullanacağı bağımlılıkları ekleyelim
Cargo.toml dosyasını açın ve aşağıdaki satırları kopyalayın


```yaml
[package]
name = "echo-server"
version = "0.1.0"
authors = ["ahmet can <mail@ahmetcan.com.tr>"]
edition = "2018"

[dependencies]
tonic = "0.3"
prost = "0.6"
tokio = { version = "0.2", features = ["macros"] }

[build-dependencies]
tonic-build = "0.3"
```

projenin root dizine build.rs isminde bir dosya oluşturun ve aşağıda verilmiş olan kodları ekleyin
bu **tonic** tarafından çalıştılacak ve derleme aşamasında gRPC proxy kodların üretilmesini sağlayacak.


```rust
fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::compile_protos("proto/echo.proto")?;
    Ok(())
}
```


Aşağıdaki kodları  src/main.rs içine kopyalayın 
```rust
use tonic::{transport::Server, Request, Response, Status};

use echo_grpc::echo_server:: {Echo, EchoServer};
use echo_grpc::{EchoReply, EchoRequest};

use std::net::{IpAddr, Ipv4Addr, SocketAddr};

pub mod echo_grpc {
    tonic::include_proto!("echopackage"); 
}

#[derive(Debug, Default)]
pub struct EchoImpl {}

#[tonic::async_trait]
impl Echo for EchoImpl {
    async fn do_echo(&self,request: Request<EchoRequest>,) -> Result<Response<EchoReply>,Status> { 
        println!("Got a request: {:?}", request);
        let reply = echo_grpc::EchoReply {
            reply_content: request.into_inner().source_content,
        };
        Ok(Response::new(reply)) 
    }
}


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
   // let addr = "[::1]:50051".parse()?;
    let socket = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(0, 0, 0, 0)), 50051);

    let echoservice = EchoImpl::default();

    Server::builder()
        .add_service(EchoServer::new(echoservice))
        .serve(socket)
        .await?;

    Ok(())
}
```

aşağıdaki shell komutunu çalıştırın

```console
$ cargo run 
```
**artık gRPC sunucumuz hizmet vermeye başladı**


## Flutter ile gRPC istemci uygulaması 
Şimdi gRPC istemcisi için Flutter Uygulamasını  hazırlayalım
    
    Bu aşamada Flutter geliştirme ortamının kurulduğunu varsayıyorum


Aşağıdaki komutu shell komutunu çalıştırıp flutter uygulaması oluşturuyoruz ve projeyi visual studio code ile açıyoruz

```console
$ flutter create echoclient
```

öncelikle dart için gRPC plugin kurulumunu yapalım,**ben linux için anlatıyorum**

[https://github.com/protocolbuffers/protobuf/releases](https://github.com/protocolbuffers/protobuf/releases)


bu adresten ilgili toolu indirip sistem **path** listesine ekleyin


aşağıdaki komutu yazarak  protobuf plugin active edin

```console
$ pub global activate protoc_plugin
```

daha önce bahsetmiş olduğum sunucu tarafında kullandığımız **echo.proto** dosyasını  **echoclient/proto** dizinine kopyalayın

aşağıdaki komutu çalıştırın ve proxy dosyalarını oluşturun.Bu dosyalar **lib/protos** dizinine oluşturulacak
```console
$ protoc --dart_out=grpc:lib/  proto/echo.proto
```

şimdi flutter projesi  **pubspec.yaml** dosyasına gelelelim aşağıdaki paketleri ekleyelim

```yaml
dependencies:
    ...
  grpc: ^1.0.1
  protobuf: ^0.13.4
  crypto: ^2.0.6
```

**lib** dizini altına **echoservice.dart** adına bir dosya oluşturalım ve aşağıdaki kodları ekleyelim. 

```dart
import 'package:echoclient/proto/echo.pb.dart';
import 'package:echoclient/proto/echo.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class EchoService {
  static EchoClient client;

  EchoService() {

    client = EchoClient(
      ClientChannel(
        "192.168.1.33",
        port: 50051,
        options: ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      ),
    );
  }

  Future<EchoReply> commitMessage(String body) async {
    return client.do_echo(
      EchoRequest()
        ..sourceContent=body
        
    );
  }
}
```

Şimdi yukardaki kodları uygulamanın UI kısmında kullanalım.

main.dart altında ilgili değişiklikleri yaptık bir tane TextField ile string değeri alıyoruz ve bunu gönderiyoruz gelen cevabı da bir Text ile gösteriyoruz.

```dart
...
  String _reply="";
  var service=EchoService();
  var currentReply="";
  final request_text_controller = TextEditingController();
  void _sendToServer() async{
    var reply=await service.commitMessage(request_text_controller.text);
    setState(() {
       _reply=reply.replyContent;
    });
  }

  @override
  Widget build(BuildContext context) {
....
```

butona bastığımız zaman


![alt text](/assets/img/posts/sonuc.png "Sonuç")



