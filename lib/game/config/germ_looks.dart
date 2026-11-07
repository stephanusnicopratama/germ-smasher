class GermLook {
  const GermLook({
    required this.body,
    required this.eye,
    required this.mouth,
    this.extra,
    this.extraY = -0.46,
  });

  final String body;
  final String eye;
  final String mouth;
  final String? extra;
  final double extraY;

  static const looks = <GermLook>[
    GermLook(
      body: 'body_greenA.png',
      eye: 'eye_cute_light.png',
      mouth: 'mouth_closed_happy.png',
      extra: 'detail_green_antenna_small.png',
    ),
    GermLook(
      body: 'body_blueC.png',
      eye: 'eye_blue.png',
      mouth: 'mouthB.png',
      extra: 'detail_blue_antenna_small.png',
    ),
    GermLook(
      body: 'body_yellowB.png',
      eye: 'eye_yellow.png',
      mouth: 'mouthA.png',
      extra: 'detail_yellow_horn_small.png',
    ),
    GermLook(
      body: 'body_redD.png',
      eye: 'eye_cute_dark.png',
      mouth: 'mouthE.png',
    ),
    GermLook(
      body: 'body_greenF.png',
      eye: 'eye_human_green.png',
      mouth: 'mouth_closed_happy.png',
      extra: 'snot_small.png',
      extraY: 0.34,
    ),
    GermLook(
      body: 'body_whiteE.png',
      eye: 'eye_closed_happy.png',
      mouth: 'mouthB.png',
    ),
  ];

  static List<String> get assetFiles {
    final names = <String>{};
    for (final look in looks) {
      names.add(look.body);
      names.add(look.eye);
      names.add(look.mouth);
      final extra = look.extra;
      if (extra != null) {
        names.add(extra);
      }
    }
    return names.toList();
  }
}
