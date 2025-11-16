import 'package:xml/xml.dart';
import 'doviz.dart';

/// Belirli bir tarihteki tüm döviz kurlarını içerir.
class DovizKurlari {
  /// Kurların tarihi
  final DateTime tarih;
  
  /// Tüm döviz kurlarının map'i (kod -> Doviz)
  final Map<String, Doviz> _kurlar;

  DovizKurlari({
    required this.tarih,
    required Map<String, Doviz> kurlar,
  }) : _kurlar = kurlar;

  /// XML'den DovizKurlari nesnesi oluşturur.
  factory DovizKurlari.fromXml(Iterable<XmlElement> currencies, DateTime tarih) {
    final kurlar = <String, Doviz>{};
    
    for (final currency in currencies) {
      final kod = currency.getAttribute('CurrencyCode');
      if (kod == null) continue;
      
      final doviz = Doviz(
        kod: kod,
        isim: currency.findElements('Isim').firstOrNull?.innerText,
        birim: int.tryParse(
          currency.findElements('Unit').firstOrNull?.innerText ?? '1'
        ) ?? 1,
        alis: _parseDouble(
          currency.findElements('ForexBuying').firstOrNull?.innerText
        ),
        satis: _parseDouble(
          currency.findElements('ForexSelling').firstOrNull?.innerText
        ),
        efektifAlis: _parseDouble(
          currency.findElements('BanknoteBuying').firstOrNull?.innerText
        ),
        efektifSatis: _parseDouble(
          currency.findElements('BanknoteSelling').firstOrNull?.innerText
        ),
      );
      
      kurlar[kod] = doviz;
    }
    
    return DovizKurlari(tarih: tarih, kurlar: kurlar);
  }

  static double? _parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }

  /// Belirtilen kod ile döviz kuru getirir.
  Doviz? getKur(String kod) => _kurlar[kod.toUpperCase()];

  /// USD kurunu getirir.
  Doviz? get usd => getKur('USD');
  
  /// EUR kurunu getirir.
  Doviz? get eur => getKur('EUR');
  
  /// GBP kurunu getirir.
  Doviz? get gbp => getKur('GBP');
  
  /// CHF kurunu getirir.
  Doviz? get chf => getKur('CHF');
  
  /// JPY kurunu getirir.
  Doviz? get jpy => getKur('JPY');

  /// Tüm döviz kurlarının listesini döndürür.
  List<Doviz> get tumDovizler => _kurlar.values.toList();

  /// Mevcut para birimi kodlarının listesini döndürür.
  List<String> get kodlar => _kurlar.keys.toList();

  @override
  String toString() {
    return 'DovizKurlari(tarih: $tarih, doviz sayısı: ${_kurlar.length})';
  }
}
