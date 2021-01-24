import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<T> showErrorDialog<T>({
  DioError error,
  BuildContext context,
}) async =>
    Future.delayed(
      Duration.zero,
      () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'An error occurred!',
          ),
          content: Text(
            error.message,
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
