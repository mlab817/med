import 'dart:math';

import 'package:med/presentation/resources/assets_manager.dart';

class HealthCareTip {
  static final List<Tip> _items = [
    Tip(
      "Exercise Regularly",
      "Staying physically fit improves cardiovascular and muscular health and helps fight disease. Exercising also has been shown to reduce stress and improve your overall mood, so try to squeeze in at least 150 minutes of moderate-intensity aerobic exercise each week.",
      ImageAssets.exercise,
      longDescription: """
      The minimum recommended by the American Heart Association, plus at least two days of muscle-strengthening activities. “Making a daily commitment to exercise, stretch, meditate, or practice any other form of self-care may help you feel calmer and allow you to reset,” says Maria Biondi, RDN, CDN, a NYPBeHealthy well-being coach at NewYork-Presbyterian Queens.
      Here are some simple ways to break the exercises down into 30-minute increments, courtesy of the NYPBeHealthy wellness team:
      
      - Take at least two 30-minute walks a week at lunchtime or plan some walking meetings.
      - Do 30 minutes of strength training with a kettlebell or hand weights while watching TV.
      - Jump rope for 15 minutes when you get up in the morning and again when you get home at night.
      - Do squats at your desk for 10-minute increments three times per day.
      """,
    ),
    Tip(
      "Drink Water Regularly",
      """Not drinking enough water throughout the day can leave you feeling sore, tired, and unfocused. How much water should you be drinking? The answer depends on multiple factors, including your health, diet, physical activity, and general lifestyle.",

      You’ve probably heard the 8 glasses a day rule, but it’s a bit tricky because people also get hydration from other beverages and from fruits and veggies, too. In general, you can stay appropriately hydrated by drinking water throughout the day, and if you feel thirsty. If you live in a warmer climate or are more active daily, you may need to drink more water.
      """,
      ImageAssets.exercise,
    ),
    Tip(
      "Take a Multivitamin",
      "A balanced diet helps you maintain good physical and mental health. However, busy adults are prone to making unhealthy meal choices or skipping meals altogether, so they may not get enough nutrients on a given day. Taking a multivitamin is an easy way to fill nutritional gaps in your eating pattern.",
      ImageAssets.takevitamins,
      longDescription: """
      New Chapter®’s multivitamins are formulated for absorption with fermented nutrients and made with organic vegetables and herbs. Need help remembering to take your vitamins? Try setting a phone alarm or getting a vitamin case.
      """,
    ),
    Tip(
      "Get Enough Sleep",
      "Being well-rested is good for your wellness! That’s right, getting a full night’s sleep is an important part of holistic health. According to the CDC, adults aged 18-60 need a minimum of 7 hours of sleep a night. However, struggling to get to sleep is a common problem among adults.",
      ImageAssets.getenoughsleep,
      longDescription: """
      Inability to fall asleep and poor sleep quality can be due to a variety of reasons, from stress to noise to the distractions of technology. Improve your sleep naturally by establishing a nightly sleep routine. Turn off devices such as phones and computers an hour before you go to bed. Reserve that time for quiet activities such as reading, journaling, or drinking herbal tea. Before bed, try taking an optimized dose of non-groggy melatonin to combat restlessness and promote deep, sound sleep.
      """,
    ),
    Tip(
      "Eat More Fruits and Vegetables",
      "Fruits and vegetables are the cornerstones of a healthy diet because they’re packed with nutrients and provide dietary fiber. Different colors deliver different phytonutrients, so try to eat a rainbow of options.",
      ImageAssets.eatvegetables,
      longDescription: """
      To help make every bite count, add servings of fruit and colorful vegetables to more meals throughout your week. Sliced fruit and veggies make great snacks, too. If you don’t love eating fruits or vegetables on their own, try cooking them into foods you already enjoy or adding them to smoothies. Leafy greens like spinach and kale are especially easy to disguise in soups, smoothies, and pasta sauces.
      """,
    ),
    Tip(
      "Fix Your Posture",
      "Good posture can support good form when exercising, helping you to avoid injuries while active. ",
      ImageAssets.fixposture,
      longDescription: """
      But what does good posture look like? According to Harvard health experts, good posture means having your shoulders and hips even, chin parallel to the floor, and weight evenly distributed on both feet.
      """,
    ),
    Tip(
      "Get Vaccinated",
      "Vaccines are considered a safe, effective, and important way to protect your health!",
      ImageAssets.getvaccinated,
      longDescription: """
      Getting vaccinated significantly lowers your risk of getting infected by serious diseases or experiencing complications from common illnesses like the flu. It also keeps your family and friends safe by reducing your risk of spreading illnesses.
      """,
    ),
    Tip(
        "Meditate",
        "Give your being a break by meditating! Anyone can practice meditation, just about anywhere and at any time.",
        ImageAssets.meditate,
        longDescription: """
      Meditation is considered a mind-body practice, meaning it has beneficial effects on both your physical and mental well-being. That makes it a great tool in your toolkit for reducing the stress and anxiety that come along with everyday life.
      """),
    Tip(
        "Organize Your Days",
        "Give your being a break by meditating! Anyone can practice meditation, just about anywhere and at any time.",
        ImageAssets.meditate,
        longDescription: """
      Meditation is considered a mind-body practice, meaning it has beneficial effects on both your physical and mental well-being. That makes it a great tool in your toolkit for reducing the stress and anxiety that come along with everyday life.
      """),
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

  String image;

  String? longDescription;

  Tip(this.title, this.shortDescription, this.image, {this.longDescription});
}
