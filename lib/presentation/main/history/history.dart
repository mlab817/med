import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

                return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final HistoryModel history = historyBox.getAt(index);

                      return ListTile(
                        title: Text(history.medicineName),
                        trailing: Text(history.takenAt),
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
}
