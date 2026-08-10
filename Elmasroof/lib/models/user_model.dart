import 'package:elmasroof/models/child_model.dart';

class UserModel {
  String uid;
  int parentType;
  DateTime lastUpdate;
  List<ChildModel> children;

  UserModel({
    required this.uid,
    required this.parentType,
    required this.lastUpdate,
    required this.children,
  });
}