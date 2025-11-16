import 'package:test/test.dart';
import 'package:tcmb_doviz/tcmb_doviz.dart';

void main() {
  group('TcmbClient', () {
    late TcmbClient client;

    setUp(() {
      client = TcmbClient();
    });

    tearDown(() {
      client.close();
    });

    test('getGuncelKurlar returns data', () async {
      final kurlar = await client.getGuncelKurlar();
      
      expect(kurlar.tarih, isNotNull);
      expect(kurlar.tumDovizler, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('getKurlar with specific date returns data', () async {
      // Bilinen bir iş günü
      final tarih = DateTime(2024, 1, 2);
      final kurlar = await client.getKurlar(tarih);
      
      expect(kurlar.tarih, equals(tarih));
      expect(kurlar.tumDovizler, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('USD kuru mevcut', () async {
      final kurlar = await client.getGuncelKurlar();
      
      expect(kurlar.usd, isNotNull);
      expect(kurlar.usd!.kod, equals('USD'));
      expect(kurlar.usd!.alis, isNotNull);
      expect(kurlar.usd!.satis, isNotNull);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('EUR kuru mevcut', () async {
      final kurlar = await client.getGuncelKurlar();
      
      expect(kurlar.eur, isNotNull);
      expect(kurlar.eur!.kod, equals('EUR'));
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('Doviz', () {
    test('equality works correctly', () {
      final doviz1 = Doviz(kod: 'USD', birim: 1, alis: 30.0);
      final doviz2 = Doviz(kod: 'USD', birim: 1, alis: 31.0);
      final doviz3 = Doviz(kod: 'EUR', birim: 1, alis: 32.0);

      expect(doviz1, equals(doviz2));
      expect(doviz1, isNot(equals(doviz3)));
    });

    test('toString works', () {
      final doviz = Doviz(kod: 'USD', birim: 1, alis: 30.0, satis: 30.5);
      expect(doviz.toString(), contains('USD'));
      expect(doviz.toString(), contains('30.0'));
    });
  });
}
