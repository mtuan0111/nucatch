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
Consider any current special events today in your message to make it feel relevant and motivating, chilling.
Do not use quotes around the message. 
Keep it under 1 sentences, within 30 words. Say it casually, don't be too formal.
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
}
