import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/achievements/score.dart';
import 'package:tictactoe/src/ads/banner_ad.dart';
import 'package:tictactoe/src/ads/preloaded_banner_ad.dart';
import 'package:tictactoe/src/in_app_purchase/in_app_purchase.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  final PreloadedBannerAd? preloadedAd;

  const WinGameScreen({
    Key? key,
    required this.score,
    this.preloadedAd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adsRemoved =
        context.watch<InAppPurchaseNotifier?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!adsRemoved &&
                // Since this is a compile-time constant, the web version
                // won't even import the code for ad serving. Tree shaking ftw.
                !kIsWeb &&
                platformSupportsAds) ...[
              Expanded(
                child: Center(
                  child: MyBannerAd(preloadedAd: preloadedAd),
                ),
              ),
            ],
            gap,
            Center(
              child: Text(
                'You won!',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                'Score: ${score.score}\n'
                'Time: ${score.formattedTime}',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 20),
              ),
            ),
            gap,
            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('NOT IMPLEMENTED YET, but this could use '
                        'Firebase / Google Cloud to save the finished game '
                        'board as a picture, so that the share is interesting'),
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 10),
                    Text('Share'),
                  ],
                ),
              ),
            ),
          ],
        ),
        rectangularMenuArea: RoughButton(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
