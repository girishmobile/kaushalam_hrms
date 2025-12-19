import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neeknots_admin/api/api_config.dart';
import 'package:neeknots_admin/core/router/route_name.dart';
import 'package:neeknots_admin/main.dart';
import 'package:neeknots_admin/provider/app_provider.dart';
import 'package:provider/provider.dart';

enum HttpMethod { get, post, put, patch, delete }

Future callApi({
  required String url,
  HttpMethod method = HttpMethod.get,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  Map<String, dynamic>? queryParams,
  Duration timeout = const Duration(seconds: 30),
}) async {
  try {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    final requestHeaders = headers ?? await ApiConfig.getApiHeaders();

    late http.Response response;

    switch (method) {
      case HttpMethod.get:
        response = await http
            .get(uri, headers: requestHeaders)
            .timeout(timeout);
        break;
      case HttpMethod.post:
        response = await http
            .post(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.put:
        response = await http
            .put(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.patch:
        response = await http
            .patch(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.delete:
        if (body != null) {
          final request = http.Request("DELETE", uri);
          request.headers.addAll(requestHeaders);
          request.body = jsonEncode(body);
          final streamedResponse = await request.send().timeout(timeout);
          response = await http.Response.fromStream(streamedResponse);
        } else {
          response = await http
              .delete(uri, headers: requestHeaders)
              .timeout(timeout);
        }
        break;
    }

    return getResponse(response);
  } on SocketException {
    errorMessage =
        "No Internet connection. Please check your network and try again.";
    return {'status': false, 'message': errorMessage};
  } on TimeoutException {
    errorMessage = "Request timed out. Please try again later.";

    return {'status': false, 'message': errorMessage};
  } catch (e) {
    errorMessage = "Something went wrong. Please try again.";
    return {'status': false, 'message': errorMessage};
  }
}

bool _isRedirectingToLogin = false;

Future<String> getResponse(http.Response response) async {
  globalStatusCode = response.statusCode;

  Map<String, dynamic> parsedJson = {};
  try {
    parsedJson = jsonDecode(response.body.toString());
  } catch (_) {
    // Not JSON response → ignore
  }

  /// Extract message safely
  String getMessage([String fallback = ""]) {
    return parsedJson['message']?.toString() ??
        parsedJson['data']?['message']?.toString() ??
        fallback;
  }

  /// Centralized redirect to login with 1-time trigger
  Future<void> redirectToLogin({String? message}) async {
    if (_isRedirectingToLogin) return; // Prevent multiple redirects
    _isRedirectingToLogin = true;
    Future.microtask(() async {
      final context = navigatorKey.currentContext;
      // Optional message SnackBar
      if (context != null && message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      // Reset dashboard state if available
      context?.read<AppProvider>().setPageIndex(2);
      // Redirect after short delay
      Future.delayed(const Duration(milliseconds: 900), () {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.loginPage,
          (_) => false,
        );
      });
    });
  }

  /// Handle token expired (custom server response)
  ///
  if (parsedJson['response'] == 'token error' &&
      getMessage() == 'Token Expired') {
    final msg = 'Session expired, please login again';
    await redirectToLogin(message: msg);
    return _jsonError(msg);
  }
  // ⚠️ Standard HTTP status code handling
  switch (globalStatusCode) {
    case 401:
      final msg = getMessage("Unauthorized");
      await redirectToLogin(message: msg);
      return _jsonError(msg);
    case 400:
    case 422:
      return _jsonError(getMessage("Invalid request"));

    case 403:
      return _jsonError(getMessage("Forbidden"));

    case 404:
      return _jsonError(getMessage("Not Found"), status: "419");

    case 405:
      return _jsonError("This method is not allowed.");

    case 419:
      return _jsonError(getMessage("Session expired"));
    case 500:
    case 502:
    case 503:
      return _jsonError("Internal server issue");

    case 204:
      return _jsonError(getMessage("No content"));
    default:
      return response.body;
  }
}

/// Helper to format clean JSON error response
String _jsonError(String message, {String status = "false"}) {
  final safeMessage = message.replaceAll(RegExp(r'[^\w\s]+'), '');
  return "{\"status\":\"$status\",\"message\":\"$safeMessage\"}";
}
