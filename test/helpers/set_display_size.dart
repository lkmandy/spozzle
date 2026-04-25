import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/layout/layout.dart';

extension PuzzleWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  }

  void setLargeDisplaySize() {
    setDisplaySize(const Size(PuzzleBreakpoints.large, 1000));
  }

  void setMediumDisplaySize() {
    setDisplaySize(const Size(PuzzleBreakpoints.medium, 1000));
  }

  void setSmallDisplaySize() {
    setDisplaySize(const Size(PuzzleBreakpoints.small, 1000));
  }
}
