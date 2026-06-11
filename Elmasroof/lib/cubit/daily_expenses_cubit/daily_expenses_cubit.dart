import 'package:elmasroof/shared/enum/currency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'daily_expenses_state.dart';

class DailyExpensesCubit extends Cubit<DailyExpensesState> {

  DailyExpensesCubit() : super(InitDailyExpensesState());

  static DailyExpensesCubit get(context) => BlocProvider.of(context);

  Currency currency = Currency.pound;

  void changeCurrency(Currency newCurrency){
    currency = newCurrency;
    emit(ChangeDailyExpensesCurrencyState());
  }

}