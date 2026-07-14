import 'package:elmasroof/cubit/radio_group_cubit/radio_group_cubit.dart';
import 'package:elmasroof/layouts/custom_widget/radio_group/elmasroof_radio_group.dart';
import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends ElmasroofRadioGroup<T> {
  CustomRadioGroup({super.key, required this.list, required this.icons, required super.callBack});

  List<T> list;
  List<IconData> icons;

  @override
  State<CustomRadioGroup<T>> createState() => _CustomRadioGroupState<T>();

  @override
  Widget createRadioGroup(RadioGroupCubit cubit) {
    // TODO: implement createRadioGroup
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => cubit.onChangeRadio(index),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icons[index], size: 20.0,),
                SizedBox(width: 5.0,),
                Text(list[index].toString(),),
                Radio<T>(
                  value: list[index],
                  groupValue: list[cubit.currentSelection],
                  onChanged: (value) {
                    callBack(value);
                    cubit.onChangeRadio(index);
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 20,),
        shrinkWrap: true,
        itemCount: list.length,
      ),
    );
  }
}

class _CustomRadioGroupState<T> extends State<CustomRadioGroup<T>> {

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(context);
  }
}
