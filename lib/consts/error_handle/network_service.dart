import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class NetworkService {
  static const Duration _timeout = Duration(seconds: 30);

  static Future<Map<String, dynamic>?> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'GET', url);
    }
  }

  static Future<Map<String, dynamic>?> post(String url, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body ?? {}),
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'POST', url);
    }
  }

  static Future<Map<String, dynamic>?> put(String url, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(body ?? {}),
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'PUT', url);
    }
  }

  static Future<Map<String, dynamic>?> delete(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e, 'DELETE', url);
    }
  }

  static Map<String, dynamic>? _handleResponse(http.Response response) {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        log('HTTP Error ${response.statusCode}: ${response.body}');
        _showErrorSnackbar('Server Error: ${data['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      log('JSON parsing error: $e');
      _showErrorSnackbar('Invalid server response');
      return null;
    }
  }

  static Map<String, dynamic>? _handleError(dynamic error, String method, String url) {
    String message = 'Network error occurred';
    
    if (error is SocketException) {
      message = 'No internet connection';
      log('No internet connection for $method $url');
    } else if (error is TimeoutException) {
      message = 'Request timeout';
      log('Timeout for $method $url');
    } else if (error is HttpException) {
      message = 'HTTP error occurred';
      log('HTTP error for $method $url: $error');
    } else {
      log('Unknown error for $method $url: $error');
    }
    
    _showErrorSnackbar(message);
    return null;
  }

  static void _showErrorSnackbar(String message) {
    try {
      if (Get.isSnackbarOpen != true) {
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE57373),
          colorText: const Color(0xFFFFFFFF),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
      }
    } catch (e) {
      log('Error showing snackbar: $e');
    }
  }

  // Image loading helper with error handling
  static Widget safeNetworkImage(String url, {
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    try {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          log('Image loading error: $error');
          return errorWidget ?? Container(
            width: width ?? 50,
            height: height ?? 50,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } catch (e) {
      log('Error creating network image: $e');
      return errorWidget ?? Container(
        width: width ?? 50,
        height: height ?? 50,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }
}

// Extension to add safe image loading to existing code
extension SafeImageExtension on Widget {
  Widget safeImage() {
    try {
      return this;
    } catch (e) {
      log('Image widgets error: $e');
      return Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }
}