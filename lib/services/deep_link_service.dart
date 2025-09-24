// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/view_model/auth_view_model.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService()=>_instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init(BuildContext context) async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) _handleUri(uri, context);
    } catch (e) {
      debugPrint("Error fetching initial link: $e");
    }

    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri, context);
    });
  }

  void _handleUri(Uri uri, BuildContext context) async {
    debugPrint("AppLink received: $uri");

    if (uri.pathSegments.contains('task')) {
      final taskId = uri.pathSegments.last;

      final authVM = context.read<AuthViewModel>();
      final userId = authVM.user!.uid;

      if (userId.isNotEmpty) {
        await TodoService().addEditor(taskId, userId);
      }

     // context.go('/home');
    }
  }

  void dispose(){
    _sub?.cancel();
  }
}
