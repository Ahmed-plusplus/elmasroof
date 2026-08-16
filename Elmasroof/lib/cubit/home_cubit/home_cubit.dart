import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/enums/currency.dart';
import 'package:elmasroof/shared/enums/transaction_type.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:elmasroof/shared/network/remote/firebase/firebase_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {

  HomeCubit(this.hiveStorage) : super(HomeInitialState()){
    childrenNames.addAll(hiveStorage.getKeys());
    FirebaseHandler.instance.listenToChildChanges(this, SharedManager.getData(key: SharedManager.USER_ID) ?? '');
  }

  static HomeCubit get(context) => BlocProvider.of(context);

  HiveStorage hiveStorage;
  List<dynamic> childrenNames = [];
  String stickerPath = ConstAssetImages.face1.path;
  int selectedIndex = 0;
  Currency childCurrency = Currency.pound;
  Currency addChildCurrency = Currency.pound;
  SqfliteDB db = SqfliteDB();

  void addChild(String name, ChildModel value){
    hiveStorage.put(name, value);
    childrenNames.add(name);
    selectedIndex = childrenNames.length - 1;
    stickerPath = ConstAssetImages.face1.path;
    addChildCurrency = Currency.pound;
    FirebaseHandler.instance.addNewChild(SharedManager.getData(key: SharedManager.USER_ID) ?? '', value);
    emit(AddChildState(value));
  }

  void changeChild(int index){
    selectedIndex = index;
    emit(ChangeChildIndexState());
  }

  Future<void> addToName(Currency currency, double value) async {
    var child = hiveStorage.get(childrenNames[selectedIndex])!;
    child.expenses[currency] = (child.expenses[currency] ?? 0) + value;
    hiveStorage.put(childrenNames[selectedIndex], child);
    FirebaseHandler.instance.updateChild(SharedManager.getData(key: SharedManager.USER_ID) ?? '', child);
    emit(
      AddToNameState(
        await db.insertChildData(
          ChildExpensesChangingModel(
            name: childrenNames[selectedIndex],
            expenses: (currency, value),
            total: (currency, child.expenses[currency] ?? 0),
          ),
          TransactionType.customTransaction,
        ),
        child
      )
    );
  }

  void removeChild(){
    ChildModel child = hiveStorage.get(childrenNames[selectedIndex])!;
    FirebaseHandler.instance.removeChild(SharedManager.getData(key: SharedManager.USER_ID) ?? '', child.name);
    if(child.otherParentId != null){
      FirebaseHandler.instance.removeChild(child.otherParentId!, child.name);
    }
    hiveStorage.remove(childrenNames[selectedIndex]);
    db.removeChild(childrenNames[selectedIndex]);
    childrenNames.removeAt(selectedIndex);
    emit(RemoveChildState());
  }

  void changeSticker(int index) {
    stickerPath = ConstAssetImages.faces[index].path;
    emit(ChangeStickerState());
  }

  void changeChildSticker(int index) {
    var child = hiveStorage.get(childrenNames[selectedIndex])!;
    child.stickerPath = ConstAssetImages.faces[index].path;
    hiveStorage.put(childrenNames[selectedIndex], child);
    FirebaseHandler.instance.updateChild(SharedManager.getData(key: SharedManager.USER_ID) ?? '', child);
    emit(ChangeChildStickerState());
  }

  void changeAddChildCurrency(Currency currency) {
    addChildCurrency = currency;
    emit(ChangeAddChildCurrencyState());
  }

  void changeChildCurrency(Currency currency) {
    childCurrency = currency;
    emit(ChangeChildCurrencyState());
  }

  void updateDescriptionOfTransaction(int id, String description){
    db.updateDescription(id, description);
    emit(UpdateDescriptionState());
  }

  void updateChildrenList(List<ChildModel> selectedChildrenList, String otherParentId) {
    selectedChildrenList.forEach((child) {
      child.otherParentId = otherParentId;
      hiveStorage.put(child.name, child);
    });

    FirebaseHandler.instance.linkParents(SharedManager.getData(key: SharedManager.USER_ID) ?? '', otherParentId, selectedChildrenList);

    emit(UpdateChildrenListState());
  }

  void updateChildFromFirebase(ChildModel child) {
    hiveStorage.put(child.name, child);
    childrenNames.clear();
    childrenNames.addAll(hiveStorage.getKeys());
    emit(ChangeChildState());
  }

   void removeChildFromFirebase(String childName) {
     hiveStorage.remove(childName);
     db.removeChild(childName);
     childrenNames.remove(childName);
     if (selectedIndex >= childrenNames.length && selectedIndex > 0) {
       selectedIndex--;
     }
     emit(RemoveChildState());
   }

   void getAllDataFromFirebase(String uid){
    hiveStorage.removeAll()
      .then((value) {
        selectedIndex = 0;
        childrenNames.clear();
        FirebaseHandler.instance.getUser(uid)
            .then((userModel) {
          if (userModel != null) {
            userModel.children.forEach((child) => hiveStorage.put(child.name, child));
            childrenNames.addAll(hiveStorage.getKeys());
            emit(OnSuccessGetDateFromFirebaseState());
          } else {
            emit(OnErrorState('لم يتم العثور على بيانات سابقة'));
          }
        }).catchError((e) => emit(OnErrorState('تعذر استرداد البيانات')));
    }).catchError((e) => emit(OnErrorState('تعذر تغيير البيانات الحالية')));

  }

}