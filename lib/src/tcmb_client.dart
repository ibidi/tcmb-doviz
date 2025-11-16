import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'models/doviz_kurlari.dart';
import 'exceptions/tcmb_exception.dart';

/// TCMB döviz kurları API client.
class TcmbClient {
  static const String _baseUrl = 'https://www.tcmb.gov.tr/kurlar';
  
  final http.Client _httpClient;

  /// Yeni bir [TcmbClient] oluşturur.
  /// 
  /// İsteğe bağlı olarak özel bir [httpClient] sağlanabilir.
  TcmbClient({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  /// Bugünün döviz kurlarını getirir.
  Future<DovizKurlari> getGuncelKurlar() async {
    return getKurlar(DateTime.now());
  }

  /// Belirtilen tarihteki döviz kurlarını getirir.
  /// 
  /// [tarih] parametresi ile hangi günün kurlarının getirileceği belirtilir.
  Future<DovizKurlari> getKurlar(DateTime tarih) async {
    final yil = tarih.year.toString();
    final ay = tarih.month.toString().padLeft(2, '0');
    final gun = tarih.day.toString().padLeft(2, '0');
    
    final url = '$_baseUrl/$yil$ay/$gun$ay$yil.xml';
    
    try {
      final response = await _httpClient.get(Uri.parse(url));
      
      if (response.statusCode == 404) {
        throw TcmbException(
          'Belirtilen tarih için kur verisi bulunamadı. '
          'TCMB tatil günlerinde veri yayınlamaz.',
        );
      }
      
      if (response.statusCode != 200) {
        throw TcmbException(
          'TCMB API hatası: ${response.statusCode}',
        );
      }
      
      return _parseXml(response.body, tarih);
    } catch (e) {
      if (e is TcmbException) rethrow;
      throw TcmbException('Veri alınırken hata oluştu: $e');
    }
  }

  DovizKurlari _parseXml(String xmlString, DateTime tarih) {
    try {
      final document = XmlDocument.parse(xmlString);
      final currencies = document.findAllElements('Currency');
      
      return DovizKurlari.fromXml(currencies, tarih);
    } catch (e) {
      throw TcmbException('XML parse hatası: $e');
    }
  }

  /// HTTP client'ı kapatır.
  void close() {
    _httpClient.close();
  }
}
