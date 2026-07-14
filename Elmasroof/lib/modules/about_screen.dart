import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('عن التطبيق', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 16,),
              RichText(
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  children: [
                    const TextSpan(text: 'مرحبًا بك في تطبيق المصروف!', style: TextStyle(fontSize: 24)),
                    const TextSpan(text: '\n\n'),
                    const TextSpan(text: 'صُمم هذا التطبيق لمساعدة الآباء على تنظيم وإدارة مصروفات أبنائهم بسهولة من خلال إنشاء ملف مستقل لكل طفل،'
                        ' وتسجيل عمليات الإنفاق والادخار،'
                        ' مع دعم التعامل بعملات مختلفة.'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'يوفر التطبيق إمكانية تحديد مصروف يومي لكل طفل،'
                        ' مع إمكانية إيقافه لفترة محددة كنوع من العقوبة عند الحاجة.'
                        ' كما يتضمن نظامًا للتحفيز يعتمد على الجوائز والشارات التي يحصل عليها الأطفال وفقًا لعاداتهم في الادخار والإنفاق،'
                        ' مما يشجعهم على تنمية المسؤولية واتخاذ قرارات مالية أفضل.'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'يهدف التطبيق إلى تزويد أولياء الأمور بأداة عملية لمتابعة مصروفات الأبناء،'
                        ' وتنظيمها،'
                        ' وتحفيزهم من خلال نظام مرن يجمع بين الإدارة والمتابعة والمكافآت.'),
                    const TextSpan(text: '\n\n\n'),
                    const TextSpan(text: 'تعليمات استخدام التطبيق', style: TextStyle(fontSize: 24)),
                    const TextSpan(text: '\n\n'),
                    const TextSpan(text: 'تستخدم هذه الأيقونة '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          child: SvgPicture.asset(ConstAssetImages.giveCoin.path),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' لتعديل المصروفات اليومية الخاصة بالإبن/البنت حيث يزداد المصروف كل يوم بالمبلغ المسجل عند الضغط على الأيقونة.'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'تستخدم هذه الأيقونة '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.not_interested, color: Colors.white,),
                        ),
                      ),
                    ),
                    const TextSpan(text: ' لإضافة عقاب على الإبن/البنت لحرمانه من المصروف لمدة معينة من الأيام.'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'تنبيه:: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: 'العقوبة لا تراجع فيها وإذا أضفت عقوبة أخرى قبل انتهاء الأولى سيتم اضافة عدد الأيام على العقوبة الأولى.'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'تظهر الشارات ملونة إذا استحق هذه الشارة وعند الضغط عليها مطولاً تظهر اسم الشارة.'),
                    // const TextSpan(text: 'تطبيق المصروف يهدف إلى إدارة مصروف الأطفال ومساعدة أولياء الأمور على متابعة وتنظيم الإنفاق والادخار لكل طفل.'),
                    // const TextSpan(text: '\n'),
                    // const TextSpan(text: 'يتيح التطبيق تسجيل جميع عمليات الإنفاق والإيداع،'
                    //     ' مع إمكانية تخصيص مصروف يومي لكل طفل يتم احتسابه تلقائيًا.'),
                    // const TextSpan(text: '\n'),
                    // const TextSpan(text: 'كما يوفر نظامًا للعقوبات يسمح بإيقاف المصروف لفترة محددة عند الحاجة،'
                    //     ' بالإضافة إلى نظام تحفيزي يعتمد على الجوائز والشارات التي تُمنح للأطفال وفقًا لسلوكهم المالي ومستوى الادخار والالتزام بالإنفاق،'
                    //     ' مما يشجعهم على اكتساب عادات مالية مالية سليمة وإدارة أموالهم بمسؤولية.'),
                    // const TextSpan(text: '\n'),
                    const TextSpan(text: '\n\n\n'),
                    const TextSpan(text: 'تم إنشاء هذا التطبيق باستخدام Flutter بواسطة '),
                    const TextSpan(text: 'م/أحمد مصطفى ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: 'مطور تطبيقات الموبايل '),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
