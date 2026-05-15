import 'package:elmasroof/cubit/radio_group_cubit/radio_group_cubit.dart';
import 'package:elmasroof/layouts/custom_widget/radio_group/elmasroof_radio_group.dart';
import 'package:flutter/material.dart';

class HorizontalRadioGroup<T> extends ElmasroofRadioGroup<T> {
  HorizontalRadioGroup({super.key, required this.list, required super.callBack});

  List<T> list;

  @override
  State<HorizontalRadioGroup<T>> createState() => _HorizontalRadioGroupState<T>();

  @override
  Widget createRadioGroup(RadioGroupCubit cubit) {
    // TODO: implement createRadioGroup
    return Container(
      height: 20,
      padding: EdgeInsets.only(right: 20.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => cubit.onChangeRadio(index),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text(list[index].toString(), textAlign: TextAlign.end,),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(width: 20,),
          shrinkWrap: true,
          itemCount: list.length,
        ),
      ),
    );
  }
}

class _HorizontalRadioGroupState<T> extends State<HorizontalRadioGroup<T>> {

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(context);
  }
}
