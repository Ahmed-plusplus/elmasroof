import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/models/reward_data_model.dart';
import 'package:elmasroof/models/user_model.dart';
import 'package:elmasroof/shared/enums/currency.dart';
import 'package:elmasroof/shared/enums/reward.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';

class FirebaseHandler {
  FirebaseHandler._();

  static final FirebaseHandler instance = FirebaseHandler._();

  final _root = FirebaseFirestore.instance.collection('users');

  Future<bool> addNewUser(UserModel user) async{
    try {
      await _root.doc(SharedManager.getData(key: SharedManager.USER_ID)).set({
        'parentType': user.parentType,
        'lastUpdate': user.lastUpdate.toIso8601String(),
      });
      user.children.forEach((child) async =>
          await _root.doc(SharedManager.getData(key: SharedManager.USER_ID)).collection('children')
          .doc(child.name).set(child.toMap())
      );
      return Future.value(true);
    } catch (e) {
      print('Error adding new user: $e');
      return Future.value(false);
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _root.doc(uid).get();
      final childrenCollection = await _root.doc(uid).collection('children').get();

      if (doc.exists) {
        final data = doc.data()!;
        return UserModel(
          uid: uid,
          parentType: data['parentType'],
          lastUpdate: DateTime.parse(data['lastUpdate']),
          children: childrenCollection.docs.map((childDoc) {
            final childData = childDoc.data();
            return ChildModel.fromJson(childData);
          }).toList(),
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<bool> removeAllData(String uid) async {
    try {
      final childrenCollection = await _root.doc(uid).collection('children').get();
      for (var childDoc in childrenCollection.docs) {
        await childDoc.reference.delete();
      }
      await _root.doc(uid).delete();
      return Future.value(true);
    } catch (e) {
      print('Error removing all data: $e');
      return Future.value(false);
    }
  }

  Future<bool> linkParents(String uid, String otherParentId, List<ChildModel> children) async {
    try {
      for (var child in children) {
        await _root.doc(uid).collection('children').doc(child.name).set(child.toMap());
        child.otherParentId = uid;
        await _root.doc(otherParentId).collection('children').doc(child.name).set(child.toMap());
      }
      return Future.value(true);
    } catch (e) {
      print('Error linking parents: $e');
      return Future.value(false);
    }
  }

  Future<bool> unlinkChild(String uid, ChildModel child) async {
    try {
      String otherParentId = child.otherParentId!;
      child.otherParentId = null;
      await _root.doc(uid).collection('children').doc(child.name).set(child.toMap());
      await _root.doc(otherParentId).collection('children').doc(child.name).set(child.toMap());
      return Future.value(true);
    } catch (e) {
      print('Error unlinking child: $e');
      return Future.value(false);
    }
  }

  Future<bool> addNewChild(String uid, ChildModel child) async {
    return await updateChild(uid, child);
  }

  Future<bool> updateChild(String uid, ChildModel child) async {
    try {
      await _root.doc(uid).collection('children').doc(child.name).set(child.toMap());
      if(child.otherParentId != null) {
        await _root.doc(child.otherParentId!).collection('children').doc(child.name).set(child.toMap());
      }
      return Future.value(true);
    } catch (e) {
      print('Error updating child expenses: $e');
      return Future.value(false);
    }
  }

  Future<bool> removeChild(String uid, String childName) async {
    try {
      await _root.doc(uid).collection('children').doc(childName).delete();
      return Future.value(true);
    } catch (e) {
      print('Error removing child: $e');
      return Future.value(false);
    }
  }
}