import 'package:elmasroof/cubit/radio_group_cubit/radio_group_cubit.dart';
import 'package:elmasroof/layouts/custom_widget/radio_group/elmasroof_radio_group.dart';
import 'package:flutter/material.dart';

class VerticalRadioGroup<T> extends ElmasroofRadioGroup {
  VerticalRadioGroup({super.key, required this.list, required super.callBack});

  List<T> list;

  @override
  State<VerticalRadioGroup<T>> createState() => _VerticalRadioGroupState<T>();

  @override
  Widget createRadioGroup(RadioGroupCubit cubit) {
    // TODO: implement createRadioGroup
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => cubit.onChangeRadio(index),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(list[index].toString(),),
              Radio<T>(
                value: list[index],
                groupValue: list[cubit.currentSelection],
                onChanged: (value) {
                  callBack(value);
                  cubit.onChangeRadio(index);
                },
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        );
      },
      shrinkWrap: true,
      itemCount: list.length,
    );
  }
}

class _VerticalRadioGroupState<T> extends State<VerticalRadioGroup<T>> {

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(context);
  }
}
