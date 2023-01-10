import 'dart:math';

import 'package:med/presentation/resources/assets_manager.dart';

class HealthCareTip {
  static final List<Tip> _items = [
    Tip(
      "Exercise Regularly",
      "Staying physically fit improves cardiovascular and muscular health and helps fight disease. Exercising also has been shown to reduce stress and improve your overall mood, so try to squeeze in at least 150 minutes of moderate-intensity aerobic exercise each week.",
      """
      The minimum recommended by the American Heart Association, plus at least two days of muscle-strengthening activities. “Making a daily commitment to exercise, stretch, meditate, or practice any other form of self-care may help you feel calmer and allow you to reset,” says Maria Biondi, RDN, CDN, a NYPBeHealthy well-being coach at NewYork-Presbyterian Queens.
      Here are some simple ways to break the exercises down into 30-minute increments, courtesy of the NYPBeHealthy wellness team:
      
      - Take at least two 30-minute walks a week at lunchtime or plan some walking meetings.
      - Do 30 minutes of strength training with a kettlebell or hand weights while watching TV.
      - Jump rope for 15 minutes when you get up in the morning and again when you get home at night.
      - Do squats at your desk for 10-minute increments three times per day.
      """,
      ImageAssets.exercise,
    ),
  ];

  List<Tip> get items => _items;

  static Tip getRandomTip() {
    var random = Random();
    var index = random.nextInt(_items.length);

    return _items[index];
  }
}

class Tip {
  String title;

  String shortDescription;

  String longDescription;

  String image;

  Tip(this.title, this.shortDescription, this.longDescription, this.image);
}
