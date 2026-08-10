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
          .doc(child.name).set({
            'name': child.name,
            'expenses': child.expenses.map((currency, amount) =>
                MapEntry(currency.id.toString(), amount)),
            'stickerPath': child.stickerPath,
            'increment': child.increment.map((currency, amount) =>
                MapEntry(currency.id.toString(), amount)),
            'punishmentUntil': child.punishmentUntil?.toIso8601String(),
            'rewards': child.rewards.map((reward, rewardData) =>
                MapEntry(reward.id.toString(), {
                  'value': rewardData.value,
                  'isTaken': rewardData.isTaken,
                  'isShowed': rewardData.isShowed,
                })),
            'otherParentId': null,
          })
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
            return ChildModel(
              name: childData['name'],
              expenses: (childData['expenses'] as Map<String, dynamic>).map((key, value) =>
                  MapEntry(Currency.values.firstWhere((c) => c.id == int.parse(key)), value.toDouble())),
              stickerPath: childData['stickerPath'],
              increment: (childData['increment'] as Map<String, dynamic>).map((key, value) =>
                  MapEntry(Currency.values.firstWhere((c) => c.id == int.parse(key)), value.toDouble())),
              punishmentUntil: childData['punishmentUntil'] != null
                  ? DateTime.parse(childData['punishmentUntil'])
                  : null,
              rewards: (childData['rewards'] as Map<String, dynamic>).map((key, rewardData) =>
                  MapEntry(Reward.values.firstWhere((reward) => reward.id == int.parse(key)), RewardDataModel(
                    rewardData['value'].toDouble(),
                    rewardData['isTaken'],
                    rewardData['isShowed'],
                  ))),
              otherParentId: data['otherParentId']
            );
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

}