import 'lib/services/dropdown_service.dart';

void main() {
  print('🧪 Testing DropdownService method availability...');

  // Test that getDefaultOptions method exists and is accessible
  try {
    final testOptions = DropdownService.getDefaultOptions('qualifications');
    print(
      '✅ getDefaultOptions method exists and returns: ${testOptions.length} items',
    );
    print('   Sample options: ${testOptions.take(3).toList()}');
  } catch (e) {
    print('❌ Error calling getDefaultOptions: $e');
  }

  print('🎉 DropdownService method test completed!');
}
