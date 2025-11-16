/// TCMB API ile ilgili hataları temsil eder.
class TcmbException implements Exception {
  /// Hata mesajı
  final String message;

  TcmbException(this.message);

  @override
  String toString() => 'TcmbException: $message';
}
