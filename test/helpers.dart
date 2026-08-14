import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Matches the 402x874 design canvas at 1x density.
const Size kTestCanvas = Size(402, 874);

void setPhoneSurface(WidgetTester tester, [Size size = kTestCanvas]) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}
