import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemoryManager {
  static final Map<String, Timer> _timers = {};
  static final Map<String, StreamSubscription> _subscriptions = {};
  static final List<TextEditingController> _controllers = [];
  static final List<ScrollController> _scrollControllers = [];

  // Safe timer creation and management
  static Timer createTimer(String id, Duration duration, VoidCallback callback) {
    cancelTimer(id); // Cancel existing timer with same id
    final timer = Timer(duration, () {
      callback();
      _timers.remove(id);
    });
    _timers[id] = timer;
    return timer;
  }

  static Timer createPeriodicTimer(String id, Duration duration, void Function(Timer) callback) {
    cancelTimer(id); // Cancel existing timer with same id
    final timer = Timer.periodic(duration, callback);
    _timers[id] = timer;
    return timer;
  }

  static void cancelTimer(String id) {
    final timer = _timers[id];
    if (timer != null) {
      timer.cancel();
      _timers.remove(id);
    }
  }

  static void cancelAllTimers() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  // Safe subscription management
  static void addSubscription(String id, StreamSubscription subscription) {
    cancelSubscription(id);
    _subscriptions[id] = subscription;
  }

  static void cancelSubscription(String id) {
    final subscription = _subscriptions[id];
    if (subscription != null) {
      subscription.cancel();
      _subscriptions.remove(id);
    }
  }

  static void cancelAllSubscriptions() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  // Controller management
  static TextEditingController createTextController({String? text}) {
    final controller = TextEditingController(text: text);
    _controllers.add(controller);
    return controller;
  }

  static ScrollController createScrollController({double initialScrollOffset = 0.0}) {
    final controller = ScrollController(initialScrollOffset: initialScrollOffset);
    _scrollControllers.add(controller);
    return controller;
  }

  static void disposeController(TextEditingController controller) {
    try {
      controller.dispose();
      _controllers.remove(controller);
    } catch (e) {
      log('Error disposing text controller: $e');
    }
  }

  static void disposeScrollController(ScrollController controller) {
    try {
      controller.dispose();
      _scrollControllers.remove(controller);
    } catch (e) {
      log('Error disposing scroll controller: $e');
    }
  }

  static void disposeAllControllers() {
    // Dispose text controllers
    for (final controller in _controllers) {
      try {
        controller.dispose();
      } catch (e) {
        log('Error disposing text controller: $e');
      }
    }
    _controllers.clear();

    // Dispose scroll controllers
    for (final controller in _scrollControllers) {
      try {
        controller.dispose();
      } catch (e) {
        log('Error disposing scroll controller: $e');
      }
    }
    _scrollControllers.clear();
  }

  // Safe image loading and caching
  static Widget safeAssetImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit? fit,
    Widget? errorWidget,
  }) {
    try {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          log('Asset image loading error: $error');
          return errorWidget ?? _defaultErrorWidget(width, height);
        },
      );
    } catch (e) {
      log('Error creating asset image: $e');
      return errorWidget ?? _defaultErrorWidget(width, height);
    }
  }

  static Widget _defaultErrorWidget(double? width, double? height) {
    return Container(
      width: width ?? 50,
      height: height ?? 50,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  // Memory cleanup for GetX controllers
  static void cleanupGetxController(GetxController controller) {
    try {
      Get.delete<GetxController>(tag: controller.runtimeType.toString());
    } catch (e) {
      log('Error cleaning up GetX controller: $e');
    }
  }

  // Complete cleanup when app is disposed
  static void fullCleanup() {
    cancelAllTimers();
    cancelAllSubscriptions();
    disposeAllControllers();
    log('Memory cleanup completed');
  }
}

// Mixin for automatic memory management in StatefulWidgets
mixin MemoryManagedState<T extends StatefulWidget> on State<T> {
  final List<String> _timerIds = [];
  final List<String> _subscriptionIds = [];
  final List<TextEditingController> _managedControllers = [];
  final List<ScrollController> _managedScrollControllers = [];

  Timer createManagedTimer(String id, Duration duration, VoidCallback callback) {
    _timerIds.add(id);
    return MemoryManager.createTimer(id, duration, callback);
  }

  Timer createManagedPeriodicTimer(String id, Duration duration, void Function(Timer) callback) {
    _timerIds.add(id);
    return MemoryManager.createPeriodicTimer(id, duration, callback);
  }

  void addManagedSubscription(String id, StreamSubscription subscription) {
    _subscriptionIds.add(id);
    MemoryManager.addSubscription(id, subscription);
  }

  TextEditingController createManagedTextController({String? text}) {
    final controller = MemoryManager.createTextController(text: text);
    _managedControllers.add(controller);
    return controller;
  }

  ScrollController createManagedScrollController({double initialScrollOffset = 0.0}) {
    final controller = MemoryManager.createScrollController(initialScrollOffset: initialScrollOffset);
    _managedScrollControllers.add(controller);
    return controller;
  }

  @override
  void dispose() {
    // Cancel all managed timers
    for (final timerId in _timerIds) {
      MemoryManager.cancelTimer(timerId);
    }

    // Cancel all managed subscriptions
    for (final subscriptionId in _subscriptionIds) {
      MemoryManager.cancelSubscription(subscriptionId);
    }

    // Dispose all managed controllers
    for (final controller in _managedControllers) {
      MemoryManager.disposeController(controller);
    }

    for (final controller in _managedScrollControllers) {
      MemoryManager.disposeScrollController(controller);
    }

    super.dispose();
  }
}