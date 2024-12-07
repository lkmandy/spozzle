import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Displays the [AppDialog] above the current contents of the app.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  String barrierLabel = '',
}) =>
    showGeneralDialog<T>(
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget widget) {
        final CurvedAnimation curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.decelerate,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: const Color(0x66000000),
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => AppDialog(
        child: child,
      ),
    );
