import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/data/models/history_model.dart';
import 'package:med/presentation/resources/assets_manager.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/styles_manager.dart';

import '../../resources/size_manager.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'History',
            style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: FontSize.s24,
            ),
          ),
          const SizedBox(height: AppSize.s20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: historyBox.listenable(),
              builder: (context, box, widget) {
                if (box.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          JsonAssets.emptyJson,
                          height: AppSize.s200,
                        ),
                        const SizedBox(height: AppSize.s20),
                        Padding(
                          padding: const EdgeInsets.all(AppPadding.p12),
                          child: Text(
                            'You have not taken any medicine yet.',
                            textAlign: TextAlign.center,
                            style: getBoldStyle(
                              color: ColorManager.red,
                              fontSize: FontSize.s20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                    itemCount: box.length,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      final HistoryModel history = historyBox.getAt(index);
                      DateTime takenAt = DateTime.parse(history.takenAt);

                      return SizedBox(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(history.medicineName),
                              Text(
                                DateFormat('E, d MMM yyyy')
                                    .add_jms()
                                    .format(takenAt),
                                style: getLightStyle(
                                  color: ColorManager.darkgray,
                                ),
                              ),
                              const SizedBox(height: AppSize.s10),
                              _getStatus(history.medicineAction),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          const SizedBox(
            height: AppSize.s64,
          ),
        ],
      ),
    );
  }

  Widget _getStatus(String medicineAction) {
    debugPrint(medicineAction);
    switch (medicineAction) {
      case MedicineAction.skipped:
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p4,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s4),
              color: ColorManager.red,
            ),
            child: Text(medicineAction.toUpperCase(), style: getBoldStyle(color: ColorManager.white)));
        return Container(
          padding: const EdgeInsets.all(AppPadding.p8),
          decoration: BoxDecoration(
            color: ColorManager.red,
            borderRadius: BorderRadius.circular(AppSize.s4),
          ),
          child: Text(MedicineAction.skipped.toString().toUpperCase()),
        );
      case MedicineAction.taken:
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p4,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s50),
              color: ColorManager.green,
            ),
            child: Text(medicineAction.toUpperCase(), style: getBoldStyle(color: ColorManager.white,)));
      default:
        return Container();
    }
  }
}
