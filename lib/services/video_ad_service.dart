import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class VideoAdService {
  static RewardedAd? _rewardedAd;
  static bool _isAdLoaded = false;
  static Completer<bool>? _adCompleter;
  static bool _isTestMode = false; // Set to true for testing

  // Production AdMob Ad Unit ID for rewarded video ads
  static const String _productionAdUnitId =
      'ca-app-pub-2412883259923012/2293147806';

  // Test AdMob Ad Unit ID (Google's test ad unit)
  static const String _testAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  // Get the appropriate ad unit ID
  static String get _adUnitId =>
      _isTestMode ? _testAdUnitId : _productionAdUnitId;

  /// Initialize AdMob
  static Future<void> initialize() async {
    debugPrint('🚀 Initializing AdMob...');
    await MobileAds.instance.initialize();

    debugPrint('📊 AdMob initialized successfully');

    // Get SDK version
    try {
      final version = await MobileAds.instance.getVersionString();
      debugPrint('📱 AdMob SDK version: $version');
    } catch (e) {
      debugPrint('⚠️ Could not get AdMob version: $e');
    }

    debugPrint('✅ AdMob initialized successfully');
    debugPrint(
      '🎯 Using ad unit: $_adUnitId (${_isTestMode ? 'TEST' : 'PRODUCTION'} mode)',
    );
  }

  /// Load a rewarded video ad
  static Future<void> loadRewardedAd() async {
    if (_isAdLoaded) {
      debugPrint('📱 Ad already loaded, skipping...');
      return;
    }

    debugPrint('📡 Loading rewarded ad from: $_adUnitId');

    await RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ Rewarded ad loaded successfully');

          // Log response info to check if it's a real ad
          final responseInfo = ad.responseInfo;
          if (responseInfo != null) {
            debugPrint('📊 Ad Response Info:');
            debugPrint(
              '   - Adapter: ${responseInfo.loadedAdapterResponseInfo?.adapterClassName ?? 'Unknown'}',
            );
            debugPrint(
              '   - Latency: ${responseInfo.loadedAdapterResponseInfo?.latencyMillis ?? 'Unknown'}ms',
            );
            debugPrint(
              '   - Response ID: ${responseInfo.responseId ?? 'Unknown'}',
            );

            // Check if this is a real ad or test ad
            final adapterName =
                responseInfo.loadedAdapterResponseInfo?.adapterClassName ?? '';
            if (adapterName.contains('admob') ||
                adapterName.contains('AdMob')) {
              debugPrint('🎯 Real AdMob ad detected!');
            } else if (adapterName.contains('test') ||
                adapterName.contains('Test')) {
              debugPrint('🧪 Test ad detected');
            } else {
              debugPrint('❓ Unknown ad type: $adapterName');
            }
          } else {
            debugPrint('⚠️ No response info available');
          }

          _rewardedAd = ad;
          _isAdLoaded = true;
          _setAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Rewarded ad failed to load:');
          debugPrint('   - Code: ${error.code}');
          debugPrint('   - Domain: ${error.domain}');
          debugPrint('   - Message: ${error.message}');
          debugPrint(
            '   - Response Info: ${error.responseInfo?.toString() ?? 'No response info'}',
          );

          _rewardedAd = null;
          _isAdLoaded = false;

          // If production ad fails, don't fallback to test mode automatically
          // Let the app handle the fallback
        },
      ),
    );
  }

  /// Set up ad event callbacks
  static void _setAdCallbacks() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        debugPrint('📺 Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('🔄 Rewarded ad dismissed, disposing and reloading');
        ad.dispose();
        _rewardedAd = null;
        _isAdLoaded = false;

        // Complete with false if user dismissed without reward
        if (_adCompleter != null && !_adCompleter!.isCompleted) {
          _adCompleter!.complete(false);
        }

        // Preload next ad
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('❌ Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        _isAdLoaded = false;

        // Complete with false on error
        if (_adCompleter != null && !_adCompleter!.isCompleted) {
          _adCompleter!.complete(false);
        }

        // Preload next ad
        loadRewardedAd();
      },
    );
  }

  /// Show rewarded video ad and return true if user earned reward
  static Future<bool> showVideoAd(BuildContext context) async {
    debugPrint('🎬 Attempting to show video ad...');

    if (!_isAdLoaded || _rewardedAd == null) {
      debugPrint('⚠️ No rewarded ad available, loading...');
      await loadRewardedAd();

      // If still not loaded, show fallback
      if (!_isAdLoaded || _rewardedAd == null) {
        debugPrint('❌ Failed to load real ad, showing fallback');
        if (context.mounted) {
          return _showFallbackAd(context);
        }
        return false;
      }
    }

    debugPrint('📺 Showing real AdMob ad...');
    _adCompleter = Completer<bool>();

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('🎉 User earned reward: ${reward.amount} ${reward.type}');
          if (_adCompleter != null && !_adCompleter!.isCompleted) {
            _adCompleter!.complete(true);
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error showing rewarded ad: $e');
      if (_adCompleter != null && !_adCompleter!.isCompleted) {
        _adCompleter!.complete(false);
      }
    }

    return _adCompleter!.future;
  }

  /// Fallback ad when real ads fail to load
  static Future<bool> _showFallbackAd(BuildContext context) async {
    debugPrint('🎭 Showing fallback ad (demo ad)');
    final completer = Completer<bool>();

    if (!context.mounted) {
      debugPrint('❌ Context not mounted, cannot show fallback ad');
      return false;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FallbackAdScreen(onComplete: completer.complete),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    return completer.future;
  }

  /// Enable test mode (shows Google test ads instead of production ads)
  static void enableTestMode() {
    _isTestMode = true;
    debugPrint('🧪 Test mode enabled - will use test ad unit: $_testAdUnitId');
  }

  /// Disable test mode (shows production ads)
  static void disableTestMode() {
    _isTestMode = false;
    debugPrint(
      '🎯 Production mode enabled - will use production ad unit: $_productionAdUnitId',
    );
  }

  /// Check if test mode is enabled
  static bool get isTestMode => _isTestMode;

  /// Check if ad is ready to show
  static bool isAdReady() {
    return _isAdLoaded && _rewardedAd != null;
  }

  /// Dispose resources
  static void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isAdLoaded = false;
  }
}

