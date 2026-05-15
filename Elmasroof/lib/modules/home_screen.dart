import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_states.dart';
import 'package:elmasroof/layouts/alerts/add_child_alert.dart';
import 'package:elmasroof/modules/history_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, });


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _expensesChangeController = TextEditingController()
    ..text = '0';
  final GlobalKey<FormFieldState> _expensesChangeKey = GlobalKey();
  late HiveStorage hiveStorage = HiveStorage();
  late HomeCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocConsumer<HomeCubit, HomeStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    _cubit = HomeCubit.get(context);
                    return Column(
                      children: (_cubit.childrenNames.isNotEmpty) ? [
                        createButton(
                          text: 'إضافة إبن/بنت',
                          onPressed: () =>
                              showAddChildAlert(context: context, cubit: _cubit),
                          icon: Icons.add,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Image.asset(ConstAssetImages.saveMoney.path),
                        Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(24.0),
                              child: SvgPicture.asset(
                                ConstAssetImages.coinsBank.path,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10,),
                                DropdownMenu(
                                  dropdownMenuEntries: List.generate(
                                    _cubit.childrenNames.length,
                                        (index) => DropdownMenuEntry(
                                      value: index,
                                      label: _cubit.childrenNames[index],
                                    ),
                                  ),
                                  initialSelection: _cubit.selectedIndex,
                                  onSelected: (index) {
                                    _cubit.changeChild(index!);
                                  },
                                  controller: TextEditingController()..text = _cubit.childrenNames[_cubit.selectedIndex],
                                  menuStyle: const MenuStyle(
                                    backgroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                                  ),
                                  inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                SizedBox(height: 70,),
                                createTitle(title: 'المبلغ الحالى', titleSize: 18, color: Colors.white),
                                Container(
                                  width: 140,
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey,
                                  ),
                                  child: ValueListenableBuilder(
                                      valueListenable: ListenOnValue.expensesNotifier,
                                      builder: (context, value, child) {
                                        return Text(
                                          (hiveStorage.get(_cubit.childrenNames[_cubit.selectedIndex]) ?? 0.0).toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        );
                                      }
                                  ),
                                ),
                                const SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () {
                                        if(_expensesChangeKey.currentState!.validate()) {
                                          double value = double.parse(_expensesChangeController.text);
                                          _expensesChangeController.text = '0';
                                          _cubit.addToName(-value);
                                        }
                                      },
                                      icon: const CircleAvatar(
                                        backgroundColor: Colors.lightBlue,
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    createTextField(
                                        width: 80,
                                        paddingHorizontal: 0,
                                        backgroundColor: Colors.grey,
                                        controller: _expensesChangeController,
                                        formKey: _expensesChangeKey,
                                        alignment: TextAlign.center,
                                        inputType: TextInputType.number,
                                        formatter: PositiveFormatter(),
                                        validator: (String value){
                                          if(value.isEmpty){
                                            return 'أدخل الرقم أولاً';
                                          }
                                          if(!PositiveFormatter().patternFormatter().hasMatch(value)) {
                                            return 'أدخل رقم صحيح';
                                          }
                                          return null;
                                        }
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () {
                                        if(_expensesChangeKey.currentState!.validate()) {
                                          double value = double.parse(_expensesChangeController.text);
                                          _expensesChangeController.text = '0';
                                          _cubit.addToName(value);
                                        }
                                      },
                                      icon: const CircleAvatar(
                                        backgroundColor: Colors.lightBlue,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                createButton(
                                  text: 'تاريخ المعاملات',
                                  onPressed: () {
                                    String name = _cubit.childrenNames[_cubit.selectedIndex];
                                    SqfliteDB().getChildTransactions(name)
                                        .then((list) => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => HistoryScreen(
                                            name: name,
                                            transactionList: list,
                                          ),
                                        )
                                    ).catchError((e) => print(e.toString()))
                                    );
                                  },
                                  icon: Icons.date_range,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        createButton(
                          text: 'حذف',
                          onPressed: () {
                            _cubit.removeChild();
                          },
                          icon: Icons.delete_outline,
                        ),
                      ] : [
                        Image.asset(ConstAssetImages.richChildren.path),
                        const SizedBox(
                          height: 25,
                        ),
                        createButton(
                          text: 'إضافة إبن/بنت',
                          onPressed: () =>
                              showAddChildAlert(context: context, cubit: _cubit),
                          icon: Icons.add,
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
