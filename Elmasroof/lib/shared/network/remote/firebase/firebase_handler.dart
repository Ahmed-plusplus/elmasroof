import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/models/user_model.dart';
import 'package:elmasroof/shared/enums/reward.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';

class FirebaseHandler {
  FirebaseHandler._();

  static final FirebaseHandler instance = FirebaseHandler._();

  final _root = FirebaseFirestore.instance.collection('users');

  Future<bool> addNewUser(UserModel user) async{
    String? uid = SharedManager.getData(key: SharedManager.USER_ID);
    if(uid == null) {
      return false;
    }
    try {
      await _root.doc(uid).set({
        'parentType': user.parentType,
        'lastUpdate': user.lastUpdate.toIso8601String(),
      });
      user.children.forEach((child) async =>
          await _root.doc(uid).collection('children')
          .doc(child.name).set(child.toMap())
          //TODO:: doc(child.name).collection('db').doc(trans.date).set(trans.toMap())
      );
      await setRewards(uid);
      return true;
    } catch (e) {
      print('Error adding new user: $e');
      return false;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    if(uid.isEmpty) {
      return null;
    }
    try {
      final doc = await _root.doc(uid).get();
      final childrenCollection = await _root.doc(uid).collection('children').get();

      if (doc.exists) {
        final data = doc.data()!;
        await getRewards(uid);
        return UserModel(
          uid: uid,
          parentType: data['parentType'],
          lastUpdate: DateTime.parse(data['lastUpdate']),
          children: childrenCollection.docs.map((childDoc) {
            final childData = childDoc.data();
            //TODO:: childTransactions = childDoc.reference.collection('db').get();
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
    if(uid.isEmpty) {
      return false;
    }
    try {
      final childrenCollection = await _root.doc(uid).collection('children').get();
      for (var childDoc in childrenCollection.docs) {
        await childDoc.reference.delete();
      }
      await _root.doc(uid).delete();
      return true;
    } catch (e) {
      print('Error removing all data: $e');
      return false;
    }
  }

  Future<bool> linkParents(String uid, String otherParentId, List<ChildModel> children) async {
    if(uid.isEmpty) {
      return false;
    }
    try {
      DateTime now = DateTime.now();
      for (var child in children) {
        await _root.doc(uid).collection('children').doc(child.name).set(child.toMap());
        await _root.doc(otherParentId).collection('children').doc(child.name).set(child.toMap());
        await _root.doc(otherParentId).collection('children').doc(child.name).update({'otherParentId': uid});
      }
      int currentParent = SharedManager.getData(key: SharedManager.PARENT_TYPE) ?? 0;
      if(currentParent == 0){
        await setRewards(otherParentId);
      } else {
        await getRewards(uid);
      }
      await _root.doc(uid).update({'lastUpdate': now.toIso8601String(),});
      await _root.doc(otherParentId).update({'lastUpdate': now.toIso8601String(),});
      return true;
    } catch (e) {
      print('Error linking parents: $e');
      return false;
    }
  }

  Future<bool> unlinkChild(String uid, ChildModel child) async {
    if(uid.isEmpty) {
      return false;
    }
    try {
      String otherParentId = child.otherParentId!;
      child.otherParentId = null;
      await _root.doc(uid).collection('children').doc(child.name).set(child.toMap());
      await _root.doc(otherParentId).collection('children').doc(child.name).set(child.toMap());
      return true;
    } catch (e) {
      print('Error unlinking child: $e');
      return false;
    }
  }

  Future<bool> addNewChild(String uid, ChildModel child) async {
    return await updateChild(uid, child);
  }

  Future<bool> updateChild(String uid, ChildModel child) async {
    if(uid.isEmpty) {
      return false;
    }
    try {
      DateTime now = DateTime.now();
      await _root.doc(uid).collection('children').doc(child.name).set(child.toMap());
      await _root.doc(uid).update({'lastUpdate': now.toIso8601String(),});
      if(child.otherParentId != null) {
        await _root.doc(child.otherParentId!).collection('children').doc(child.name).set(child.toMap());
        await _root.doc(child.otherParentId!).collection('children').doc(child.name).update({'otherParentId': uid});
        await _root.doc(child.otherParentId!).update({'lastUpdate': now.toIso8601String(),});
      }
      return true;
    } catch (e) {
      print('Error updating child expenses: $e');
      return false;
    }
  }

  Future<bool> removeChild(String uid, String childName) async {
    if(uid.isEmpty) {
      return false;
    }
    try {
      DateTime now = DateTime.now();
      await _root.doc(uid).collection('children').doc(childName).delete();
      await _root.doc(uid).update({'lastUpdate': now.toIso8601String(),});
      return true;
    } catch (e) {
      print('Error removing child: $e');
      return false;
    }
  }

  Future<void> listenToChildChanges(HomeCubit cubit, String uid) async {
    if(uid.isEmpty) {
      return;
    }
    try {
      _root.doc(uid).collection('children').snapshots().listen((snapshot) {
        DateTime now = DateTime.now();
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.modified || change.type == DocumentChangeType.added) {
            final childData = change.doc.data();
            if (childData != null) {
              final child = ChildModel.fromJson(childData);
              cubit.updateChildFromFirebase(child);
              _root.doc(uid).update({'lastUpdate': now.toIso8601String(),});
            }
          } else {
            final childName = change.doc.id;
            cubit.removeChildFromFirebase(childName);
            _root.doc(uid).update({'lastUpdate': now.toIso8601String(),});
          }
        }
      });
    } catch (e) {
      print('Error listening to child changes: $e');
    }
  }

  Future<bool> setRewards(String uid) async {
    if(uid.isEmpty){
      return false;
    }
    try{
      int currentParent = SharedManager.getData(key: SharedManager.PARENT_TYPE) ?? 0;
      Set<String>? parentIds = HiveStorage().getAll()?.where((child) => child.otherParentId != null)
          .map((child) => child.otherParentId!).toSet();
      Reward.values.forEach((reward) async{
        await _root.doc(uid).collection('rewards').doc(reward.id.toString())
            .set({'value': SharedManager.getData(key: SharedManager.getRewardId(reward)) ?? 0.0});
        if(currentParent == 0){
          parentIds?.forEach((id) async =>
              await _root.doc(id).collection('rewards').doc(reward.id.toString())
                  .set({'value': SharedManager.getData(key: SharedManager.getRewardId(reward)) ?? 0.0})
          );
        }
      });
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> getRewards(String uid) async {
    if(uid.isEmpty){
      return false;
    }
    try{
      Reward.values.forEach((reward) async{
        final rewardsDoc = await _root.doc(uid).collection('rewards').doc(reward.id.toString()).get();
        if(rewardsDoc.exists){
          await SharedManager.putData(key: SharedManager.getRewardId(reward), value: rewardsDoc.data()!);
        }
      });
      return true;
    }catch(e){
      return false;
    }
  }

  // TODO:: sync sqflite database with firebase
  
  Future<bool> updateTransaction(String uid, String? otherParentId, ChildExpensesChangingModel trans) async {
    if(uid.isEmpty){
      return false;
    }
    try{
      // await _root.doc(uid).collection('children').doc(trans.name).set({});
      return true;
    }catch(e){
      return false;
    }
  }

}