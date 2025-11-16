# TCMB Döviz 💱

TCMB (Türkiye Cumhuriyet Merkez Bankası) döviz kurları için Dart paketi. Güncel ve tarihsel döviz kuru verilerine kolayca erişin.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)

## Özellikler

- ✅ Güncel döviz kurlarını sorgulama
- ✅ Tarihsel döviz kuru verileri
- ✅ Tüm TCMB para birimlerini destekler (USD, EUR, GBP, CHF, JPY ve daha fazlası)
- ✅ Type-safe Dart modelleri
- ✅ Null-safety desteği
- ✅ Kolay kullanım

## Kurulum

`pubspec.yaml` dosyanıza ekleyin:

```yaml
dependencies:
  tcmb_doviz: ^0.1.0
```

Ardından:

```bash
dart pub get
```

## Kullanım

### Güncel Kurları Getir

```dart
import 'package:tcmb_doviz/tcmb_doviz.dart';

void main() async {
  final client = TcmbClient();
  
  try {
    // Bugünün tüm kurlarını getir
    final kurlar = await client.getGuncelKurlar();
    
    print('Tarih: ${kurlar.tarih}');
    print('USD Alış: ${kurlar.usd?.alis}');
    print('USD Satış: ${kurlar.usd?.satis}');
    print('EUR Alış: ${kurlar.eur?.alis}');
    print('GBP Alış: ${kurlar.gbp?.alis}');
    
  } on TcmbException catch (e) {
    print('Hata: $e');
  } finally {
    client.close();
  }
}
```

### Belirli Tarih İçin Kurları Getir

```dart
final tarih = DateTime(2024, 1, 15);
final kurlar = await client.getKurlar(tarih);

print('${tarih.day}/${tarih.month}/${tarih.year} tarihindeki USD: ${kurlar.usd?.alis}');
```

### Tüm Para Birimlerini Listele

```dart
final kurlar = await client.getGuncelKurlar();

for (var doviz in kurlar.tumDovizler) {
  print('${doviz.kod} - ${doviz.isim}');
  print('  Alış: ${doviz.alis} / Satış: ${doviz.satis}');
}
```

### Belirli Para Birimi Sorgulama

```dart
final kurlar = await client.getGuncelKurlar();

// Direkt erişim
final usd = kurlar.usd;
final eur = kurlar.eur;

// Kod ile erişim
final jpy = kurlar.getKur('JPY');
final chf = kurlar.getKur('CHF');
```

## API Referansı

### TcmbClient

Ana client sınıfı.

```dart
final client = TcmbClient();
```

**Metodlar:**
- `Future<DovizKurlari> getGuncelKurlar()` - Bugünün kurlarını getirir
- `Future<DovizKurlari> getKurlar(DateTime tarih)` - Belirtilen tarihteki kurları getirir
- `void close()` - HTTP client'ı kapatır

### DovizKurlari

Döviz kuru verilerini içeren model.

**Özellikler:**
- `DateTime tarih` - Kur tarihi
- `Doviz? usd` - USD kuru
- `Doviz? eur` - EUR kuru
- `Doviz? gbp` - GBP kuru
- `Doviz? chf` - CHF kuru
- `Doviz? jpy` - JPY kuru
- `List<Doviz> tumDovizler` - Tüm para birimlerinin listesi
- `List<String> kodlar` - Mevcut para birimi kodları

**Metodlar:**
- `Doviz? getKur(String kod)` - Belirtilen kod ile döviz kuru getirir

### Doviz

Tek bir para biriminin kur bilgisi.

**Özellikler:**
- `String kod` - Para birimi kodu (USD, EUR, vb.)
- `String? isim` - Para birimi adı
- `int birim` - Birim (genellikle 1)
- `double? alis` - Döviz alış kuru
- `double? satis` - Döviz satış kuru
- `double? efektifAlis` - Efektif alış kuru
- `double? efektifSatis` - Efektif satış kuru

### TcmbException

TCMB API ile ilgili hataları temsil eder.

```dart
try {
  final kurlar = await client.getGuncelKurlar();
} on TcmbException catch (e) {
  print('Hata oluştu: ${e.message}');
}
```

## Örnek Proje

Daha fazla örnek için [`example`](example/example.dart) klasörüne bakın.

## Notlar

- TCMB resmi tatil günlerinde kur verisi yayınlamaz
- Tatil günleri için sorgu yapıldığında `TcmbException` hatası fırlatılır
- Veriler TCMB'nin resmi XML API'sinden çekilir

## Katkıda Bulunma

Katkılarınızı bekliyoruz! Pull request göndermekten çekinmeyin.

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'feat: Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## İletişim

GitHub: [@ibidi](https://github.com/ibidi)

## Teşekkürler

TCMB'ye resmi döviz kuru verilerini açık olarak sunduğu için teşekkür ederiz.