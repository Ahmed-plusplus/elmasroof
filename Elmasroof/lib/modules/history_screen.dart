import 'package:elmasroof/cubit/history_cubit/history_cubit.dart';
import 'package:elmasroof/cubit/history_cubit/history_states.dart';
import 'package:elmasroof/layouts/alerts/add_description_alert.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key, required this.name, required this.transactionList,});

  String name;
  List<ChildModel> transactionList;

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
      body: Column(
        children: [
          createTitle(title: 'الإسم: ${widget.name}'),
          const SizedBox(height: 10,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              children: [
                SizedBox(width: 50,),
                Expanded(
                  child: Text(
                    'التاريخ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Text(
                    'القيمة المتغيرة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: Text(
                    'الإجمالى',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          ValueListenableBuilder(
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
                    double expenses = widget.transactionList[index].expenses;
                    return InkWell(
                      child: GestureDetector(
                        onLongPress: () => widget.transactionList[index].description.isEmpty
                            ? showAddDescriptionAlert(
                              context: context,
                              cubit: cubit,
                              child: widget.transactionList[index],
                            ) : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold),),
                                  const SizedBox(width: 5,),
                                  Text(time, style: const TextStyle(fontSize: 12),),
                                  const Spacer(),
                                  Expanded(
                                    child: Text(
                                      expenses >= 0 ? '+$expenses' : '$expenses',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: expenses >= 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7,),
                                  Expanded(
                                    child: Text(
                                      '${widget.transactionList[index].total}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if(widget.transactionList[index].description.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.transactionList[index].description,
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
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                separatorBuilder: (context, index) => child ?? const SizedBox(height: 2,),
                itemCount: widget.transactionList.length,
                shrinkWrap: true,
              );
            }
          ),
        ],
      ),
    );
  }
}
