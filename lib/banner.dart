import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  BannerPx(this.width, this.height);

  final double width;
  final double height;
}

class BannerMaxView extends StatelessWidget {
  BannerMaxView(this.listener, this.size, this.adUnitId, {Key? key})
      : super(key: key);

  final AppLovinListener listener;
  final Map<BannerAdSize, String> sizes = <BannerAdSize, String>{
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };
  final Map<BannerAdSize, BannerPx> sizesNum = <BannerAdSize, BannerPx>{
    BannerAdSize.banner: BannerPx(350, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final BannerAdSize size;
  final String adUnitId;

  @override
  Widget build(BuildContext context) {
    final AndroidView androidView = AndroidView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: <String, String>{
          'Size': sizes[size]!,
          'UnitId': adUnitId,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          const MethodChannel channel = MethodChannel('AppLovin');
          channel.setMethodCallHandler((MethodCall call) async =>
              FlutterApplovinMax.handleMethod(call, listener));
        });
    final UiKitView uiKitView = UiKitView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: <String, String>{
          'Size': sizes[size]!,
          'UnitId': adUnitId
        },
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          const MethodChannel channel = MethodChannel('AppLovin');
          channel.setMethodCallHandler((MethodCall call) async =>
              FlutterApplovinMax.handleMethod(call, listener));
        });

    return Container(
        width: sizesNum[size]?.width,
        height: sizesNum[size]?.height,
        child: Platform.isAndroid ? androidView : uiKitView);
  }
}
