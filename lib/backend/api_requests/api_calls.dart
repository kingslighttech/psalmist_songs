import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class InitializeMonthlyPaymentCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? pln = '',
    int? price,
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${email}",
  "amount": "${price}",
  "plan": "${pln}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'initialize monthly payment',
      apiUrl: 'https://api.paystack.co/transaction/initialize',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer sk_live_4629909bae999e634b888479619d6f9b97c83895',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? url(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.authorization_url''',
      ));
  static String? ref(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.reference''',
      ));
}

class InitializeVotePaymentCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? pln = '',
    int? price,
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${email}",
  "amount": "${price}",
  "plan": "${pln}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'initialize vote payment',
      apiUrl: 'https://api.paystack.co/transaction/initialize',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer sk_live_4629909bae999e634b888479619d6f9b97c83895',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? url(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.authorization_url''',
      ));
  static String? ref(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.reference''',
      ));
}

class InitializeYearlyPaymentCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? pln = '',
    int? price,
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${email}",
  "amount": "${price}",
  "plan": "${pln}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'initialize yearly payment',
      apiUrl: 'https://api.paystack.co/transaction/initialize',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer sk_live_4629909bae999e634b888479619d6f9b97c83895',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? url(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.authorization_url''',
      ));
  static String? ref(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.reference''',
      ));
}

class VerifyPaymentCall {
  static Future<ApiCallResponse> call({
    String? ref = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'verify payment',
      apiUrl: 'https://api.paystack.co/transaction/verify/${ref}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization':
            'Bearer sk_live_4629909bae999e634b888479619d6f9b97c83895',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? cusID(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data.customer.id''',
      ));
  static int? planID(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.data.plan_object.id''',
      ));
  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
  static dynamic planduration(dynamic response) => getJsonField(
        response,
        r'''$.data.plan_object.name''',
      );
}

class GetsubscriptionCall {
  static Future<ApiCallResponse> call({
    String? customer = '',
    String? plan = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getsubscription',
      apiUrl: 'https://api.paystack.co/subscription',
      callType: ApiCallType.GET,
      headers: {
        'Authorization':
            'Bearer sk_live_4629909bae999e634b888479619d6f9b97c83895',
      },
      params: {
        'customer': customer,
        'plan': plan,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? subID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data[:].subscription_code''',
      ));
  static dynamic status(dynamic response) => getJsonField(
        response,
        r'''$.data[:].status''',
      );
}

class ManageSubCall {
  static Future<ApiCallResponse> call({
    String? subID = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'manage sub',
      apiUrl: 'https://api.paystack.co/subscription/${subID}/manage/link',
      callType: ApiCallType.GET,
      headers: {
        'Authorization':
            'Bearer sk_live_4629909bae999e634b888479619d6f9b97c83895',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic mngSUB(dynamic response) => getJsonField(
        response,
        r'''$.data.link''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
