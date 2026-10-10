/// The 16 German federal states. Public holidays and school holidays
/// differ per state; the [code] is the ISO 3166-2 suffix (`DE-NW` → `NW`).
enum GermanState {
  bw('BW'),
  by('BY'),
  be('BE'),
  bb('BB'),
  hb('HB'),
  hh('HH'),
  he('HE'),
  mv('MV'),
  ni('NI'),
  nw('NW'),
  rp('RP'),
  sl('SL'),
  sn('SN'),
  st('ST'),
  sh('SH'),
  th('TH');

  const GermanState(this.code);

  final String code;

  /// `null` for unknown codes (e.g. a corrupt setting).
  static GermanState? fromCode(String? code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}
