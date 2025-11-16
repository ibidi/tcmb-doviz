import 'package:tcmb_doviz/tcmb_doviz.dart';

void main() async {
  final client = TcmbClient();

  try {
    // Güncel kurları getir
    print('=== GÜNCEL KURLAR ===');
    final guncelKurlar = await client.getGuncelKurlar();
    print('Tarih: ${guncelKurlar.tarih}');
    print('');

    // Popüler dövizleri göster
    if (guncelKurlar.usd != null) {
      final usd = guncelKurlar.usd!;
      print('USD:');
      print('  Alış: ${usd.alis}');
      print('  Satış: ${usd.satis}');
      print('');
    }

    if (guncelKurlar.eur != null) {
      final eur = guncelKurlar.eur!;
      print('EUR:');
      print('  Alış: ${eur.alis}');
      print('  Satış: ${eur.satis}');
      print('');
    }

    // Tüm dövizleri listele
    print('=== TÜM DÖVİZLER ===');
    for (final doviz in guncelKurlar.tumDovizler) {
      print('${doviz.kod.padRight(6)} - ${doviz.isim ?? ""}');
      if (doviz.alis != null) {
        print('  Alış: ${doviz.alis}  Satış: ${doviz.satis}');
      }
    }
    print('');

    // Belirli bir tarihteki kurları getir
    print('=== TARİHSEL VERİ ===');
    final tarih = DateTime(2024, 1, 2);
    final tarihselKurlar = await client.getKurlar(tarih);
    print('Tarih: ${tarihselKurlar.tarih}');
    print('USD Alış: ${tarihselKurlar.usd?.alis}');
    print('EUR Alış: ${tarihselKurlar.eur?.alis}');

  } on TcmbException catch (e) {
    print('Hata: $e');
  } finally {
    client.close();
  }
}
