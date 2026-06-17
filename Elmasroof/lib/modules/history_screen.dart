import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/cubit/history_cubit/history_states.dart';
import 'package:elmasroof/layouts/alerts/add_description_alert.dart';
import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key, required this.name, required this.transactionList,});

  String name;
  List<ChildExpensesChangingModel> transactionList;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  SqfliteDB db = SqfliteDB();
  late HistoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: (widget.transactionList.isNotEmpty) ? _transactionsList()
          : Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Transform.rotate(
          angle: -0.3,
          child: Text(
            'لا توجد معاملات ل${widget.name}\nحتى الآن',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ))
    );
  }

  Widget _transactionsList() => Column(
    children: [
      createTitle(title: 'الإسم: ${widget.name}'),
      const SizedBox(height: 10,),
      _header(),
      const SizedBox(height: 10,),
      _itemList(),
    ],
  );

  Widget _header() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(5),
    ),
    child: const Row(
      children: [
        SizedBox(width: 50,),
        Expanded(child: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 50,),
        Expanded(child: Text(
            'نوع العملة', textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: Text(
            'القيمة المتغيرة', textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,),
          ),
        ),
        SizedBox(width: 15,),
        Expanded(
          child: Text(
            'الإجمالى', textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,),
          ),
        ),
      ],
    ),
  );

  Widget _itemList() => Expanded(
    child: ValueListenableBuilder(
        valueListenable: ListenOnValue.expensesNotifier,
        child: const SizedBox(height: 2,),
        builder: (context, value, child) {
          return ListView.separated(
            itemBuilder: (context, index) => BlocConsumer<HistoryCubit, HistoryStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  cubit = HistoryCubit.get(context);
                  String dateTime = widget.transactionList[index].dateTime!.toString();
                  String date = dateTime.substring(0, dateTime.indexOf(' '));
                  String time = dateTime.substring(dateTime.indexOf(' ') + 1, dateTime.indexOf('.'));
                  (Currency, double) expenses = widget.transactionList[index].expenses;
                  return _item(
                    child: widget.transactionList[index],
                    date: date,
                    time: time,
                    currency: expenses.$1,
                    value: expenses.$2,
                    total: widget.transactionList[index].total,
                  );
                }
            ),
            separatorBuilder: (context, index) => child ?? const SizedBox(height: 2,),
            itemCount: widget.transactionList.length,
            shrinkWrap: true,
          );
        }
    ),
  );

  Widget _item({
    required ChildExpensesChangingModel child,
    required String date,
    required String time,
    required Currency currency,
    required double value,
    required (Currency, double) total
  }) => InkWell(
    child: GestureDetector(
      onLongPress: () => showAddDescriptionAlert(
        context: context,
        onUpdateDescription: (id, description)
        => cubit.updateDescriptionOfTransaction(id, description),
        child: child,
        description: child.description,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: Column(
          children: [
            _processDetails(
              date: date, time: time, currency: currency, value: value, total: child.total.$2,
            ),
            if(child.description.isNotEmpty)
              _detailsText(child.description),
          ],
        ),
      ),
    ),
  );

  Widget _changeValueText(double value) => Text(
    value >= 0 ? '+${value}' : '${value}',
    textAlign: TextAlign.start,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: value >= 0 ? Colors.green : Colors.red,
    ),
  );

  Widget _totalText(double total) => Text(
    '${total}',
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _detailsText(String description) => Container(
    margin: const EdgeInsets.only(top: 8.0),
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          description,
          textAlign: TextAlign.end,
        ),
        const Text(
          'التفاصيل: ',
          textAlign: TextAlign.start,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _processDetails({
    required String date,
    required String time,
    required Currency currency,
    required double value,
    required double total,
  }) => Row(
    children: [
      Text(date, style: const TextStyle(fontWeight: FontWeight.bold),),
      const SizedBox(width: 5,),
      Text(time, style: const TextStyle(fontSize: 12),),
      const SizedBox(width: 35,),
      SvgPicture.asset(currency.icon, width: 22, height: 22,),
      const SizedBox(width: 25,),
      Expanded(child: _changeValueText(value)),
      const SizedBox(width: 7,),
      Expanded(child: _totalText(total),),
    ],
  );

}
