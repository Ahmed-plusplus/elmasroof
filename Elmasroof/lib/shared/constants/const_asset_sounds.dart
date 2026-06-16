enum ConstAssetSounds {
  increaseMoney('sounds/cash_sound.mp3'),
  decreaseMoney('sounds/fall.mp3'),
  applause('sounds/applause_cheer.mp3');

  final String path;

  const ConstAssetSounds(this.path);
}