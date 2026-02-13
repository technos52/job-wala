import 'package:flutter/material.dart';
import 'lib/services/video_ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 AdMob Issue Analysis');
  print('=====================');

  // Initialize AdMob
  await VideoAdService.initialize();

  print('\n🧪 Testing with Google Test Ads...');
  VideoAdService.enableTestMode();
  await VideoAdService.loadRewardedAd();

  if (VideoAdService.isAdReady()) {
    print('✅ Google test ads work fine');
  } else {
    print('❌ Even test ads are failing - SDK issue');
  }

  print('\n🎯 Testing Production Ads...');
  VideoAdService.disableTestMode();
  await VideoAdService.loadRewardedAd();

  if (VideoAdService.isAdReady()) {
    print('✅ Production ads work - account is approved!');
  } else {
    print('❌ Production ads failing - account/setup issue');
    print('\n📋 Error Analysis:');
    print('Error Code 3: "Publisher data not found"');
    print('This means:');
    print('1. AdMob account not approved yet');
    print('2. Ad unit ID doesn\'t exist in your account');
    print('3. App not properly linked to AdMob');
    print('4. Payment information missing');

    print('\n🔧 Solutions:');
    print('1. Check AdMob account status at https://apps.admob.com');
    print('2. Verify ad unit ID: ca-app-pub-2412883259923012/2293147806');
    print('3. Add payment method in AdMob console');
    print('4. Wait 24-48 hours for account approval');
    print('5. Ensure app package name matches: com.shailesh.alljobsopen');
  }
}
