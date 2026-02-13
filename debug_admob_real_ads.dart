import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class AdMobDiagnosticScreen extends StatefulWidget {
  const AdMobDiagnosticScreen({super.key});

  @override
  State<AdMobDiagnosticScreen> createState() => _AdMobDiagnosticScreenState();
}

class _AdMobDiagnosticScreenState extends State<AdMobDiagnosticScreen> {
  final List<String> _logs = [];
  RewardedAd? _testAd;
  bool _isLoading = false;

  // Your current ad unit ID
  static const String _productionAdUnitId =
      'ca-app-pub-2412883259923012/2293147806';

  // Test ad unit IDs (these should show real test ads, not your fallback)
  static const String _testAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Google test rewarded ad

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    debugPrint(message);
  }

  Future<void> _runDiagnostics() async {
    _addLog('🔍 Starting AdMob diagnostics...');

    // Check AdMob initialization
    _addLog('📱 Initializing AdMob...');
    try {
      await MobileAds.instance.initialize();
      _addLog('✅ AdMob initialized successfully');
    } catch (e) {
      _addLog('❌ AdMob initialization failed: $e');
      return;
    }

    // Get AdMob version
    try {
      final version = await MobileAds.instance.getVersionString();
      _addLog('📋 AdMob SDK version: $version');
    } catch (e) {
      _addLog('⚠️ Could not get AdMob version: $e');
    }

    // Test with Google's test ad unit first
    _addLog('🧪 Testing with Google test ad unit...');
    await _testAdUnit(_testAdUnitId, 'Google Test Ad');

    // Test with your production ad unit
    _addLog('🎯 Testing with your production ad unit...');
    await _testAdUnit(_productionAdUnitId, 'Production Ad');
  }

  Future<void> _testAdUnit(String adUnitId, String adType) async {
    final completer = Completer<void>();

    _addLog('📡 Loading $adType ($adUnitId)...');

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _addLog('✅ $adType loaded successfully');
          _addLog(
            '📊 Ad response info: ${ad.responseInfo?.toString() ?? 'No response info'}',
          );

          // Check if it's a real ad or test ad
          final responseInfo = ad.responseInfo;
          if (responseInfo != null) {
            _addLog(
              '🏷️ Ad network: ${responseInfo.loadedAdapterResponseInfo?.adapterClassName ?? 'Unknown'}',
            );
            _addLog(
              '💰 Revenue precision: ${responseInfo.loadedAdapterResponseInfo?.latencyMillis ?? 'Unknown'}',
            );
          }

          ad.dispose();
          completer.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _addLog('❌ $adType failed to load:');
          _addLog('   Code: ${error.code}');
          _addLog('   Domain: ${error.domain}');
          _addLog('   Message: ${error.message}');
          _addLog(
            '   Response Info: ${error.responseInfo?.toString() ?? 'No response info'}',
          );
          completer.complete();
        },
      ),
    );

    return completer.future;
  }

  Future<void> _testRealAd() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _addLog('🎬 Testing real ad display...');

    await RewardedAd.load(
      adUnitId: _productionAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _addLog('✅ Real ad loaded, attempting to show...');
          _testAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) {
              _addLog('📺 Ad showed full screen content');
            },
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              _addLog('🔄 Ad dismissed');
              ad.dispose();
              _testAd = null;
              setState(() {
                _isLoading = false;
              });
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              _addLog('❌ Ad failed to show: ${error.message}');
              ad.dispose();
              _testAd = null;
              setState(() {
                _isLoading = false;
              });
            },
          );

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              _addLog('🎉 User earned reward: ${reward.amount} ${reward.type}');
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _addLog('❌ Real ad failed to load: ${error.message}');
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _testAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Diagnostics'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AdMob Configuration Check',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007BFF),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Production Ad Unit: $_productionAdUnitId',
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
                Text(
                  'Test Ad Unit: $_testAdUnitId',
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testRealAd,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Test Real Ad'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _logs.clear();
                      });
                      _runDiagnostics();
                    },
                    child: const Text('Re-run Diagnostics'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                Color textColor = Colors.black87;

                if (log.contains('❌')) {
                  textColor = Colors.red;
                } else if (log.contains('✅')) {
                  textColor = Colors.green;
                } else if (log.contains('⚠️')) {
                  textColor = Colors.orange;
                } else if (log.contains('🧪') || log.contains('🎯')) {
                  textColor = Colors.blue;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    log,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: textColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
