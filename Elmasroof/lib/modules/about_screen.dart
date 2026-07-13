import 'package:elmasroof/shared/components/components.dart';
import 'package:flutter/material.dart';

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
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                  children: [
                    const TextSpan(text: 'مرحبًا بك في تطبيق إدارة مصروف الأطفال!', style: TextStyle(fontSize: 28)),
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


                    // const TextSpan(text: 'تطبيق المصروف يهدف إلى إدارة مصروف الأطفال ومساعدة أولياء الأمور على متابعة وتنظيم الإنفاق والادخار لكل طفل.'),
                    // const TextSpan(text: '\n'),
                    // const TextSpan(text: 'يتيح التطبيق تسجيل جميع عمليات الإنفاق والإيداع،'
                    //     ' مع إمكانية تخصيص مصروف يومي لكل طفل يتم احتسابه تلقائيًا.'),
                    // const TextSpan(text: '\n'),
                    // const TextSpan(text: 'كما يوفر نظامًا للعقوبات يسمح بإيقاف المصروف لفترة محددة عند الحاجة،'
                    //     ' بالإضافة إلى نظام تحفيزي يعتمد على الجوائز والشارات التي تُمنح للأطفال وفقًا لسلوكهم المالي ومستوى الادخار والالتزام بالإنفاق،'
                    //     ' مما يشجعهم على اكتساب عادات مالية مالية سليمة وإدارة أموالهم بمسؤولية.'),
                    // const TextSpan(text: '\n'),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    const TextSpan(text: '\n\n\n'),
                    const TextSpan(text: 'تم إنشاء هذا التطبيق باستخدام Flutter بواسطة '),
                    const TextSpan(text: 'م/أحمد مصطفى عبد العزيز ', style: TextStyle(fontWeight: FontWeight.bold)),
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
