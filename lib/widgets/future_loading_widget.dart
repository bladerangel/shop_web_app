import 'package:flutter/material.dart';

import './dialog_widget.dart' as DialogWidget;

class FutureLoadingWidget extends StatelessWidget {
  final Widget child;
  final Future<dynamic> onAction;
  final bool visibleOpacity;

  const FutureLoadingWidget({
    Key key,
    @required this.child,
    @required this.onAction,
    this.visibleOpacity = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: onAction,
        builder: (ctx, snapshot) {
          if (snapshot.hasError)
            DialogWidget.showErrorDialog(error: snapshot.error, context: ctx);
          return Stack(
            children: [
              Opacity(
                opacity: snapshot.connectionState == ConnectionState.waiting
                    ? (visibleOpacity ? 0.5 : 0)
                    : 1,
                child: AbsorbPointer(
                  absorbing:
                      snapshot.connectionState == ConnectionState.waiting,
                  child: child,
                ),
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        });
  }
}
