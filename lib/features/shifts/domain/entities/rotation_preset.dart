/// Ready-made rotations offered in onboarding. Labels are localized in the
/// presentation layer by name.
enum RotationPreset {
  /// Five early, two off, five late, two off, five night, two off (21 days).
  weekly3([
    'early',
    'early',
    'early',
    'early',
    'early',
    'off',
    'off',
    'late',
    'late',
    'late',
    'late',
    'late',
    'off',
    'off',
    'night',
    'night',
    'night',
    'night',
    'night',
    'off',
    'off',
  ]),

  /// Five early, two off, five late, two off (14 days).
  weekly2([
    'early',
    'early',
    'early',
    'early',
    'early',
    'off',
    'off',
    'late',
    'late',
    'late',
    'late',
    'late',
    'off',
    'off',
  ]),

  /// Continuous four-crew system: 2 early, 2 late, 2 night, 2 off (8 days).
  conti4(['early', 'early', 'late', 'late', 'night', 'night', 'off', 'off']),

  /// Continuous five-crew system: 2 early, 2 late, 2 night, 4 off (10 days).
  conti5([
    'early',
    'early',
    'late',
    'late',
    'night',
    'night',
    'off',
    'off',
    'off',
    'off',
  ]),

  /// Start from a single free week and build the cycle by hand.
  custom(['off', 'off', 'off', 'off', 'off', 'off', 'off']);

  const RotationPreset(this.slots);

  final List<String> slots;
}
