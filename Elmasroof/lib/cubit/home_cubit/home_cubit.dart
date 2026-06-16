import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:elmasroof/shared/enum/transaction_type.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {

  HomeCubit(this.hiveStorage) : super(HomeInitialState()){
    childrenNames.addAll(hiveStorage.getKeys());
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
    emit(AddChildState(value));
  }

  void changeChild(int index){
    selectedIndex = index;
    emit(ChangeChildState());
  }

  Future<void> addToName(Currency currency, double value) async {
    var child = hiveStorage.get(childrenNames[selectedIndex])!;
    child.expenses[currency] = (child.expenses[currency] ?? 0) + value;
    hiveStorage.put(childrenNames[selectedIndex], child);
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

}