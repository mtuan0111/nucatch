import 'dart:io';
import 'dart:convert';

void main() {
  final dir = Directory('/Volumes/DATA/BOM_DATA/flutter_projects/nucatch-with-bloc/lib/localization');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  for (final file in files) {
    try {
      final content = file.readAsStringSync();
      // Try parsing as JSON first, if it fails then we have to fix it manually
      Map<String, dynamic> jsonMap;
      try {
        jsonMap = json.decode(content);
      } catch (e) {
        print('Fixing ${file.path} syntax...');
        // naive fix if it's missing closing brace
        jsonMap = json.decode(content + '}');
        print('Fixed ${file.path}');
      }
      
      if (!jsonMap.containsKey('menuGreeting')) {
        if (file.path.endsWith('app_vi.arb')) {
          jsonMap['menuGreeting'] = 'Thử thách trí nhớ và kỹ năng tính toán của bạn ngay lúc này!';
        } else {
          jsonMap['menuGreeting'] = 'Test your memory and math skills today!';
        }
        jsonMap['@menuGreeting'] = {
          'description': 'Greeting message on the main menu'
        };
        
        // Write it back formatted
        final encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(jsonMap));
        print('Updated ${file.path}');
      }
    } catch (e) {
      print('Failed to update ${file.path}: $e');
    }
  }
}
