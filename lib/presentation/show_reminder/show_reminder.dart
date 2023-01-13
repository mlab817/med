import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/data/models/reminder_model.dart';
import 'package:med/presentation/resources/assets_manager.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

import '../../data/models/history_model.dart';
import '../resources/styles_manager.dart';

class ShowReminderPage extends StatefulWidget {
  const ShowReminderPage({Key? key, required this.uuid}) : super(key: key);

  final String uuid;

  @override
  State<ShowReminderPage> createState() => _ShowReminderPageState();
}

class _ShowReminderPageState extends State<ShowReminderPage> {
  late Reminder? _reminder;

  _getReminder() {
    List matches = remindersBox.values
        .where((element) => element.uuid == widget.uuid)
        .toList();

    debugPrint(matches.length.toString());

    if (matches.isNotEmpty) {
      _reminder = matches.first;
    } else {
      _reminder = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: (_reminder != null) ? _getBody() : _getEmpty(),
      // resizeToAvoidBottomInset: false,
    );
  }

  Widget _getBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: AppSize.s128),
              Text(
                _reminder?.name ?? "No Medicine Name",
                style: getSemiBoldStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s24,
                ),
              ),
              Text(
                "For ${_reminder?.ailmentName ?? "Unknown ailment"}",
                style: getRegularStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s20,
                ),
              ),
            ],
          ),
          Text(
            'Remaining Stock: ${_reminder?.remainingStock.toString() ?? "0"}',
            style: getBoldStyle(
              color: ColorManager.red,
              fontSize: FontSize.s16,
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorManager.red,
                        radius: AppSize.s36,
                        child: IconButton(
                          onPressed: _skipMedicine,
                          icon: Icon(Icons.close, color: ColorManager.white),
                        ),
                      ),
                      const SizedBox(height: AppSize.s10),
                      const Text('Skip'),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorManager.green,
                        radius: AppSize.s36,
                        child: IconButton(
                          onPressed: _doneMedicine,
                          icon: Icon(
                            Icons.check,
                            color: ColorManager.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSize.s10),
                      const Text('Done'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s128),
            ],
          )
        ],
      ),
    );
  }

  Widget _getEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            JsonAssets.emptyJson,
            height: AppSize.s200,
          ),
          const SizedBox(height: AppSize.s50),
          Text(
            'Failed to find that reminder. It may have been deleted.',
            textAlign: TextAlign.center,
            style: getBoldStyle(
              color: ColorManager.red,
              fontSize: FontSize.s24,
            ),
          ),
          const SizedBox(height: AppSize.s150),
          SizedBox(
            height: AppSize.s50,
            width: AppSize.s128,
            child: ElevatedButton(
              onPressed: _record,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
              ),
              child: const Text(
                'Go Home',
                style: TextStyle(
                  fontSize: FontSize.s16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _doneMedicine() {
    var newValue = (_reminder?.remainingStock ?? 0) - 1;
    // handle done
    _reminder?.remainingStock = newValue < 0 ? 0 : newValue;
    _reminder?.save();

    // record also the history
    _record();

    // if the user has no more stock of the medicine, alert them
    if (newValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'You are low on stock of ${_reminder?.name ?? "Unknown medicine"}!')));
    }

    _exit();
  }

  void _skipMedicine() async {
    if (await confirm(context,
        title: const Text('Confirm Skip'),
        content: const Text('Are you sure you want to skip this dose?'))) {
      HistoryModel history = HistoryModel(
        _reminder?.name ?? "Unknown Medicine Name",
        DateTime.now().toString(),
        MedicineAction.skipped.toString(),
      );
      //
      historyBox.add(history);

      _exit();
    }
  }

  void _exit() {
    Navigator.pushReplacementNamed(context, Routes.mainRoute);
  }

  void _record() {
    HistoryModel history = HistoryModel(
      _reminder?.name ?? "Unknown Medicine Name",
      DateTime.now().toString(),
      MedicineAction.taken.toString(),
    );
    //
    historyBox.add(history);
  }
}
