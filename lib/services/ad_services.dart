// // lib/shared/services/ad_service.dart
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdService {
//   static InterstitialAd? _interstitialAd;
//
//   static Future<void> showCleaningRewardAd() async {
//     await InterstitialAd.load(
//       adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ID
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//           ad.show();
//         },
//         onAdFailedToLoad: (error) {},
//       ),
//     );
//   }
// }