/// Fallback ad screen when real ads are not available
class FallbackAdScreen extends StatefulWidget {
  final Function(bool) onComplete;

  const FallbackAdScreen({super.key, required this.onComplete});

  @override
  State<FallbackAdScreen> createState() => _FallbackAdScreenState();
}

class _FallbackAdScreenState extends State<FallbackAdScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Timer _timer;
  int _remainingSeconds = 15; // Shorter fallback ad
  bool _canClose = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _startAd();
  }

  void _startAd() {
    _progressController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingSeconds--;
        });

        if (_remainingSeconds <= 0) {
          _completeAd();
        }
      }
    });
  }

  void _completeAd() {
    if (_isCompleted) return;

    _isCompleted = true;
    _timer.cancel();

    setState(() {
      _canClose = true;
      _remainingSeconds = 0;
    });
  }

  void _closeAd() {
    if (_isCompleted) return;

    _timer.cancel();
    _progressController.stop();
    Navigator.of(context).pop();
    widget.onComplete(false);
  }

  void _finishAd() {
    Navigator.of(context).pop();
    widget.onComplete(true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1a1a1a),
                      Color(0xFF2d2d2d),
                      Color(0xFF1a1a1a),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF007BFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF007BFF,
                            ).withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_filled,
                            size: 80,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'All Job Open',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Find Your Dream Job',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (!_canClose)
                      Text(
                        'Ad ends in $_remainingSeconds seconds',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      )
                    else
                      const Text(
                        'Ad completed! You can now close.',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Advertisement',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${15 - _remainingSeconds}/15s',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressController.value,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF007BFF),
                          ),
                          minHeight: 4,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_canClose)
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: _finishAd,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            if (!_canClose)
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Close Advertisement?'),
                        content: const Text(
                          'If you close the ad before it finishes, the job will not be applied.',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Continue Watching'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _closeAd();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Close Ad'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
