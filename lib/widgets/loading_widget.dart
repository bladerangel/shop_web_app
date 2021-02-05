import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final Widget child;
  final bool visibleOpacity;

  const LoadingWidget({
    Key key,
    @required this.child,
    this.visibleOpacity = true,
  }) : super(key: key);
  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  bool _isLoading = false;

  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void closeLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: _isLoading ? (widget.visibleOpacity ? 0.5 : 0) : 1,
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: widget.child,
          ),
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
