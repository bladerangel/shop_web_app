import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final Widget child;

  const LoadingWidget({
    Key key,
    @required this.child,
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
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : widget.child;
  }
}
