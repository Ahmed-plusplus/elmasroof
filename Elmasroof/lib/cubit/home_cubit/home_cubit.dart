import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
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
  SqfliteDB db = SqfliteDB();

  void addChild(String name, ChildModel value){
    hiveStorage.put(name, value);
    childrenNames.add(name);
    selectedIndex = childrenNames.length - 1;
    stickerPath = ConstAssetImages.face1.path;
    emit(AddChildState());
  }

  void changeChild(int index){
    selectedIndex = index;
    emit(ChangeChildState());
  }

  void addToName(double value){
    var child = hiveStorage.get(childrenNames[selectedIndex])!;
    child.expenses += value;
    hiveStorage.put(childrenNames[selectedIndex], child);
    db.insertChildData(
      ChildExpensesChangingModel(
        name: childrenNames[selectedIndex],
        expenses: value,
        total: child.expenses,
      ),
    );
    emit(AddToNameState());
  }

  void removeChild(){
    hiveStorage.remove(childrenNames[selectedIndex]);
    db.removeChild(childrenNames[selectedIndex]);
    childrenNames.removeAt(selectedIndex);
    selectedIndex = 0;
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

}