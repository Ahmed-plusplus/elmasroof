import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_states.dart';
import 'package:elmasroof/layouts/alerts/add_child_alert.dart';
import 'package:elmasroof/modules/history_screen.dart';
import 'package:elmasroof/modules/settings_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:elmasroof/shared/network/local/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.hiveStorage});

  HiveStorage hiveStorage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _expensesChangeController = TextEditingController()
    ..text = '0';
  GlobalKey<FormFieldState> _expensesChangeKey = GlobalKey();
  late HomeCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El masroof'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => HomeCubit(widget.hiveStorage),
          child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {},
              builder: (context, state) {
                _cubit = HomeCubit.get(context);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    createButton(
                      text: 'إضافة إبن/بنت',
                      onPressed: () =>
                          showAddChildAlert(context: context, cubit: _cubit),
                      icon: Icons.add,
                    ),
                    if (_cubit.childrenNames.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
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
                            menuStyle: MenuStyle(
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
                          const SizedBox(height: 5,),
                          createTitle(title: 'المبلغ الحالى:', titleSize: 18, ),
                          Container(
                            width: 200,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey,
                            ),
                            child: Text(
                              (widget.hiveStorage.get(_cubit.childrenNames[_cubit.selectedIndex]) ?? 0.0).toString(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                padding: EdgeInsets.all(4),
                                onPressed: () {
                                  if(_expensesChangeKey.currentState!.validate()) {
                                    double value = double.parse(_expensesChangeController.text);
                                    _expensesChangeController.text = '0';
                                    _cubit.addToName(-value);
                                  }
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.lightBlue,
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              createTextField(
                                width: 100,
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
                              const SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                padding: EdgeInsets.all(4),
                                onPressed: () {
                                  if(_expensesChangeKey.currentState!.validate()) {
                                    double value = double.parse(_expensesChangeController.text);
                                    _expensesChangeController.text = '0';
                                    _cubit.addToName(value);
                                  }
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.lightBlue,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          createButton(
                            text: 'تاريخ المعاملات',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HistoryScreen(),
                              ),
                            ),
                            icon: Icons.date_range,
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
                        ],
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
