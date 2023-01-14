import 'package:flutter/material.dart';
import 'package:med/data/models/reminder_model.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';
import 'package:med/presentation/resources/strings_manager.dart';

class EditReminderPage extends StatefulWidget {
  const EditReminderPage({Key? key, required this.reminder}) : super(key: key);

  final Reminder reminder;

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicineAilmentController =
      TextEditingController();
  final TextEditingController _medicineFrequencyController =
      TextEditingController();
  final TextEditingController _medicineRemainingStockController =
      TextEditingController();
  final TextEditingController _medicineNumberOfDaysController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _medicineNameController.text = widget.reminder.name;
    _medicineAilmentController.text = widget.reminder.ailmentName;
    _medicineFrequencyController.text = widget.reminder.frequency.toString();
    _medicineRemainingStockController.text =
        widget.reminder.remainingStock.toString();
    _medicineNumberOfDaysController.text =
        widget.reminder.numberOfDays.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _medicineNameController.dispose();
    _medicineAilmentController.dispose();
    _medicineFrequencyController.dispose();
    _medicineRemainingStockController.dispose();
    _medicineNumberOfDaysController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: AppSize.s0,
        title: const Text(AppStrings.editMedicine),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Information',
                  helperText: AppStrings.enterDetailsHint,
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            ListTile(
              title: TextField(
                controller: _medicineAilmentController,
                decoration: const InputDecoration(
                  labelText: 'Name of Ailment',
                  helperText: AppStrings.whatAreYouTakingTheMedicineFor,
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            ListTile(
              title: TextField(
                controller: _medicineFrequencyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of times per day',
                  helperText:
                      'How many times you need to take the medicine per day?',
                  suffixText: AppStrings.timesPerDay,
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            ListTile(
              title: TextField(
                controller: _medicineNumberOfDaysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'No. of days to take the medicine',
                  suffixText: AppStrings.days,
                  helperText:
                      'Enter the remaining number of days you need to take the medicine',
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            ListTile(
              title: TextField(
                controller: _medicineRemainingStockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Remaining Stock of the Medicine',
                  suffixText: AppStrings.pieces,
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.p12),
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                  minimumSize: const Size(double.infinity, AppSize.s50),
                ),
                child: const Text('Save Changes'),
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveChanges() {
    final reminder = widget.reminder;
    reminder.name = _medicineNameController.text;
    reminder.ailmentName = _medicineAilmentController.text;
    reminder.frequency = int.parse(_medicineFrequencyController.text);
    reminder.numberOfDays = int.parse(_medicineNumberOfDaysController.text);
    reminder.remainingStock = int.parse(_medicineRemainingStockController.text);
    reminder.save();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully updated reminder.')));
    //
    _exitToHome();
  }

  _exitToHome() {
    Navigator.pushNamed(context, Routes.mainRoute);
  }
}
