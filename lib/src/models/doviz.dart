/// Tek bir döviz biriminin kur bilgilerini temsil eder.
class Doviz {
  /// Para birimi kodu (örn: USD, EUR)
  final String kod;
  
  /// Para birimi adı (örn: US DOLLAR, EURO)
  final String? isim;
  
  /// Birim (genellikle 1, bazı para birimleri için farklı olabilir)
  final int birim;
  
  /// Döviz alış kuru
  final double? alis;
  
  /// Döviz satış kuru
  final double? satis;
  
  /// Efektif alış kuru
  final double? efektifAlis;
  
  /// Efektif satış kuru
  final double? efektifSatis;

  Doviz({
    required this.kod,
    this.isim,
    required this.birim,
    this.alis,
    this.satis,
    this.efektifAlis,
    this.efektifSatis,
  });

  @override
  String toString() {
    return 'Doviz(kod: $kod, alis: $alis, satis: $satis)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Doviz && other.kod == kod;
  }

  @override
  int get hashCode => kod.hashCode;
}
