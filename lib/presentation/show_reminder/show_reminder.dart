import 'package:flutter/material.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/data/models/reminder_model.dart';

class ShowReminderPage extends StatefulWidget {
  const ShowReminderPage({Key? key, required this.uuid}) : super(key: key);

  final String uuid;

  @override
  State<ShowReminderPage> createState() => _ShowReminderPageState();
}

class _ShowReminderPageState extends State<ShowReminderPage> {
  Future<Reminder> _getReminder() async {
    return await remindersBox.get("uuid", defaultValue: widget.uuid);
  }

  @override
  void initState() {
    _getReminder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getReminder(),
        builder: (context, snapshot) => {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(child: Text('Done'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
