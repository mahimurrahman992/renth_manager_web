import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'memory_manager.dart';

class AppLifecycleManager extends GetxService with WidgetsBindingObserver {
  static AppLifecycleManager get instance => Get.find<AppLifecycleManager>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    log('AppLifecycleManager initialized');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    MemoryManager.fullCleanup();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        log('App resumed');
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        log('App paused');
        _onAppPaused();
        break;
      case AppLifecycleState.inactive:
        log('App inactive');
        _onAppInactive();
        break;
      case AppLifecycleState.detached:
        log('App detached');
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        log('App hidden');
        break;
    }
  }

  void _onAppResumed() {
    // App has come back to foreground
    try {
      // Refresh any necessary data
      // Check for updates
      // Refresh controllers if needed
    } catch (e) {
      log('Error handling app resume: $e');
    }
  }

  void _onAppPaused() {
    // App is going to background
    try {
      // Save any pending data
      // Pause timers if needed
      // Clean up temporary resources
    } catch (e) {
      log('Error handling app pause: $e');
    }
  }

  void _onAppInactive() {
    // App is temporarily inactive
    try {
      // Pause operations that shouldn't run when inactive
    } catch (e) {
      log('Error handling app inactive: $e');
    }
  }

  void _onAppDetached() {
    // App is being terminated
    try {
      // Final cleanup
      MemoryManager.fullCleanup();
    } catch (e) {
      log('Error handling app detached: $e');
    }
  }


  @override
  void didChangeLocales(List<Locale>? locales) {
    // Called when device locale changes
    super.didChangeLocales(locales);
    log('Device locale changed: $locales');
  }

  @override
  void didHaveMemoryPressure() {
    // Called when system is low on memory
    super.didHaveMemoryPressure();
    log('Memory pressure detected - cleaning up');
    _handleMemoryPressure();
  }

  void _handleMemoryPressure() {
    try {
      // Clean up cached images
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      
      // Clean up managed resources
      MemoryManager.fullCleanup();
      
      // Force garbage collection
      // Note: This is not guaranteed to work but may help
      // System.gc() is not available in Dart/Flutter directly
      
      log('Memory cleanup completed due to pressure');
    } catch (e) {
      log('Error handling memory pressure: $e');
    }
  }
}