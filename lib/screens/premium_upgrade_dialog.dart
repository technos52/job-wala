import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumUpgradeDialog extends StatefulWidget {
  const PremiumUpgradeDialog({super.key});

  @override
  State<PremiumUpgradeDialog> createState() => _PremiumUpgradeDialogState();
}

class _PremiumUpgradeDialogState extends State<PremiumUpgradeDialog> {
  static const Color primaryBlue = Color(0xFF007BFF);
  static const String rewardedTestAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Android test ad unit

  RewardedAd? _rewardedAd;
  bool _isLoadingAd = false;
  int _watchedCount = 0;
  bool _isPremium = false;
  DateTime? _premiumExpiry;
  String? _candidateDocId;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection('candidates')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      final doc = snap.docs.first;
      final data = doc.data();
      setState(() {
        _candidateDocId = doc.id;
        _watchedCount = (data['premiumAdsWatched'] ?? 0) as int;
        _isPremium = (data['isPremium'] ?? false) as bool;
        final ts = data['premiumExpiry'];
        if (ts is Timestamp) {
          _premiumExpiry = ts.toDate();
        }
      });
    }
  }

  Future<void> _saveProgress() async {
    if (_candidateDocId == null) return;
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc(_candidateDocId)
        .set({'premiumAdsWatched': _watchedCount}, SetOptions(merge: true));
  }

  Future<void> _grantPremium() async {
    if (_candidateDocId == null) return;
    final expiry = DateTime.now().add(const Duration(days: 30));
    await FirebaseFirestore.instance
        .collection('candidates')
        .doc(_candidateDocId)
        .set({
          'isPremium': true,
          'premiumExpiry': Timestamp.fromDate(expiry),
          'premiumAdsWatched': 0,
        }, SetOptions(merge: true));
    setState(() {
      _isPremium = true;
      _premiumExpiry = expiry;
      _watchedCount = 0;
    });
  }

  void _loadRewardedAd() {
    if (_isLoadingAd) return;
    setState(() {
      _isLoadingAd = true;
    });

    RewardedAd.load(
      adUnitId: rewardedTestAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isLoadingAd = false;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _isLoadingAd = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load ad: ${error.message}')),
          );
        },
      ),
    );
  }

  Future<void> _showAd() async {
    final ad = _rewardedAd;
    if (ad == null) {
      _loadRewardedAd();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        setState(() {
          _rewardedAd = null;
        });
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        setState(() {
          _rewardedAd = null;
        });
      },
    );
    ad.setImmersiveMode(true);
    await ad.show(
      onUserEarnedReward: (ad, reward) async {
        setState(() {
          _watchedCount += 1;
        });
        if (_watchedCount >= 3) {
          await _grantPremium();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Premium unlocked for 1 month!')),
            );
          }
        } else {
          await _saveProgress();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Progress: $_watchedCount/3')),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActivePremium =
        _isPremium &&
        _premiumExpiry != null &&
        _premiumExpiry!.isAfter(DateTime.now());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Upgrade to Premium',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.card_giftcard_rounded,
                        color: primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Watch 3 rewarded ads to unlock 1 month Premium',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (isActivePremium)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You are Premium until ${_premiumExpiry!.toLocal().toString().split(' ').first}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isActivePremium) ...[
                  Row(
                    children: [
                      const Text(
                        'Progress:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_watchedCount/3',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _watchedCount / 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                const Text(
                  'Benefits',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const _BenefitRow(text: 'Verified Badge'),
                const _BenefitRow(text: 'Dedicated Support Team'),
                const _BenefitRow(text: 'Direct Calls from Hiring Teams'),
                const _BenefitRow(text: 'Resume Guidelines'),
                const _BenefitRow(text: 'Interview Tips'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isActivePremium
                        ? null
                        : () {
                            if (_rewardedAd == null && !_isLoadingAd) {
                              _loadRewardedAd();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Loading ad...')),
                              );
                            } else {
                              _showAd();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isLoadingAd
                          ? 'Loading Ad...'
                          : (_rewardedAd == null
                                ? 'Watch Ad Now'
                                : 'Watch Ad Now'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Maybe Later',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String text;
  const _BenefitRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
