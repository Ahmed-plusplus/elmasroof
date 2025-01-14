import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_states.dart';

class HistoryCubit extends Cubit<HistoryStates> {

  HistoryCubit() : super(HistoryInitialState());

  static HistoryCubit get(context) => BlocProvider.of(context);

  SqfliteDB db = SqfliteDB();

  void updateDescriptionOfTransaction(int id, String description){
    db.updateDescription(id, description);
    emit(HistoryUpdateDescriptionState());
  }

}