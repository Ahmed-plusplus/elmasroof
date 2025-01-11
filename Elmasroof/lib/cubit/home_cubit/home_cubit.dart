import 'package:elmasroof/shared/network/local/hive_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {

  HomeCubit(this.hiveStorage) : super(HomeInitialState()){
    childrenNames.addAll(hiveStorage.getKeys());
  }

  static HomeCubit get(context) => BlocProvider.of(context);

  HiveStorage hiveStorage;
  List<dynamic> childrenNames = [];
  int selectedIndex = 0;

  void addChild(String name, double value){
    hiveStorage.add(name, value);
    childrenNames.add(name);
    selectedIndex = childrenNames.length - 1;
    emit(AddChildState());
  }

  void changeChild(int index){
    selectedIndex = index;
    emit(ChangeChildState());
  }

  void addToName(double value){
    double currentValue = hiveStorage.get(childrenNames[selectedIndex]) ?? 0.0;
    currentValue += value;
    hiveStorage.add(childrenNames[selectedIndex], currentValue);
    emit(AddToNameState());
  }

  void removeChild(){
    hiveStorage.remove(childrenNames[selectedIndex]);
    childrenNames.removeAt(selectedIndex);
    selectedIndex = 0;
    emit(RemoveChildState());
  }

}