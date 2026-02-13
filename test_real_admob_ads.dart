import 'package:flutter/material.dart';
import 'lib/services/video_ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 AdMob Real Ads Test');
  print('====================');

  // Test with Google test ads first
  print('🧪 Testing with Google test ads...');
  VideoAdService.enableTestMode();
  await VideoAdService.initialize();
  await VideoAdService.loadRewardedAd();

  if (VideoAdService.isAdReady()) {
    print('✅ Test ads working!');
  } else {
    print('❌ Test ads failed');
  }

  // Test with production ads
  print('🎯 Testing production ads...');
  VideoAdService.disableTestMode();
  await VideoAdService.loadRewardedAd();

  if (VideoAdService.isAdReady()) {
    print('✅ Production ads working!');
  } else {
    print('❌ Production ads failed - check AdMob account');
  }
}
