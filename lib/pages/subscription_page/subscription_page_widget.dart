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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'subscription_page_model.dart';
export 'subscription_page_model.dart';

class SubscriptionPageWidget extends StatefulWidget {
  const SubscriptionPageWidget({super.key});

  static String routeName = 'subscription_page';
  static String routePath = 'subscriptionPage';

  @override
  State<SubscriptionPageWidget> createState() => _SubscriptionPageWidgetState();
}

class _SubscriptionPageWidgetState extends State<SubscriptionPageWidget> {
  late SubscriptionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<PricesRecord>>(
      stream: queryPricesRecord(
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitFadingCircle(
                  color: FlutterFlowTheme.of(context).secondary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        List<PricesRecord> subscriptionPagePricesRecordList = snapshot.data!;
        final subscriptionPagePricesRecord =
            subscriptionPagePricesRecordList.isNotEmpty
                ? subscriptionPagePricesRecordList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: AppBar(
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                  automaticallyImplyLeading: false,
                  title: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/psalmistsongslogo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.05, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            '0vl2r03r' /* MFM PSALMISTS */,
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .fontStyle,
                                ),
                                fontSize: 30.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ],
                  ),
                  actions: [],
                  centerTitle: true,
                  toolbarHeight: 100.0,
                  elevation: 2.0,
                ),
              ),
              body: SafeArea(
                top: true,
                child: Visibility(
                  visible: isWeb,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 24.0, 16.0, 24.0),
                            child: StreamBuilder<List<VouchersRecord>>(
                              stream: queryVouchersRecord(
                                singleRecord: true,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: SpinKitFadingCircle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 50.0,
                                      ),
                                    ),
                                  );
                                }
                                List<VouchersRecord> columnVouchersRecordList =
                                    snapshot.data!;
                                final columnVouchersRecord =
                                    columnVouchersRecordList.isNotEmpty
                                        ? columnVouchersRecordList.first
                                        : null;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        '357v02ki' /* Choose a Subscription Plan */,
                                      ),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
                                      child: FlutterFlowDropDown<String>(
                                        controller: _model
                                                .planOptionValueController ??=
                                            FormFieldController<String>(null),
                                        options: [
                                          FFLocalizations.of(context).getText(
                                            'stfgh1zn' /* MONTHLY PLAN */,
                                          ),
                                          FFLocalizations.of(context).getText(
                                            'x5oj20xo' /* YEARLY PLAN */,
                                          )
                                        ],
                                        onChanged: (val) => safeSetState(
                                            () => _model.planOptionValue = val),
                                        width: 300.0,
                                        height: 50.0,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        hintText:
                                            FFLocalizations.of(context).getText(
                                          'qvtfgdy5' /* Please select a plan... */,
                                        ),
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
                                        elevation: 10.0,
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 2.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 4.0),
                                        hidesUnderline: true,
                                        isOverButton: true,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
                                      child: FlutterFlowDropDown<String>(
                                        controller: _model
                                                .planTypeValueController ??=
                                            FormFieldController<String>(null),
                                        options: [
                                          FFLocalizations.of(context).getText(
                                            'bpeti1jx' /* One Time Option */,
                                          ),
                                          FFLocalizations.of(context).getText(
                                            'oq36n4p2' /* RECURRING */,
                                          )
                                        ],
                                        onChanged: (val) => safeSetState(
                                            () => _model.planTypeValue = val),
                                        width: 300.0,
                                        height: 50.0,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        hintText:
                                            FFLocalizations.of(context).getText(
                                          'b3v2coud' /* Please select type... */,
                                        ),
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondary,
                                        elevation: 10.0,
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 2.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 4.0, 16.0, 4.0),
                                        hidesUnderline: true,
                                        isOverButton: true,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) => Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 16.0, 0.0, 40.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            var _shouldSetState = false;
                                            final firestoreBatch =
                                                FirebaseFirestore.instance
                                                    .batch();
                                            try {
                                              if (loggedIn) {
                                                if ((_model.planOptionValue ==
                                                        'MONTHLY PLAN') &&
                                                    (_model.planTypeValue ==
                                                        'One Time Option')) {
                                                  _model.url =
                                                      await InitializeMonthlyPaymentCall
                                                          .call(
                                                    email: currentUserEmail,
                                                    price:
                                                        subscriptionPagePricesRecord!
                                                                .monthlysubPrice *
                                                            100,
                                                  );

                                                  _shouldSetState = true;
                                                  FFAppState().ref =
                                                      InitializeMonthlyPaymentCall
                                                          .ref(
                                                    (_model.url?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                  FFAppState().url =
                                                      InitializeMonthlyPaymentCall
                                                          .url(
                                                    (_model.url?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                } else if ((_model
                                                            .planOptionValue ==
                                                        'MONTHLY PLAN') &&
                                                    (_model.planTypeValue ==
                                                        'RECURRING')) {
                                                  _model.url1 =
                                                      await InitializeMonthlyPaymentCall
                                                          .call(
                                                    email: currentUserEmail,
                                                    pln:
                                                        FFAppState().monthlyPLN,
                                                    price:
                                                        subscriptionPagePricesRecord!
                                                                .monthlysubPrice *
                                                            100,
                                                  );

                                                  _shouldSetState = true;
                                                  FFAppState().ref =
                                                      InitializeMonthlyPaymentCall
                                                          .ref(
                                                    (_model.url1?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                  FFAppState().url =
                                                      InitializeMonthlyPaymentCall
                                                          .url(
                                                    (_model.url1?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                } else if ((_model
                                                            .planOptionValue ==
                                                        'YEARLY PLAN') &&
                                                    (_model.planTypeValue ==
                                                        'One Time Option')) {
                                                  _model.url2 =
                                                      await InitializeYearlyPaymentCall
                                                          .call(
                                                    email: currentUserEmail,
                                                    price:
                                                        subscriptionPagePricesRecord!
                                                                .yearlysubPrice *
                                                            100,
                                                  );

                                                  _shouldSetState = true;
                                                  FFAppState().ref =
                                                      InitializeYearlyPaymentCall
                                                          .ref(
                                                    (_model.url2?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                  FFAppState().url =
                                                      InitializeYearlyPaymentCall
                                                          .url(
                                                    (_model.url2?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                } else if ((_model
                                                            .planOptionValue ==
                                                        'YEARLY PLAN') &&
                                                    (_model.planTypeValue ==
                                                        'RECURRING')) {
                                                  _model.url3 =
                                                      await InitializeYearlyPaymentCall
                                                          .call(
                                                    email: currentUserEmail,
                                                    pln: FFAppState().yearlyPLN,
                                                    price:
                                                        subscriptionPagePricesRecord!
                                                                .yearlysubPrice *
                                                            100,
                                                  );

                                                  _shouldSetState = true;
                                                  FFAppState().ref =
                                                      InitializeYearlyPaymentCall
                                                          .ref(
                                                    (_model.url3?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                  FFAppState().url =
                                                      InitializeYearlyPaymentCall
                                                          .url(
                                                    (_model.url3?.jsonBody ??
                                                        ''),
                                                  )!;
                                                  safeSetState(() {});
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return WebViewAware(
                                                        child: AlertDialog(
                                                          content: Text(
                                                              'Please select a plan'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      alertDialogContext),
                                                              child: Text('Ok'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }

                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      elevation: 0,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      alignment:
                                                          AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                      child: WebViewAware(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    dialogContext)
                                                                .unfocus();
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          child: Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                WebviewWidget(
                                                              periodic:
                                                                  () async {},
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );

                                                _model.subcheck =
                                                    InstantTimer.periodic(
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  callback: (timer) async {
                                                    _model.apiResult8fr1 =
                                                        await VerifyPaymentCall
                                                            .call(
                                                      ref: FFAppState().ref,
                                                    );

                                                    _shouldSetState = true;
                                                    if (VerifyPaymentCall
                                                            .status(
                                                          (_model.apiResult8fr1
                                                                  ?.jsonBody ??
                                                              ''),
                                                        ) ==
                                                        'success') {
                                                      firestoreBatch.update(
                                                          currentUserReference!,
                                                          createUsersRecordData(
                                                            cusID:
                                                                VerifyPaymentCall
                                                                    .cusID(
                                                              (_model.apiResult8fr1
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )?.toString(),
                                                            planID:
                                                                VerifyPaymentCall
                                                                    .planID(
                                                              (_model.apiResult8fr1
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            )?.toString(),
                                                            planDuration:
                                                                VerifyPaymentCall
                                                                    .planduration(
                                                              (_model.apiResult8fr1
                                                                      ?.jsonBody ??
                                                                  ''),
                                                            ).toString(),
                                                            subTIME:
                                                                getCurrentTimestamp,
                                                          ));
                                                      _model.apiResulte8y1 =
                                                          await GetsubscriptionCall
                                                              .call(
                                                        customer: valueOrDefault(
                                                            currentUserDocument
                                                                ?.cusID,
                                                            ''),
                                                        plan: valueOrDefault(
                                                            currentUserDocument
                                                                ?.planID,
                                                            ''),
                                                      );

                                                      _shouldSetState = true;
                                                      unawaited(
                                                        () async {
                                                          firestoreBatch.update(
                                                              currentUserReference!,
                                                              createUsersRecordData(
                                                                subID:
                                                                    GetsubscriptionCall
                                                                        .subID(
                                                                  (_model.apiResulte8y1
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                ),
                                                                status:
                                                                    GetsubscriptionCall
                                                                        .status(
                                                                  (_model.apiResulte8y1
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                ).toString(),
                                                              ));
                                                        }(),
                                                      );

                                                      context.goNamed(
                                                          HomePageWidget
                                                              .routeName);

                                                      _model.subcheck?.cancel();
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    } else if (VerifyPaymentCall
                                                            .status(
                                                          (_model.apiResult8fr1
                                                                  ?.jsonBody ??
                                                              ''),
                                                        ) ==
                                                        'abandoned') {
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'payment failed',
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                        ),
                                                      );
                                                      _model.subcheck?.cancel();
                                                      if (_shouldSetState)
                                                        safeSetState(() {});
                                                      return;
                                                    }
                                                  },
                                                  startImmediately: true,
                                                );
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return WebViewAware(
                                                      child: AlertDialog(
                                                        title:
                                                            Text('Hello user'),
                                                        content: Text(
                                                            'You need to sign in / create an account first !'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );

                                                context.goNamed(
                                                    AccountPageWidget
                                                        .routeName);

                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              }
                                            } finally {
                                              await firestoreBatch.commit();
                                            }

                                            if (_shouldSetState)
                                              safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'tz6m2kh2' /* Subscribe Now */,
                                          ),
                                          options: FFButtonOptions(
                                            width: 160.0,
                                            height: 50.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelLarge
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                            elevation: 10.0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 20.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 12.0, 0.0, 12.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 2.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Container(
                                                width: 70.0,
                                                height: 32.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Text(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'wgz24nbq' /* OR */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelLarge
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'ujtav3gn' /* Input Voucher Code */,
                                        ),
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          30.0, 0.0, 30.0, 0.0),
                                      child: TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: FFLocalizations.of(context)
                                              .getText(
                                            'cxptx3ym' /* Input Code... */,
                                          ),
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        validator: _model
                                            .textControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 16.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if (loggedIn) {
                                            if (columnVouchersRecord!.monthly
                                                .contains(_model
                                                    .textController.text)) {
                                              await currentUserReference!
                                                  .update(createUsersRecordData(
                                                cusID:
                                                    _model.textController.text,
                                                planDuration:
                                                    'Monthly subscription',
                                                subTIME: getCurrentTimestamp,
                                              ));
                                            } else if (columnVouchersRecord!
                                                .yearly
                                                .contains(_model
                                                    .textController.text)) {
                                              await currentUserReference!
                                                  .update(createUsersRecordData(
                                                cusID:
                                                    _model.textController.text,
                                                planDuration:
                                                    'Yearly subscription',
                                                subTIME: getCurrentTimestamp,
                                              ));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'invalid/incorrect code',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                ),
                                              );
                                              return;
                                            }

                                            context.goNamed(
                                                HomePageWidget.routeName);

                                            await columnVouchersRecord!
                                                .reference
                                                .update({
                                              ...mapToFirestore(
                                                {
                                                  'Monthly':
                                                      FieldValue.arrayRemove([
                                                    _model.textController.text
                                                  ]),
                                                  'Yearly':
                                                      FieldValue.arrayRemove([
                                                    _model.textController.text
                                                  ]),
                                                },
                                              ),
                                            });
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return WebViewAware(
                                                  child: AlertDialog(
                                                    title: Text('Hello user'),
                                                    content: Text(
                                                        'You need to sign in / create an account first !'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );

                                            context.goNamed(
                                                AccountPageWidget.routeName);
                                          }
                                        },
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'k9afq40e' /* Validate */,
                                        ),
                                        options: FFButtonOptions(
                                          width: 160.0,
                                          height: 50.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelLarge
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                          elevation: 10.0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context
                                            .goNamed(HomePageWidget.routeName);
                                      },
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          '0g0jhsm4' /* Later */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
