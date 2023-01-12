import 'package:flutter/material.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';
import 'package:med/presentation/resources/styles_manager.dart';

class HotlinesPage extends StatefulWidget {
  const HotlinesPage({Key? key}) : super(key: key);

  @override
  State<HotlinesPage> createState() => _HotlinesPageState();
}

class _HotlinesPageState extends State<HotlinesPage> {
  final List<Contact> _list = [
    Contact("Amang Rodriguez Medical Center", "Marikina", "941-5854 115"),
    Contact("Dr. J. Fabella Memorial Hospital", "Manila", "8733-8536"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Hotlines',
            style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: FontSize.s24,
            ),
          ),
          const SizedBox(
            height: AppSize.s20,
          ),
          Container(
            height: AppSize.s100,
            decoration: BoxDecoration(
              color: ColorManager.red,
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nationwide Hotline',
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  Text(
                    '112 or 117',
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: AppSize.s20,
          ),
          Expanded(
            child: ListView.separated(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  final contact = _list[index];

                  return Container(
                    padding: const EdgeInsets.all(AppPadding.p12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                      border: Border.all(color: ColorManager.darkgray),
                    ),
                    child: Column(
                      children: [
                        Text(
                          contact.hospitalName,
                          style: const TextStyle(fontSize: FontSize.s20),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          contact.location,
                          style: const TextStyle(fontSize: FontSize.s20),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          contact.contactNumber,
                          style: const TextStyle(
                            fontSize: FontSize.s24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: ColorManager.white,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Contact {
  String hospitalName;

  String location;

  String contactNumber;

  Contact(this.hospitalName, this.location, this.contactNumber);
}
