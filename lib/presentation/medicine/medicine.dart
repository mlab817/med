import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:med/app/init_hive.dart';
import 'package:med/data/models/reminder.dart';
import 'package:med/presentation/app.dart';
import 'package:med/presentation/resources/assets_manager.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';
import 'package:med/presentation/resources/strings_manager.dart';

import '../../app/constants.dart';
import '../resources/routes_manager.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({Key? key}) : super(key: key);

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final PageController _pageController = PageController();

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicineFormController = TextEditingController();
  final TextEditingController _medicineAmountController =
      TextEditingController();
  final TextEditingController _medicineIllnessController =
      TextEditingController();
  final TextEditingController _medicineEverydayController =
      TextEditingController();
  final TextEditingController _medicineTimeController = TextEditingController();

  String _selectedMedicineForm = "Drops";
  String _selectedMedicineEveryday = "Yes";

  TimeOfDay selectedTime = TimeOfDay.now();

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _medicineNameController.dispose();
    _medicineFormController.dispose();
    _medicineAmountController.dispose();
    _medicineIllnessController.dispose();
    _medicineEverydayController.dispose();
    _medicineTimeController.dispose();

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
          size: AppSize.s18,
        ),
      ),
      body: _getPageBuilder(),
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
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
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
            onPressed: () => Navigator.pushNamed(context, Routes.homeRoute),
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
          // _getStepSix(),
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
          const Text('Medicine Name:', style: TextStyle(fontSize: FontSize.s20,)),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _medicineNameController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter here',
              ),
              style: const TextStyle(fontSize: FontSize.s24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepTwo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_medicineNameController.text, style: const TextStyle(fontSize: FontSize.s24,)),
          Image.asset(
            ImageAssets.step2,
            height: AppSize.s150,
          ),
          const SizedBox(
            height: AppSize.s50,
          ),
          const Text(StringManager.enterTheAmountOfMedicine, style: TextStyle(fontSize: FontSize.s20,)),
          const SizedBox(height: AppSize.s20),
          SizedBox(
            width: AppSize.s200,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _medicineAmountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Enter here',
                    ),
                    style: const TextStyle(fontSize: FontSize.s24),
                  ),
                ),
                const Text('piece/s')
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepThree() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_medicineNameController.text, style: const TextStyle(fontSize: FontSize.s20,)),
          Image.asset(
            ImageAssets.step2,
            height: 150.0,
          ),
          const SizedBox(
            height: 50.0,
          ),
          const Text('Enter the total storage of your medicine:', style: TextStyle(fontSize: FontSize.s20), textAlign: TextAlign.center,),
          SizedBox(
            width: AppSize.s200,
            child: TextField(
              controller: _medicineAmountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter here',
              ),
              style: const TextStyle(fontSize: FontSize.s24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepFour() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_medicineNameController.text, style: const TextStyle(fontSize: FontSize.s24)),
          Image.asset(
            ImageAssets.step3,
            height: AppSize.s150,
          ),
          const Text(StringManager.ailmentName, style: TextStyle(fontSize: FontSize.s20)),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              controller: _medicineIllnessController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'Enter here'),
              style: const TextStyle(fontSize: FontSize.s24),
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
          Text(_medicineNameController.text, style: const TextStyle(fontSize: FontSize.s24),),
          Image.asset(
            ImageAssets.step4,
            height: 150.0,
          ),
          const SizedBox(
            height: AppSize.s50,
          ),
          const Text('Select Time', style: TextStyle(fontSize: FontSize.s24)),
          GestureDetector(
            child: Text(
              selectedTime.format(context),
              style: const TextStyle(fontSize: FontSize.s36),
            ),
            onTap: () => _selectTime(context),
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
            child: const Text('Save'),)
        ],
      ),
    );
  }

  // Widget _getStepSix() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Text(
  //         'Confirm details',
  //         style: Theme.of(context).textTheme.headline6,
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       const Text('Medicine Name'),
  //       Text(
  //         _medicineNameController.text,
  //         style: const TextStyle(
  //           fontSize: AppSize.s18,
  //         ),
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       const Text('Medicine Form'),
  //       Text(
  //         _selectedMedicineForm,
  //         style: const TextStyle(
  //           fontSize: AppSize.s18,
  //         ),
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       const Text('Medicine Amount'),
  //       Text(
  //         "${_medicineAmountController.text}mg",
  //         style: const TextStyle(
  //           fontSize: AppSize.s18,
  //         ),
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       const Text('Illness'),
  //       const SizedBox(height: AppSize.s20),
  //       Text(
  //         _medicineIllnessController.text,
  //         style: const TextStyle(
  //           fontSize: AppSize.s18,
  //         ),
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       const Text('Take every day'),
  //       Text(
  //         _selectedMedicineEveryday,
  //         style: const TextStyle(
  //           fontSize: AppSize.s18,
  //         ),
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       const Text('Take at time'),
  //       Text(
  //         selectedTime.format(context),
  //         style: const TextStyle(
  //           fontSize: AppSize.s18,
  //         ),
  //       ),
  //       const SizedBox(height: AppSize.s20),
  //       SizedBox(
  //         height: AppSize.s50,
  //         width: AppSize.s120,
  //         child: ElevatedButton(
  //           onPressed: _addReminder,
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: ColorManager.lightred,
  //           ),
  //           child: const Text('Save'),
  //         ),
  //       ),
  //       const SizedBox(
  //         height: AppSize.s50,
  //       ),
  //     ],
  //   );
  // }

  Future<void> _selectTime(context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _addReminder() {
    //
    remindersBox.add(Reminder(
      _medicineNameController.text,
      _medicineFormController.text,
      _medicineAmountController.text.isNotEmpty
          ? int.parse(_medicineAmountController.text)
          : 0,
      _medicineIllnessController.text,
      _selectedMedicineEveryday == 'Yes' ? true : false,
      selectedTime.toString(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully added reminder!'),
      ),
    );

    Navigator.pushNamed(context, Routes.homeRoute);
  }
}
