import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resto_landing_page/main.dart';

void main() {
  testWidgets('LandingPage renders without crashing on desktop viewport', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RestoLandingPageApp());
    expect(find.byType(RestoLandingPageApp), findsOneWidget);
  });

  testWidgets('LandingPage renders without crashing on mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RestoLandingPageApp());
    expect(find.byType(RestoLandingPageApp), findsOneWidget);
  });
}
