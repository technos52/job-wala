import 'package:http/http.dart' as http;

class GoogleSearchService {
  static Future<bool> verifyCompanyExists(String companyName) async {
    try {
      final query = Uri.encodeComponent(companyName);
      final url = 'https://www.google.com/search?q=$query';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body.toLowerCase();
        final companyLower = companyName.toLowerCase();
        
        return body.contains(companyLower) || 
               body.contains('company') || 
               body.contains('corporation') ||
               body.contains('inc') ||
               body.contains('ltd');
      }
      return false;
    } catch (e) {
      return true;
    }
  }
}

