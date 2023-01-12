import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:med/app/constants.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/data/models/reminder_model.dart';
import 'package:med/presentation/resources/assets_manager.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';
import 'package:med/presentation/resources/strings_manager.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/notification_model.dart';
import '../resources/routes_manager.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({Key? key}) : super(key: key);

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final PageController _pageController = PageController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicineIllnessController =
      TextEditingController();
  final TextEditingController _medicineDurationController =
      TextEditingController();
  final TextEditingController _medicineStockController =
      TextEditingController();
  int? _selectedFrequency;

  final List<DateTime?> _startTimes = [];

  final List<int> _medicineTakePerDayOptions = [1, 2, 3, 4, 6, 8, 12];

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _medicineNameController.dispose();
    _medicineIllnessController.dispose();
    _medicineDurationController.dispose();
    _medicineStockController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Medicine',
          style: TextStyle(
            color: ColorManager.blue,
          ),
        ),
        leading: BackButton(
          onPressed: _onBackButtonPressed,
        ),
        elevation: 0.0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(
          color: ColorManager.blue,
          // size: AppSize.s18,
        ),
      ),
      body: Form(
        key: _formKey,
        child: _getPageBuilder(),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  }
                : null,
          ),
          // Text("Step ${((_pageController.page?.toInt() ?? 0)+1).toString()}"),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < 6
                ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackButtonPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
            'Exiting will delete the information you entered. Continue?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Don't exit"),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, Routes.mainRoute),
            child: const Text("It's fine"),
          ),
        ],
      ),
    );
  }

  Widget _getPageBuilder() {
    return Container(
      color: ColorManager.white,
      child: PageView(
        scrollDirection: Axis.horizontal,
        allowImplicitScrolling: false,
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _getStepOne(),
          _getStepTwo(),
          _getStepThree(),
          _getStepFour(),
          _getStepFive(),
          _getStepSix(),
        ],
      ),
    );
  }

  Widget _getStepOne() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.step1,
            height: AppSize.s150,
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'Medicine [Information]:',
            style: TextStyle(
              fontSize: FontSize.s20,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              controller: _medicineNameController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter here',
              ),
              style: const TextStyle(fontSize: FontSize.s24),
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the details of the medicine you plan to take.';
                }
                return null;
              }),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
            child: Text(
              "Enter the information of the medicine including brand, dosage and form, e.g. Biogesic 500mg tablet",
            ),
          )
        ],
      ),
    );
  }

  Widget _getStepTwo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.step2,
            height: AppSize.s150,
          ),
          const SizedBox(
            height: AppSize.s24,
          ),
          Padding(
            padding: const EdgeInsets.all(AppPadding.p12),
            child: Text(
              "How OFTEN do you need to take ${_medicineNameController.text} in a day?",
              style: const TextStyle(
                fontSize: FontSize.s20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSize.s20),
          const Text('Select an option'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 1, // width/height
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return FormField<int>(
                    builder: (FormFieldState<int> state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: _selectedFrequency ==
                                  _medicineTakePerDayOptions[index]
                              ? 0
                              : 2,
                          backgroundColor: _selectedFrequency ==
                                  _medicineTakePerDayOptions[index]
                              ? ColorManager.primary
                              : ColorManager.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedFrequency =
                                _medicineTakePerDayOptions[index];
                            state.didChange(_selectedFrequency);

                            // updated _startTimes too
                            _startTimes.clear();
                            for (int i = 0; i < _selectedFrequency!; i++) {
                              _startTimes.add(null);
                            }
                          });
                        },
                        child: Text(
                          "${_medicineTakePerDayOptions[index].toString()}x a day",
                          style: TextStyle(
                            fontSize: FontSize.s20,
                            color: _selectedFrequency ==
                                    _medicineTakePerDayOptions[index]
                                ? ColorManager.white
                                : ColorManager.primary,
                          ),
                        ),
                      );
                    },
                    validator: (value) {
                      if (_selectedFrequency == null) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  );
                },
                itemCount: _medicineTakePerDayOptions.length,
              ),
            ),
          ),
          SizedBox(
            child: _selectedFrequency == null
                ? const Text('Select an option')
                : const Text('Select an option'),
          ),
          const SizedBox(height: AppSize.s20),
        ],
      ),
    );
  }

  // add times for number of times
  Widget _getStepThree() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _medicineNameController.text,
            style: const TextStyle(
              fontSize: FontSize.s20,
            ),
          ),
          const SizedBox(
            height: AppSize.s20,
          ),
          Icon(
            Icons.alarm,
            size: AppSize.s128,
            color: ColorManager.primary,
          ),
          const SizedBox(
            height: AppSize.s20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'At what time will you take them?',
              style: TextStyle(fontSize: FontSize.s20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: AppSize.s20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Select $_selectedFrequency time/s',
              style: const TextStyle(fontSize: FontSize.s20),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedFrequency,
              itemBuilder: (context, index) {
                var thisTime = _startTimes[index];

                String formattedTime = thisTime != null
                    ? DateFormat.jm().format(thisTime)
                    : "Select time";

                return GestureDetector(
                  onTap: () => _selectTime(context, index),
                  child: FormField<DateTime>(
                    builder: (FormFieldState<DateTime> state) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorManager.darkgray),
                        ),
                        child: ListTile(
                          title: Text(
                            formattedTime,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    validator: (value) {
                      debugPrint("_selectedFrequency $_selectedFrequency");
                      debugPrint("_startTimesLength ${_startTimes.length}");
                      if (_selectedFrequency != _startTimes.length) {
                        return "Please complete the schedule for all the times.";
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // name of ailment
  Widget _getStepFour() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_medicineNameController.text,
              style: const TextStyle(fontSize: FontSize.s24)),
          Image.asset(
            ImageAssets.step3,
            height: AppSize.s150,
          ),
          const Padding(
            padding: EdgeInsets.all(AppPadding.p12),
            child: Text(
              StringManager.ailmentName,
              style: TextStyle(
                fontSize: FontSize.s20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextFormField(
              controller: _medicineIllnessController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'Enter here'),
              style: const TextStyle(fontSize: FontSize.s24),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the name of your ailment.";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepFive() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _medicineNameController.text,
            style: const TextStyle(fontSize: FontSize.s24),
          ),
          Image.asset(
            ImageAssets.step4,
            height: 150.0,
          ),
          const SizedBox(
            height: AppSize.s50,
          ),
          const Text(
            'For how long do you need to take this medicine?',
            style: TextStyle(fontSize: FontSize.s24),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppSize.s200,
                  child: TextFormField(
                    controller: _medicineDurationController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'No. of days',
                    ),
                    style: const TextStyle(fontSize: FontSize.s24),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of days you need to take the medicine.';
                      }
                      return null;
                    }),
                  ),
                ),
                const Text('days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepSix() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _medicineNameController.text,
              style: const TextStyle(fontSize: FontSize.s24),
            ),
            Image.asset(
              ImageAssets.takenotes,
              height: 150.0,
            ),
            const SizedBox(
              height: AppSize.s50,
            ),
            const Text(
              'How many pieces of the medicine do you have at the moment?',
              style: TextStyle(fontSize: FontSize.s24),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: AppSize.s200,
                    child: TextFormField(
                      controller: _medicineStockController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: FontSize.s24),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of medicines.';
                        }
                        return null;
                      }),
                    ),
                  ),
                  const Text('pieces'),
                ],
              ),
            ),
            const SizedBox(
              height: AppSize.s50,
            ),
            ElevatedButton(
              onPressed: _addReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.red,
                fixedSize: const Size(AppSize.s150, AppSize.s50),
              ),
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(context, index) async {
    var currentTime = DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: AppSize.s200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: currentTime
                  .add(Duration(minutes: 30 - currentTime.minute % 30)),
              minuteInterval: 10,
              onDateTimeChanged: (DateTime newDateTime) {
                // Handle the new time selection
                debugPrint("newDateTime ${newDateTime.toString()}");
                setState(() {
                  _startTimes[index] = newDateTime;
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _addReminder() {
    String uuid = const Uuid().toString();

    Reminder newReminder = Reminder(
      uuid,
      _medicineNameController.text,
      _selectedFrequency!,
      _startTimes[0]!.toIso8601String(),
      // first start time, this can introduce a bug if the dose has already passed for the day
      _medicineIllnessController.text,
      int.parse(_medicineDurationController.text).toInt(),
      int.parse(_medicineStockController.text).toInt(), // remaining stock
    );
    //
    remindersBox.add(newReminder);

    newReminder.notifications = HiveList(notificationsBox);

    // save the notification first
    // then schedule them one by one
    for (DateTime? dt in _startTimes) {
      if (dt != null) {
        var notifId = _generateNotificationId();

        NotificationModel newNotif =
            NotificationModel(notifId, dt.toIso8601String());

        notificationsBox.add(newNotif);

        newReminder.notifications?.add(newNotif);

        _createNotifications(uuid, notifId, dt);
      }
    }
    newReminder.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully added reminder!'),
      ),
    );

    Navigator.pushReplacementNamed(context, Routes.mainRoute);
  }

  void _createNotifications(String uuid, int notifId, DateTime startAt) async {
    // create notifications
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'medicineReminder',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('mix'),
      playSound: true,
      actions: [
        AndroidNotificationAction(
          NotificationActionsId.snooze,
          "Snooze",
          titleColor: Colors.redAccent,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          NotificationActionsId.markAsDone,
          "Mark as Done",
          titleColor: Colors.lightGreen,
          showsUserInterface: true,
        ),
      ],
    );

    // more types of notifications can be added here like for ios
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var location = getLocation(TzLocation.asiaManila);

    // iterate and add 1 day
    for (int i = 0;
        i < int.parse(_medicineDurationController.text).toInt();
        i++) {
      // just add i to make sure notifs are unique
      // need to store this to db
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notifId + i,
        'Time for your medicine!',
        'Take ${_medicineNameController.text} now',
        TZDateTime.from(
            startAt.add(
              Duration(days: i),
            ),
            location),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: uuid, // uuid of reminder so it can be retrieved
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }
  }

  int _generateNotificationId() {
    var uuid = const Uuid();
    return uuid.hashCode;
  }
}
