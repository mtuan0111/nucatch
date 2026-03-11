import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiGreetingService {
  static Future<String> getGreeting(
      BuildContext context, String fallbackText) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty || apiKey == 'abc_xyz') {
        return fallbackText;
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final locale = Localizations.localeOf(context).languageCode;

      final prompt = '''
Generate a short, motivational greeting message for a player of a memory and math game called NuCatch. 
Consider any upcoming or current special events happening in the country of "$locale" to make the message feel relevant, motivating, and chill.
Do not use quotes around the message. 
Keep it under 1 sentence and within 30 words. Say it casually—don't be too formal.
The language code to write the message in is: "$locale".
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      final result = response.text?.trim();

      if (result != null && result.isNotEmpty) {
        return result;
      }

      return fallbackText;
    } catch (e) {
      debugPrint('Error generating AI greeting: \$e');
      return fallbackText;
    }
  }

  static Future<String> getReminderMessage(
      BuildContext context, String fallbackText) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty || apiKey == 'abc_xyz') {
        return fallbackText;
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final locale = Localizations.localeOf(context).languageCode;

      final prompt = '''
Generate a short, motivational reminder message for a player to open and play the memory and math game NuCatch. 
Consider any upcoming or current special events happening in the country of "$locale" to make the message feel relevant, motivating, and chill.
Keep it under 1 sentence and within 20 words. Say it casually—don't be too formal.
The language code to write the message in is: "$locale".
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      final result = response.text?.trim();

      if (result != null && result.isNotEmpty) {
        return result;
      }

      return fallbackText;
    } catch (e) {
      debugPrint('Error generating AI reminder: \$e');
      return fallbackText;
    }
  }

  static Future<String> getReminderTitle(String message) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty || apiKey == 'abc_xyz') {
        return "NuCatch Daily Reminder";
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      final prompt = '''
Summarize the following message into a short title. 
Keep it strictly under 5 words. Do not use quotes around the title.
Message: "$message"
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      final result = response.text?.trim();

      if (result != null && result.isNotEmpty) {
        return result;
      }

      return "NuCatch Daily Reminder";
    } catch (e) {
      debugPrint('Error generating AI title: \$e');
      return "NuCatch Daily Reminder";
    }
  }
}
