enum ConstAssetImages {

  balance('assets/images/balance.jpeg'),
  coinsBank('assets/images/coins_bank.svg'),
  saveMoney('assets/images/save_money.jpeg'),
  richChildren('assets/images/rich_children.jpeg'),
  success('assets/images/success.svg'),
  face1('assets/images/face_1.svg'),
  face2('assets/images/face_2.svg'),
  face3('assets/images/face_3.svg'),
  face4('assets/images/face_4.svg'),
  face5('assets/images/face_5.svg'),
  face6('assets/images/face_6.svg'),
  face7('assets/images/face_7.svg'),
  face8('assets/images/face_8.svg'),
  face9('assets/images/face_9.svg'),
  face10('assets/images/face_10.svg'),
  face11('assets/images/face_11.svg'),
  face12('assets/images/face_12.svg'),
  ;

  final String path;

  const ConstAssetImages(this.path);

  static const List<ConstAssetImages> faces = [
    face1,
    face2,
    face3,
    face4,
    face5,
    face6,
    face7,
    face8,
    face9,
    face10,
    face11,
    face12,
  ];
}