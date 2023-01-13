import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:med/domain/notification_service.dart';
import 'package:med/presentation/resources/assets_manager.dart';
import 'package:med/presentation/resources/strings_manager.dart';
import 'package:med/presentation/resources/styles_manager.dart';

import '../../../app/di.dart';
import '../../../app/init_hive.dart';
import '../../../data/models/reminder_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/size_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationService =
      instance<NotificationService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.myMedicines,
            style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: FontSize.s24,
            ),
          ),
          const SizedBox(height: AppSize.s20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: remindersBox.listenable(),
              builder: (context, box, widget) {
                if (box.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          JsonAssets.emptyJson,
                          height: AppSize.s200,
                        ),
                        const SizedBox(height: AppSize.s24),
                        Text(
                          AppStrings.noMedicine,
                          style: getBoldStyle(
                            color: ColorManager.red,
                            fontSize: FontSize.s20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (BuildContext context, int index) {
                    final reminder = box.getAt(index) as Reminder;
                    // startAt
                    DateTime startDate = DateTime.parse(reminder.startAt);
                    int diff = DateTime.now().difference(startDate).inDays;
                    int remainingDays = reminder.numberOfDays - diff;

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppPadding.p12),
                      height: AppSize.s200,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.darkgray),
                        borderRadius: BorderRadius.circular(AppSize.s12),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.name,
                              style: getBoldStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s20,
                              ),
                            ),
                            Text(
                              "For ${reminder.ailmentName}",
                            ),
                            Text(
                                "${reminder.frequency}x a day for ${reminder.numberOfDays.toString()} days"),
                            Text(
                                'Remaining stock: ${reminder.remainingStock.toString()} pieces'),
                            Text(
                                "Remaining days: ${remainingDays.toString()} days"),
                            const SizedBox(height: AppSize.s20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: reminder.notifications != null
                                    ? reminder.notifications!
                                        .map(
                                          (notificationSchedule) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: AppPadding.p8),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: AppPadding.p12,
                                                vertical: AppPadding.p4,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: ColorManager.primary,
                                              ),
                                              child: Text(
                                                DateFormat.jm().format(
                                                  DateTime.parse(
                                                    notificationSchedule
                                                        .dateTime,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  color: ColorManager.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .cast<Widget>()
                                        .toList()
                                    : [],
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          height: AppSize.s48,
                          width: AppSize.s100,
                          child: IconButton(
                            onPressed: () async {
                              if (await confirm(
                                context,
                                title: const Text(AppStrings.confirmDelete),
                                content:
                                    const Text(AppStrings.confirmDeleteContent),
                              )) {
                                return reminder.delete();
                              }
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.delete,
                              size: AppSize.s24,
                              color: ColorManager.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // add sizedBox below to account for bottomSheet
          const SizedBox(
            height: AppSize.s64,
          ),
        ],
      ),
    );
  }
}
