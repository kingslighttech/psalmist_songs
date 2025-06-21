import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/webview/webview_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import 'dart:ui';
import '/index.dart';
import 'subscription_page_widget.dart' show SubscriptionPageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class SubscriptionPageModel extends FlutterFlowModel<SubscriptionPageWidget> {
  ///  Local state fields for this page.

  int? email;

  int? uid;

  ///  State fields for stateful widgets in this page.

  // State field(s) for plan_option widget.
  String? planOptionValue;
  FormFieldController<String>? planOptionValueController;
  // State field(s) for plan_type widget.
  String? planTypeValue;
  FormFieldController<String>? planTypeValueController;
  // Stores action output result for [Backend Call - API (initialize monthly payment)] action in Button widget.
  ApiCallResponse? url;
  // Stores action output result for [Backend Call - API (initialize monthly payment)] action in Button widget.
  ApiCallResponse? url1;
  // Stores action output result for [Backend Call - API (initialize yearly payment)] action in Button widget.
  ApiCallResponse? url2;
  // Stores action output result for [Backend Call - API (initialize yearly payment)] action in Button widget.
  ApiCallResponse? url3;
  InstantTimer? subcheck;
  // Stores action output result for [Backend Call - API (verify payment)] action in Button widget.
  ApiCallResponse? apiResult8fr1;
  // Stores action output result for [Backend Call - API (getsubscription)] action in Button widget.
  ApiCallResponse? apiResulte8y1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    subcheck?.cancel();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
