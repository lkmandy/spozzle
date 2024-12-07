import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spozzle/layout/layout.dart';

import '../helpers/helpers.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets(
        'displays a large layout '
        'for sizes greater than large', (WidgetTester tester) async {
      tester.setDisplaySize(const Size(PuzzleBreakpoints.large + 1, 800));

      const Key smallKey = Key('__small__');
      const Key mediumKey = Key('__medium__');
      const Key largeKey = Key('__large__');

      await tester.pumpApp(
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(key: smallKey),
          medium: (_, __) => const SizedBox(key: mediumKey),
          large: (_, __) => const SizedBox(key: largeKey),
        ),
      );

      expect(find.byKey(smallKey), findsNothing);
      expect(find.byKey(mediumKey), findsNothing);
      expect(find.byKey(largeKey), findsOneWidget);
    });

    group('on a large display', () {
      testWidgets('displays a large layout', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        const Key smallKey = Key('__small__');
        const Key mediumKey = Key('__medium__');
        const Key largeKey = Key('__large__');

        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, __) => const SizedBox(key: smallKey),
            medium: (_, __) => const SizedBox(key: mediumKey),
            large: (_, __) => const SizedBox(key: largeKey),
          ),
        );

        expect(find.byKey(smallKey), findsNothing);
        expect(find.byKey(mediumKey), findsNothing);
        expect(find.byKey(largeKey), findsOneWidget);
      });

      testWidgets('displays child when available', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        const Key smallKey = Key('__small__');
        const Key mediumKey = Key('__medium__');
        const Key largeKey = Key('__large__');
        const Key childKey = Key('__child__');

        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => SizedBox(key: smallKey, child: child),
            medium: (_, Widget? child) => SizedBox(key: mediumKey, child: child),
            large: (_, Widget? child) => SizedBox(key: largeKey, child: child),
            child: (_) => const SizedBox(key: childKey),
          ),
        );

        expect(find.byKey(smallKey), findsNothing);
        expect(find.byKey(mediumKey), findsNothing);
        expect(find.byKey(largeKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);
      });

      testWidgets('returns large layout size for child', (WidgetTester tester) async {
        tester.setLargeDisplaySize();

        ResponsiveLayoutSize? layoutSize;
        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => child!,
            medium: (_, Widget? child) => child!,
            large: (_, Widget? child) => child!,
            child: (ResponsiveLayoutSize currentLayoutSize) {
              layoutSize = currentLayoutSize;
              return const SizedBox();
            },
          ),
        );

        expect(
          layoutSize,
          equals(ResponsiveLayoutSize.large),
        );
      });
    });

    group('on a medium display', () {
      testWidgets('displays a medium layout', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        const Key smallKey = Key('__small__');
        const Key mediumKey = Key('__medium__');
        const Key largeKey = Key('__large__');

        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, __) => const SizedBox(key: smallKey),
            medium: (_, __) => const SizedBox(key: mediumKey),
            large: (_, __) => const SizedBox(key: largeKey),
          ),
        );

        expect(find.byKey(smallKey), findsNothing);
        expect(find.byKey(mediumKey), findsOneWidget);
        expect(find.byKey(largeKey), findsNothing);
      });

      testWidgets('displays child when available', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        const Key smallKey = Key('__small__');
        const Key mediumKey = Key('__medium__');
        const Key largeKey = Key('__large__');
        const Key childKey = Key('__child__');

        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => SizedBox(key: smallKey, child: child),
            medium: (_, Widget? child) => SizedBox(key: mediumKey, child: child),
            large: (_, Widget? child) => SizedBox(key: largeKey, child: child),
            child: (_) => const SizedBox(key: childKey),
          ),
        );

        expect(find.byKey(smallKey), findsNothing);
        expect(find.byKey(mediumKey), findsOneWidget);
        expect(find.byKey(largeKey), findsNothing);
        expect(find.byKey(childKey), findsOneWidget);
      });

      testWidgets('returns medium layout size for child', (WidgetTester tester) async {
        tester.setMediumDisplaySize();

        ResponsiveLayoutSize? layoutSize;
        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => child!,
            medium: (_, Widget? child) => child!,
            large: (_, Widget? child) => child!,
            child: (ResponsiveLayoutSize currentLayoutSize) {
              layoutSize = currentLayoutSize;
              return const SizedBox();
            },
          ),
        );

        expect(
          layoutSize,
          equals(ResponsiveLayoutSize.medium),
        );
      });
    });

    group('on a small display', () {
      testWidgets('displays a small layout', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        const Key smallKey = Key('__small__');
        const Key mediumKey = Key('__medium__');
        const Key largeKey = Key('__large__');

        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, __) => const SizedBox(key: smallKey),
            medium: (_, __) => const SizedBox(key: mediumKey),
            large: (_, __) => const SizedBox(key: largeKey),
          ),
        );

        expect(find.byKey(smallKey), findsOneWidget);
        expect(find.byKey(mediumKey), findsNothing);
        expect(find.byKey(largeKey), findsNothing);
      });

      testWidgets('displays child when available', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        const Key smallKey = Key('__small__');
        const Key mediumKey = Key('__medium__');
        const Key largeKey = Key('__large__');
        const Key childKey = Key('__child__');

        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => SizedBox(key: smallKey, child: child),
            medium: (_, Widget? child) => SizedBox(key: mediumKey, child: child),
            large: (_, Widget? child) => SizedBox(key: largeKey, child: child),
            child: (_) => const SizedBox(key: childKey),
          ),
        );

        expect(find.byKey(smallKey), findsOneWidget);
        expect(find.byKey(mediumKey), findsNothing);
        expect(find.byKey(largeKey), findsNothing);
        expect(find.byKey(childKey), findsOneWidget);

        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('returns small layout size for child', (WidgetTester tester) async {
        tester.setSmallDisplaySize();

        ResponsiveLayoutSize? layoutSize;
        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            small: (_, Widget? child) => child!,
            medium: (_, Widget? child) => child!,
            large: (_, Widget? child) => child!,
            child: (ResponsiveLayoutSize currentLayoutSize) {
              layoutSize = currentLayoutSize;
              return const SizedBox();
            },
          ),
        );

        expect(
          layoutSize,
          equals(ResponsiveLayoutSize.small),
        );
      });
    });
  });
}
