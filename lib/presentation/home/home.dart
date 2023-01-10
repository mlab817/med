import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

import '../../data/models/reminder.dart';
import '../resources/routes_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Reminder> _items = [
    Reminder(
      "Paracetamol",
      "Tablet",
      500,
      "Fever",
      false,
      (const TimeOfDay(hour: 8, minute: 0)).toString(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    String formattedDate = DateFormat("MMM dd, yyyy").format(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Hello there!', style: Theme.of(context).textTheme.subtitle2),
            Text(
              "Today is $formattedDate",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p12),
        child: ValueListenableBuilder(
          valueListenable: remindersBox.listenable(),
          builder: (context, box, widget) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (BuildContext context, int index) {
                final reminder = box.getAt(index) as Reminder;

                // Extract the hours and minutes from the string
                int hours = int.parse(reminder.takeTime.substring(10, 12));
                int minutes = int.parse(reminder.takeTime.substring(13, 15));

                return Container(
                  margin: const EdgeInsets.only(bottom: AppPadding.p12),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.darkgray),
                    borderRadius: BorderRadius.circular(AppSize.s12),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TimeOfDay(hour: hours, minute: minutes)
                              .format(context),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text("${reminder.name} (${reminder.form})"),
                        Text("Illness: ${reminder.illness}"),
                      ],
                    ),
                    trailing: const Text('1/12'),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(AppPadding.p12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: AppSize.s50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.medicineRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.lightred,
                ),
                child: const Text('Add Medicine'),
              ),
            ),
            SizedBox(
              height: AppSize.s50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.tipRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.white,
                ),
                child: Text(
                  'Tips for today',
                  style: TextStyle(
                    color: ColorManager.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorManager.blue,
        unselectedItemColor: ColorManager.gray,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: "Hotlines",
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, Routes.medicineRoute);
              break;
            case 2:
              Navigator.pushNamed(context, Routes.hotlinesRoute);
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
