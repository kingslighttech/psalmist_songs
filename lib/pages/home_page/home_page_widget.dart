import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/help_center/help_center_widget.dart';
import '/components/notification/notification_widget.dart';
import '/components/search/search_widget.dart';
import '/components/subscribe/subscribe_widget.dart';
import '/components/webview/webview_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = 'homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final firestoreBatch = FirebaseFirestore.instance.batch();
      try {
        if (valueOrDefault(currentUserDocument?.cusID, '') == null ||
            valueOrDefault(currentUserDocument?.cusID, '') == '') {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: AlignmentDirectional(0.0, 0.0)
                    .resolve(Directionality.of(context)),
                child: WebViewAware(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(dialogContext).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: SubscribeWidget(),
                  ),
                ),
              );
            },
          );
        } else {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        _model.update = await queryNotificationsRecordOnce(
          queryBuilder: (notificationsRecord) => notificationsRecord.where(
            'APPversion',
            isNotEqualTo: FFAppState().appVER,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);
        if ((_model.update?.aPPversion != FFAppState().appVER) &&
            (_model.update?.aPPversion != null &&
                _model.update?.aPPversion != '')) {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: AlignmentDirectional(0.0, 0.0)
                    .resolve(Directionality.of(context)),
                child: WebViewAware(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(dialogContext).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: NotificationWidget(
                      details: _model.update,
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          unawaited(
            () async {
              await Future.delayed(const Duration(milliseconds: 1));
            }(),
          );
        }

        if (FFAppState().todaysdate == getCurrentTimestamp) {
          await Future.delayed(const Duration(milliseconds: 1));
        } else {
          FFAppState().deleteDailyViewCtrl();
          FFAppState().dailyViewCtrl = [];

          FFAppState().todaysdate = getCurrentTimestamp;
        }

        _model.instantTimer = InstantTimer.periodic(
          duration: Duration(milliseconds: 5000),
          callback: (timer) async {
            if ((functions.dateleft(currentUserDocument?.subTIME)! <= 0) &&
                loggedIn &&
                (valueOrDefault(currentUserDocument?.planDuration, '') ==
                    'Monthly subscription') &&
                (valueOrDefault(currentUserDocument?.subID, '') != null &&
                    valueOrDefault(currentUserDocument?.subID, '') != '') &&
                (valueOrDefault(currentUserDocument?.status, '') ==
                    'non-renewing')) {
              unawaited(
                () async {
                  firestoreBatch.update(currentUserReference!, {
                    ...mapToFirestore(
                      {
                        'cusID': FieldValue.delete(),
                        'subTIME': FieldValue.delete(),
                        'plan_duration': FieldValue.delete(),
                      },
                    ),
                  });
                }(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'SUBSCRIPTION CANCELLED',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 5000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
            } else if ((functions.datecompare(currentUserDocument?.subTIME) <=
                    0) &&
                loggedIn &&
                (valueOrDefault(currentUserDocument?.subID, '') != null &&
                    valueOrDefault(currentUserDocument?.subID, '') != '') &&
                (valueOrDefault(currentUserDocument?.planDuration, '') ==
                    'Yearly subscription') &&
                (valueOrDefault(currentUserDocument?.status, '') ==
                    'non-renewing')) {
              unawaited(
                () async {
                  firestoreBatch.update(currentUserReference!, {
                    ...mapToFirestore(
                      {
                        'cusID': FieldValue.delete(),
                        'subTIME': FieldValue.delete(),
                        'plan_duration': FieldValue.delete(),
                      },
                    ),
                  });
                }(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'SUBSCRIPTION CANCELLED',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 5000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
            } else if ((functions.dateleft(currentUserDocument?.subTIME)! <= 0) &&
                loggedIn &&
                (valueOrDefault(currentUserDocument?.subID, '') != null &&
                    valueOrDefault(currentUserDocument?.subID, '') != '') &&
                (valueOrDefault(currentUserDocument?.planDuration, '') ==
                    'Monthly subscription') &&
                (valueOrDefault(currentUserDocument?.status, '') ==
                    'non-renewing')) {
              unawaited(
                () async {
                  firestoreBatch.update(currentUserReference!, {
                    ...mapToFirestore(
                      {
                        'cusID': FieldValue.delete(),
                        'subTIME': FieldValue.delete(),
                        'plan_duration': FieldValue.delete(),
                        'status': FieldValue.delete(),
                      },
                    ),
                  });
                }(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'SUBSCRIPTION CANCELLED',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 5000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
            } else if ((functions.datecompare(currentUserDocument?.subTIME) <=
                    0) &&
                loggedIn &&
                (valueOrDefault(currentUserDocument?.subID, '') != null &&
                    valueOrDefault(currentUserDocument?.subID, '') != '') &&
                (valueOrDefault(currentUserDocument?.planDuration, '') ==
                    'Yearly subscription') &&
                (valueOrDefault(currentUserDocument?.status, '') ==
                    'non-renewing')) {
              unawaited(
                () async {
                  firestoreBatch.update(currentUserReference!, {
                    ...mapToFirestore(
                      {
                        'cusID': FieldValue.delete(),
                        'subTIME': FieldValue.delete(),
                        'plan_duration': FieldValue.delete(),
                        'status': FieldValue.delete(),
                      },
                    ),
                  });
                }(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'SUBSCRIPTION CANCELLED',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  duration: Duration(milliseconds: 5000),
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                ),
              );
            } else if ((functions.dateleft(currentUserDocument?.subTIME)! <= 0) &&
                loggedIn &&
                (valueOrDefault(currentUserDocument?.subID, '') != null &&
                    valueOrDefault(currentUserDocument?.subID, '') != '') &&
                (valueOrDefault(currentUserDocument?.planDuration, '') ==
                    'Monthly subscription') &&
                (valueOrDefault(currentUserDocument?.status, '') ==
                    'renewing')) {
              unawaited(
                () async {
                  firestoreBatch.update(
                      currentUserReference!,
                      createUsersRecordData(
                        subTIME: getCurrentTimestamp,
                      ));
                }(),
              );
            } else if ((functions.datecompare(currentUserDocument?.subTIME) <=
                    0) &&
                loggedIn &&
                (valueOrDefault(currentUserDocument?.subID, '') != null &&
                    valueOrDefault(currentUserDocument?.subID, '') != '') &&
                (valueOrDefault(currentUserDocument?.planDuration, '') ==
                    'Yearly subscription') &&
                (valueOrDefault(currentUserDocument?.status, '') == 'renewing')) {
              unawaited(
                () async {
                  firestoreBatch.update(
                      currentUserReference!,
                      createUsersRecordData(
                        subTIME: getCurrentTimestamp,
                      ));
                }(),
              );
            } else {
              await Future.delayed(const Duration(milliseconds: 1));
            }
          },
          startImmediately: true,
        );
      } finally {
        await firestoreBatch.commit();
      }
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController ??= TextEditingController(
        text: valueOrDefault<String>(
      currentUserDisplayName,
      'USER',
    ));
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => safeSetState(() {}));
    animationsMap.addAll({
      'iconOnPageLoadAnimation1': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation2': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation3': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation4': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation5': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation6': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation7': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation8': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation9': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation10': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation11': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation12': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation13': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation14': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation15': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, -1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'iconOnPageLoadAnimation16': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: Offset(0.0, 1.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.5, 1.5),
          ),
        ],
      ),
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(-13.0, 0.0),
            end: Offset(13.0, 0.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: null,
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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

    return Builder(
      builder: (context) => StreamBuilder<List<ArtistsRecord>>(
        stream: FFAppState().all(
          requestFn: () => queryArtistsRecord(),
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: SpinKitChasingDots(
                    color: FlutterFlowTheme.of(context).error,
                    size: 20.0,
                  ),
                ),
              ),
            );
          }
          List<ArtistsRecord> homePageArtistsRecordList = snapshot.data!;

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
                drawer: Container(
                  width: 300.0,
                  child: Drawer(
                    child: WebViewAware(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 30.0, 0.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if ((Theme.of(context).brightness ==
                                              Brightness.light) ==
                                          true) {
                                        setDarkModeSetting(
                                            context, ThemeMode.dark);
                                        if (animationsMap[
                                                'containerOnActionTriggerAnimation'] !=
                                            null) {
                                          animationsMap[
                                                  'containerOnActionTriggerAnimation']!
                                              .controller
                                              .forward(from: 0.0);
                                        }
                                      } else {
                                        setDarkModeSetting(
                                            context, ThemeMode.light);
                                        if (animationsMap[
                                                'containerOnActionTriggerAnimation'] !=
                                            null) {
                                          animationsMap[
                                                  'containerOnActionTriggerAnimation']!
                                              .controller
                                              .reverse();
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 60.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1F4F8),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: Color(0xFFE0E3E7),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Container(
                                          width: 60.0,
                                          height: 30.0,
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    -0.9, 0.0),
                                                child: Icon(
                                                  Icons.wb_sunny_rounded,
                                                  color: Color(0xFF57636C),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    1.0, 0.0),
                                                child: Icon(
                                                  Icons.mode_night_rounded,
                                                  color: Color(0xFF57636C),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    1.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4.0,
                                                        color:
                                                            Color(0x430B0D0F),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                      )
                                                    ],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ).animateOnActionTrigger(
                                                  animationsMap[
                                                      'containerOnActionTriggerAnimation']!,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 10.0, 10.0, 0.0),
                                child: Container(
                                  height: 152.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            final selectedMedia =
                                                await selectMediaWithSourceBottomSheet(
                                              context: context,
                                              maxWidth: 88.00,
                                              maxHeight: 88.00,
                                              allowPhoto: true,
                                            );
                                            if (selectedMedia != null &&
                                                selectedMedia.every((m) =>
                                                    validateFileFormat(
                                                        m.storagePath,
                                                        context))) {
                                              safeSetState(() => _model
                                                      .isDataUploading_uploadDataIko =
                                                  true);
                                              var selectedUploadedFiles =
                                                  <FFUploadedFile>[];

                                              var downloadUrls = <String>[];
                                              try {
                                                selectedUploadedFiles =
                                                    selectedMedia
                                                        .map((m) =>
                                                            FFUploadedFile(
                                                              name: m
                                                                  .storagePath
                                                                  .split('/')
                                                                  .last,
                                                              bytes: m.bytes,
                                                              height: m
                                                                  .dimensions
                                                                  ?.height,
                                                              width: m
                                                                  .dimensions
                                                                  ?.width,
                                                              blurHash:
                                                                  m.blurHash,
                                                            ))
                                                        .toList();

                                                downloadUrls =
                                                    (await Future.wait(
                                                  selectedMedia.map(
                                                    (m) async =>
                                                        await uploadData(
                                                            m.storagePath,
                                                            m.bytes),
                                                  ),
                                                ))
                                                        .where((u) => u != null)
                                                        .map((u) => u!)
                                                        .toList();
                                              } finally {
                                                _model.isDataUploading_uploadDataIko =
                                                    false;
                                              }
                                              if (selectedUploadedFiles
                                                          .length ==
                                                      selectedMedia.length &&
                                                  downloadUrls.length ==
                                                      selectedMedia.length) {
                                                safeSetState(() {
                                                  _model.uploadedLocalFile_uploadDataIko =
                                                      selectedUploadedFiles
                                                          .first;
                                                  _model.uploadedFileUrl_uploadDataIko =
                                                      downloadUrls.first;
                                                });
                                              } else {
                                                safeSetState(() {});
                                                return;
                                              }
                                            }

                                            await currentUserReference!
                                                .update(createUsersRecordData(
                                              photoUrl: _model
                                                  .uploadedFileUrl_uploadDataIko,
                                            ));
                                          },
                                          child: Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                  'assets/images/No-Image-Placeholder.png',
                                                ).image,
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 5.0,
                                              ),
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: AuthUserStreamWidget(
                                              builder: (context) => Container(
                                                width: 300.0,
                                                height: 300.0,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration(
                                                      milliseconds: 500),
                                                  fadeOutDuration: Duration(
                                                      milliseconds: 500),
                                                  imageUrl:
                                                      valueOrDefault<String>(
                                                    currentUserPhoto,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                  ),
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/images/error_image.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 10.0,
                                                  child: Container(
                                                    width: 181.0,
                                                    decoration: BoxDecoration(),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, 0.0),
                                                    child: AuthUserStreamWidget(
                                                      builder: (context) =>
                                                          TextFormField(
                                                        controller: _model
                                                            .textController,
                                                        focusNode: _model
                                                            .textFieldFocusNode,
                                                        onChanged: (_) =>
                                                            EasyDebounce
                                                                .debounce(
                                                          '_model.textController',
                                                          Duration(
                                                              milliseconds:
                                                                  2000),
                                                          () async {
                                                            await currentUserReference!
                                                                .update(
                                                                    createUsersRecordData(
                                                              displayName: _model
                                                                  .textController
                                                                  .text,
                                                            ));
                                                          },
                                                        ),
                                                        autofocus: false,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .none,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          focusedErrorBorder:
                                                              InputBorder.none,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontStyle,
                                                                ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLength: 20,
                                                        maxLengthEnforcement:
                                                            MaxLengthEnforcement
                                                                .enforced,
                                                        buildCounter: (context,
                                                                {required currentLength,
                                                                required isFocused,
                                                                maxLength}) =>
                                                            null,
                                                        validator: _model
                                                            .textControllerValidator
                                                            .asValidator(
                                                                context),
                                                        inputFormatters: [
                                                          if (!isAndroid &&
                                                              !isiOS)
                                                            TextInputFormatter
                                                                .withFunction(
                                                                    (oldValue,
                                                                        newValue) {
                                                              return TextEditingValue(
                                                                selection: newValue
                                                                    .selection,
                                                                text: newValue
                                                                    .text
                                                                    .toCapitalization(
                                                                        TextCapitalization
                                                                            .none),
                                                              );
                                                            }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0),
                                                        child: AutoSizeText(
                                                          currentUserEmail,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .readexPro(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        '06t1y2s9' /* STATUS :  */,
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .readexPro(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    if ((valueOrDefault(
                                                                currentUserDocument
                                                                    ?.planDuration,
                                                                '') ==
                                                            'Monthly subscription') &&
                                                        (valueOrDefault(
                                                                    currentUserDocument
                                                                        ?.cusID,
                                                                    '') !=
                                                                null &&
                                                            valueOrDefault(
                                                                    currentUserDocument
                                                                        ?.cusID,
                                                                    '') !=
                                                                '') &&
                                                        loggedIn)
                                                      AuthUserStreamWidget(
                                                        builder: (context) =>
                                                            Text(
                                                          '${functions.dateleft(currentUserDocument?.subTIME).toString()} days left',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .readexPro(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    if ((valueOrDefault(
                                                                currentUserDocument
                                                                    ?.planDuration,
                                                                '') ==
                                                            'Yearly subscription') &&
                                                        (valueOrDefault(
                                                                    currentUserDocument
                                                                        ?.cusID,
                                                                    '') !=
                                                                null &&
                                                            valueOrDefault(
                                                                    currentUserDocument
                                                                        ?.cusID,
                                                                    '') !=
                                                                '') &&
                                                        loggedIn)
                                                      AuthUserStreamWidget(
                                                        builder: (context) =>
                                                            Text(
                                                          '${functions.datecompare(currentUserDocument?.subTIME).toString()}months left',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .readexPro(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    if (valueOrDefault(
                                                                currentUserDocument
                                                                    ?.cusID,
                                                                '') ==
                                                            null ||
                                                        valueOrDefault(
                                                                currentUserDocument
                                                                    ?.cusID,
                                                                '') ==
                                                            '')
                                                      AuthUserStreamWidget(
                                                        builder: (context) =>
                                                            Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            'quzivno3' /* Free Version */,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .readexPro(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.0,
                                color: FlutterFlowTheme.of(context).accent4,
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: StreamBuilder<List<NotificationsRecord>>(
                                  stream: _model.noti(
                                    requestFn: () => queryNotificationsRecord(),
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
                                    List<NotificationsRecord>
                                        containerNotificationsRecordList =
                                        snapshot.data!;

                                    return Container(
                                      width: double.infinity,
                                      height: 29.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x00772272),
                                      ),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          context.pushNamed(
                                              NotificationsWidget.routeName);
                                        },
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '056l4jkn' /* Notifications */,
                                        ),
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 3.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ).animateOnPageLoad(
                                        animationsMap[
                                            'buttonOnPageLoadAnimation']!,
                                        effects: [
                                          ScaleEffect(
                                            curve: Curves.easeInOut,
                                            delay: 0.0.ms,
                                            duration: 600.0.ms,
                                            begin: Offset(1.0, 1.0),
                                            end: Offset(
                                                containerNotificationsRecordList
                                                            .where((e) => e
                                                                .userveiw
                                                                .contains(
                                                                    currentUserReference))
                                                            .toList()
                                                            .length !=
                                                        containerNotificationsRecordList
                                                            .length
                                                    ? 1.1
                                                    : 1.0,
                                                containerNotificationsRecordList
                                                            .where((e) => e
                                                                .userveiw
                                                                .contains(
                                                                    currentUserReference))
                                                            .toList()
                                                            .length !=
                                                        containerNotificationsRecordList
                                                            .length
                                                    ? 1.1
                                                    : 1.0),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 29.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x00772272),
                                  ),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (loggedIn) {
                                        GoRouter.of(context).prepareAuthEvent();
                                        await authManager.signOut();
                                        GoRouter.of(context)
                                            .clearRedirectLocation();

                                        context.goNamedAuth(
                                            AccountPageWidget.routeName,
                                            context.mounted);
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

                                        context.goNamedAuth(
                                            AccountPageWidget.routeName,
                                            context.mounted);
                                      }
                                    },
                                    text: FFLocalizations.of(context).getText(
                                      'lfjd1262' /* SIGN OUT */,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 5.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    showLoadingIndicator: false,
                                  ),
                                ),
                              ),
                              if (valueOrDefault<bool>(
                                      currentUserDocument?.admin, false) ==
                                  true)
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: AuthUserStreamWidget(
                                    builder: (context) => Container(
                                      width: double.infinity,
                                      height: 29.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x00772272),
                                      ),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          FFAppState().admin = true;

                                          context
                                              .pushNamed(AdminWidget.routeName);
                                        },
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'sc56qv4d' /* Admin */,
                                        ),
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 5.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        showLoadingIndicator: false,
                                      ),
                                    ),
                                  ),
                                ),
                              if (isWeb)
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 29.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x00772272),
                                    ),
                                    child: Builder(
                                      builder: (context) => FFButtonWidget(
                                        onPressed: () async {
                                          if (valueOrDefault(
                                                      currentUserDocument
                                                          ?.cusID,
                                                      '') ==
                                                  null ||
                                              valueOrDefault(
                                                      currentUserDocument
                                                          ?.cusID,
                                                      '') ==
                                                  '') {
                                            await showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return Dialog(
                                                  elevation: 0,
                                                  insetPadding: EdgeInsets.zero,
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
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: SubscribeWidget(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            _model.apiResultufk =
                                                await ManageSubCall.call(
                                              subID: valueOrDefault(
                                                  currentUserDocument?.subID,
                                                  ''),
                                            );

                                            if ((_model
                                                    .apiResultufk?.succeeded ??
                                                true)) {
                                              FFAppState().url =
                                                  ManageSubCall.mngSUB(
                                                (_model.apiResultufk
                                                        ?.jsonBody ??
                                                    ''),
                                              ).toString();
                                              safeSetState(() {});
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
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          child: WebviewWidget(
                                                            periodic:
                                                                () async {},
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'No recurring subscription',
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
                                            }
                                          }

                                          safeSetState(() {});
                                        },
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'nonaooz2' /* subscription */,
                                        ),
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 5.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        showLoadingIndicator: false,
                                      ),
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 1.0),
                                child: Builder(
                                  builder: (context) => FFButtonWidget(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, -1.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: WebViewAware(
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(dialogContext)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  child: HelpCenterWidget(),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    text: FFLocalizations.of(context).getText(
                                      'pcje0gyc' /* customer support */,
                                    ),
                                    icon: Icon(
                                      Icons.support_agent,
                                      size: 20.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      iconColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  height: 29.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x00772272),
                                  ),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (loggedIn) {
                                        var confirmDialogResponse =
                                            await showDialog<bool>(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return WebViewAware(
                                                      child: AlertDialog(
                                                        title: Text(
                                                            'DELETE ACCOUNT'),
                                                        content: Text(
                                                            'Are you sure you want to delete this account?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext,
                                                                    false),
                                                            child: Text('NO'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext,
                                                                    true),
                                                            child: Text('YES'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ) ??
                                                false;
                                        if (confirmDialogResponse) {
                                          await authManager.deleteUser(context);

                                          context.goNamed(
                                              AccountPageWidget.routeName);
                                        } else {
                                          Navigator.pop(context);
                                        }
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
                                    text: FFLocalizations.of(context).getText(
                                      'br13h16t' /* Delete Account */,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context).error,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 5.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    showLoadingIndicator: false,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 20.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                        TermsPoliciesWidget.routeName);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 5.0, 0.0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'obnjqnzq' /* Terms & Policies */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: FlutterFlowTheme.of(context).secondary,
                  automaticallyImplyLeading: false,
                  leading: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 0.0,
                          borderWidth: 1.0,
                          buttonSize: 60.0,
                          icon: FaIcon(
                            FontAwesomeIcons.bars,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.82, -0.89),
                        child: StreamBuilder<List<NotificationsRecord>>(
                          stream: _model.noti(
                            requestFn: () => queryNotificationsRecord(),
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: SpinKitFadingCircle(
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    size: 50.0,
                                  ),
                                ),
                              );
                            }
                            List<NotificationsRecord>
                                containerNotificationsRecordList =
                                snapshot.data!;

                            return Container(
                              decoration: BoxDecoration(),
                              child: Visibility(
                                visible:
                                    (containerNotificationsRecordList.length -
                                            containerNotificationsRecordList
                                                .length) >
                                        0,
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      (containerNotificationsRecordList.length -
                                              containerNotificationsRecordList
                                                  .length)
                                          .toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 10.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  title: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Hero(
                            tag: 'logo',
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Image.asset(
                                'assets/images/psalmistsongslogo.png',
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 0.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                '4fdh7m0i' /* Psalmist Songs */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .headlineLarge
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineLarge
                                          .fontStyle,
                                    ),
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
                      child: Builder(
                        builder: (context) => FlutterFlowIconButton(
                          borderRadius: 10.0,
                          buttonSize: 46.0,
                          fillColor: Color(0x00F9F9F9),
                          icon: Icon(
                            Icons.search_sharp,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 25.0,
                          ),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, -1.0)
                                      .resolve(Directionality.of(context)),
                                  child: WebViewAware(
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(dialogContext).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: SearchWidget(
                                        artistscollection:
                                            homePageArtistsRecordList,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  centerTitle: true,
                  toolbarHeight: 60.0,
                  elevation: 2.0,
                ),
                body: SafeArea(
                  top: true,
                  child: Stack(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                KeepAliveWidgetWrapper(
                                  builder: (context) => SingleChildScrollView(
                                    primary: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Builder(
                                            builder: (context) {
                                              final artistsimg =
                                                  homePageArtistsRecordList
                                                      .where((e) =>
                                                          e.bannerNo
                                                              .toString() ==
                                                          '1')
                                                      .toList()
                                                      .take(10)
                                                      .toList();

                                              return Container(
                                                width: 370.0,
                                                height: 210.0,
                                                child: CarouselSlider.builder(
                                                  itemCount: artistsimg.length,
                                                  itemBuilder: (context,
                                                      artistsimgIndex, _) {
                                                    final artistsimgItem =
                                                        artistsimg[
                                                            artistsimgIndex];
                                                    return InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        FFAppState().playlistA =
                                                            artistsimgIndex;
                                                        safeSetState(() {});

                                                        context.pushNamed(
                                                          PlayerpageWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'artistdetails':
                                                                serializeParam(
                                                              artistsimgItem,
                                                              ParamType
                                                                  .Document,
                                                            ),
                                                            'artistdoc':
                                                                serializeParam(
                                                              homePageArtistsRecordList
                                                                  .where((e) =>
                                                                      e.artistID ==
                                                                      artistsimgItem
                                                                          .artistID)
                                                                  .toList(),
                                                              ParamType
                                                                  .Document,
                                                              isList: true,
                                                            ),
                                                          }.withoutNulls,
                                                          extra: <String,
                                                              dynamic>{
                                                            'artistdetails':
                                                                artistsimgItem,
                                                            'artistdoc': homePageArtistsRecordList
                                                                .where((e) =>
                                                                    e.artistID ==
                                                                    artistsimgItem
                                                                        .artistID)
                                                                .toList(),
                                                          },
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          fadeInDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          fadeOutDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          imageUrl:
                                                              valueOrDefault<
                                                                  String>(
                                                            artistsimgItem
                                                                .songIMG,
                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.fill,
                                                          errorWidget: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            'assets/images/error_image.jpg',
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  carouselController: _model
                                                          .carouselController ??=
                                                      CarouselSliderController(),
                                                  options: CarouselOptions(
                                                    initialPage: max(
                                                        0,
                                                        min(
                                                            2,
                                                            artistsimg.length -
                                                                1)),
                                                    viewportFraction: 1.0,
                                                    disableCenter: false,
                                                    enlargeCenterPage: false,
                                                    enlargeFactor: 0.0,
                                                    enableInfiniteScroll: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    autoPlay: true,
                                                    autoPlayAnimationDuration:
                                                        Duration(
                                                            milliseconds: 600),
                                                    autoPlayInterval: Duration(
                                                        milliseconds:
                                                            (600 + 3000)),
                                                    autoPlayCurve:
                                                        Curves.linear,
                                                    pauseAutoPlayInFiniteScroll:
                                                        true,
                                                    onPageChanged: (index, _) =>
                                                        _model.carouselCurrentIndex =
                                                            index,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'k17phof0' /* TOP VIDEOS */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'uv7fu725' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 20.0),
                                          child: Container(
                                            height: 150.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final topvid =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                (e.songViews.toString() !=
                                                                    '0') &&
                                                                (e.filetype ==
                                                                    'VIDEO'))
                                                            .toList()
                                                            .sortedList(
                                                                keyOf: (e) => e
                                                                    .songViews
                                                                    .toString(),
                                                                desc: true)
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: topvid.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          topvidIndex) {
                                                        final topvidItem =
                                                            topvid[topvidIndex];
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  FFAppState()
                                                                          .playlistA =
                                                                      topvidIndex;
                                                                  safeSetState(
                                                                      () {});
                                                                  unawaited(
                                                                    () async {
                                                                      if (Navigator.of(
                                                                              context)
                                                                          .canPop()) {
                                                                        context
                                                                            .pop();
                                                                      }
                                                                      context
                                                                          .pushNamed(
                                                                        PlayerpageWidget
                                                                            .routeName,
                                                                        queryParameters:
                                                                            {
                                                                          'artistdetails':
                                                                              serializeParam(
                                                                            topvidItem,
                                                                            ParamType.Document,
                                                                          ),
                                                                          'artistdoc':
                                                                              serializeParam(
                                                                            homePageArtistsRecordList.where((e) => (e.songViews.toString() != '0') && (e.filetype == 'VIDEO')).toList().sortedList(
                                                                                keyOf: (e) => e.songViews.toString(),
                                                                                desc: true),
                                                                            ParamType.Document,
                                                                            isList:
                                                                                true,
                                                                          ),
                                                                        }.withoutNulls,
                                                                        extra: <String,
                                                                            dynamic>{
                                                                          'artistdetails':
                                                                              topvidItem,
                                                                          'artistdoc': homePageArtistsRecordList
                                                                              .where((e) => (e.songViews.toString() != '0') && (e.filetype == 'VIDEO'))
                                                                              .toList()
                                                                              .sortedList(keyOf: (e) => e.songViews.toString(), desc: true),
                                                                          kTransitionInfoKey:
                                                                              TransitionInfo(
                                                                            hasTransition:
                                                                                true,
                                                                            transitionType:
                                                                                PageTransitionType.scale,
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            duration:
                                                                                Duration(milliseconds: 100),
                                                                          ),
                                                                        },
                                                                      );
                                                                    }(),
                                                                  );
                                                                },
                                                                child: Stack(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          -1.0),
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(100.0),
                                                                          bottomRight:
                                                                              Radius.circular(100.0),
                                                                          topLeft:
                                                                              Radius.circular(100.0),
                                                                          topRight:
                                                                              Radius.circular(100.0),
                                                                        ),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Hero(
                                                                        tag: valueOrDefault<
                                                                            String>(
                                                                          topvidItem
                                                                              .songIMG,
                                                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                              '$topvidIndex',
                                                                        ),
                                                                        transitionOnUserGestures:
                                                                            true,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(100.0),
                                                                            bottomRight:
                                                                                Radius.circular(100.0),
                                                                            topLeft:
                                                                                Radius.circular(100.0),
                                                                            topRight:
                                                                                Radius.circular(100.0),
                                                                          ),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            fadeInDuration:
                                                                                Duration(milliseconds: 500),
                                                                            fadeOutDuration:
                                                                                Duration(milliseconds: 500),
                                                                            imageUrl:
                                                                                valueOrDefault<String>(
                                                                              topvidItem.songIMG,
                                                                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                            ),
                                                                            width:
                                                                                100.0,
                                                                            height:
                                                                                110.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            errorWidget: (context, error, stackTrace) =>
                                                                                Image.asset(
                                                                              'assets/images/error_image.jpg',
                                                                              width: 100.0,
                                                                              height: 110.0,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          0.05,
                                                                          -0.85),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .slow_motion_video_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation1']!),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        topvidItem
                                                                            .songTittle,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.readexPro(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    't9bjilml' /* TOP AUDIOS */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '56iuntlu' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 20.0),
                                          child: Container(
                                            height: 150.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final topAudios =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                (e.songViews
                                                                        .toString() !=
                                                                    '0') &&
                                                                (e.filetype ==
                                                                    'AUDIO'))
                                                            .toList()
                                                            .sortedList(
                                                                keyOf: (e) =>
                                                                    e.songViews,
                                                                desc: true)
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          topAudios.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          topAudiosIndex) {
                                                        final topAudiosItem =
                                                            topAudios[
                                                                topAudiosIndex];
                                                        return InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            FFAppState()
                                                                    .playlistA =
                                                                topAudiosIndex;
                                                            safeSetState(() {});
                                                            unawaited(
                                                              () async {
                                                                if (Navigator.of(
                                                                        context)
                                                                    .canPop()) {
                                                                  context.pop();
                                                                }
                                                                context
                                                                    .pushNamed(
                                                                  PlayerpageWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'artistdetails':
                                                                        serializeParam(
                                                                      topAudiosItem,
                                                                      ParamType
                                                                          .Document,
                                                                    ),
                                                                    'artistdoc':
                                                                        serializeParam(
                                                                      homePageArtistsRecordList
                                                                          .where((e) =>
                                                                              (e.songViews.toString() != '0') &&
                                                                              (e.filetype ==
                                                                                  'VIDEO'))
                                                                          .toList()
                                                                          .sortedList(
                                                                              keyOf: (e) => e.songViews.toString(),
                                                                              desc: true),
                                                                      ParamType
                                                                          .Document,
                                                                      isList:
                                                                          true,
                                                                    ),
                                                                  }.withoutNulls,
                                                                  extra: <String,
                                                                      dynamic>{
                                                                    'artistdetails':
                                                                        topAudiosItem,
                                                                    'artistdoc': homePageArtistsRecordList
                                                                        .where((e) =>
                                                                            (e.songViews.toString() !=
                                                                                '0') &&
                                                                            (e.filetype ==
                                                                                'VIDEO'))
                                                                        .toList()
                                                                        .sortedList(
                                                                            keyOf: (e) =>
                                                                                e.songViews.toString(),
                                                                            desc: true),
                                                                    kTransitionInfoKey:
                                                                        TransitionInfo(
                                                                      hasTransition:
                                                                          true,
                                                                      transitionType:
                                                                          PageTransitionType
                                                                              .scale,
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              100),
                                                                    ),
                                                                  },
                                                                );
                                                              }(),
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              100.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              100.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              100.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              100.0),
                                                                    ),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                    ),
                                                                  ),
                                                                  child: Hero(
                                                                    tag: valueOrDefault<
                                                                        String>(
                                                                      topAudiosItem
                                                                          .songIMG,
                                                                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                          '$topAudiosIndex',
                                                                    ),
                                                                    transitionOnUserGestures:
                                                                        true,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(100.0),
                                                                        bottomRight:
                                                                            Radius.circular(100.0),
                                                                        topLeft:
                                                                            Radius.circular(100.0),
                                                                        topRight:
                                                                            Radius.circular(100.0),
                                                                      ),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInDuration:
                                                                            Duration(milliseconds: 500),
                                                                        fadeOutDuration:
                                                                            Duration(milliseconds: 500),
                                                                        imageUrl:
                                                                            valueOrDefault<String>(
                                                                          topAudiosItem
                                                                              .songIMG,
                                                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                        ),
                                                                        width:
                                                                            100.0,
                                                                        height:
                                                                            110.0,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        errorWidget: (context,
                                                                                error,
                                                                                stackTrace) =>
                                                                            Image.asset(
                                                                          'assets/images/error_image.jpg',
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              110.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          topAudiosItem
                                                                              .songTittle,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              1,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.readexPro(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'fvapw4lh' /* RECENTLY ADDED */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'yqa5jjk5' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child: StreamBuilder<
                                              List<ArtistsRecord>>(
                                            stream: FFAppState().recent(
                                              requestFn: () =>
                                                  queryArtistsRecord(
                                                queryBuilder: (artistsRecord) =>
                                                    artistsRecord.orderBy(
                                                        'date_added',
                                                        descending: true),
                                                limit: 10,
                                              ),
                                            ),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: SpinKitFadingCircle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      size: 50.0,
                                                    ),
                                                  ),
                                                );
                                              }
                                              List<ArtistsRecord>
                                                  containerArtistsRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(),
                                                child: Builder(
                                                  builder: (context) {
                                                    final containerVar =
                                                        homePageArtistsRecordList
                                                            .sortedList(
                                                                keyOf: (e) => e
                                                                    .dateAdded!,
                                                                desc: true)
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          containerVar.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          containerVarIndex) {
                                                        final containerVarItem =
                                                            containerVar[
                                                                containerVarIndex];
                                                        return SafeArea(
                                                          child: ClipRRect(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      FFAppState()
                                                                              .playlistA =
                                                                          containerVarIndex;
                                                                      safeSetState(
                                                                          () {});
                                                                      unawaited(
                                                                        () async {
                                                                          if (Navigator.of(context)
                                                                              .canPop()) {
                                                                            context.pop();
                                                                          }
                                                                          context
                                                                              .pushNamed(
                                                                            PlayerpageWidget.routeName,
                                                                            queryParameters:
                                                                                {
                                                                              'artistdetails': serializeParam(
                                                                                containerVarItem,
                                                                                ParamType.Document,
                                                                              ),
                                                                              'artistdoc': serializeParam(
                                                                                containerArtistsRecordList,
                                                                                ParamType.Document,
                                                                                isList: true,
                                                                              ),
                                                                            }.withoutNulls,
                                                                            extra: <String,
                                                                                dynamic>{
                                                                              'artistdetails': containerVarItem,
                                                                              'artistdoc': containerArtistsRecordList,
                                                                              kTransitionInfoKey: TransitionInfo(
                                                                                hasTransition: true,
                                                                                transitionType: PageTransitionType.scale,
                                                                                alignment: Alignment.bottomCenter,
                                                                                duration: Duration(milliseconds: 100),
                                                                              ),
                                                                            },
                                                                          );
                                                                        }(),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Hero(
                                                                              tag: valueOrDefault<String>(
                                                                                containerVarItem.songIMG,
                                                                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' + '$containerVarIndex',
                                                                              ),
                                                                              transitionOnUserGestures: true,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: CachedNetworkImage(
                                                                                  fadeInDuration: Duration(milliseconds: 500),
                                                                                  fadeOutDuration: Duration(milliseconds: 500),
                                                                                  imageUrl: valueOrDefault<String>(
                                                                                    containerVarItem.songIMG,
                                                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                                  ),
                                                                                  width: 120.0,
                                                                                  height: 80.0,
                                                                                  fit: BoxFit.fill,
                                                                                  errorWidget: (context, error, stackTrace) => Image.asset(
                                                                                    'assets/images/error_image.jpg',
                                                                                    width: 120.0,
                                                                                    height: 80.0,
                                                                                    fit: BoxFit.fill,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if (containerVarItem.filetype ==
                                                                            'AUDIO')
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(-0.02, -0.75),
                                                                            child:
                                                                                Icon(
                                                                              Icons.graphic_eq_sharp,
                                                                              color: Color(0xFFCB45C7),
                                                                              size: 25.0,
                                                                            ).animateOnPageLoad(animationsMap['iconOnPageLoadAnimation2']!),
                                                                          ),
                                                                        if (containerVarItem.filetype ==
                                                                            'VIDEO')
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.05, -0.85),
                                                                            child:
                                                                                Icon(
                                                                              Icons.slow_motion_video_sharp,
                                                                              color: Color(0xFFCB45C7),
                                                                              size: 25.0,
                                                                            ).animateOnPageLoad(animationsMap['iconOnPageLoadAnimation3']!),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Text(
                                                                            containerVarItem.songTittle,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                1,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  font: GoogleFonts.readexPro(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'fmzkxokg' /* ALBUMS */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '1p7mjaxa' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child:
                                              StreamBuilder<List<AlbumsRecord>>(
                                            stream: queryAlbumsRecord(),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: SpinKitFadingCircle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      size: 50.0,
                                                    ),
                                                  ),
                                                );
                                              }
                                              List<AlbumsRecord>
                                                  containerAlbumsRecordList =
                                                  snapshot.data!;

                                              return Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(),
                                                child: Builder(
                                                  builder: (context) {
                                                    final containerVar =
                                                        containerAlbumsRecordList
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          containerVar.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          containerVarIndex) {
                                                        final containerVarItem =
                                                            containerVar[
                                                                containerVarIndex];
                                                        return InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            context.pushNamed(
                                                              AlbumWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'albumref':
                                                                    serializeParam(
                                                                  containerVarItem,
                                                                  ParamType
                                                                      .Document,
                                                                ),
                                                                'tracklistRef':
                                                                    serializeParam(
                                                                  homePageArtistsRecordList
                                                                      .where((e) =>
                                                                          e.albumId
                                                                              ?.id ==
                                                                          containerVarItem
                                                                              .reference
                                                                              .id)
                                                                      .toList(),
                                                                  ParamType
                                                                      .Document,
                                                                  isList: true,
                                                                ),
                                                              }.withoutNulls,
                                                              extra: <String,
                                                                  dynamic>{
                                                                'albumref':
                                                                    containerVarItem,
                                                                'tracklistRef': homePageArtistsRecordList
                                                                    .where((e) =>
                                                                        e.albumId
                                                                            ?.id ==
                                                                        containerVarItem
                                                                            .reference
                                                                            .id)
                                                                    .toList(),
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Hero(
                                                                  tag: valueOrDefault<
                                                                      String>(
                                                                    containerVarItem
                                                                        .albumImg,
                                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                        '$containerVarIndex',
                                                                  ),
                                                                  transitionOnUserGestures:
                                                                      true,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              0.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              0.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              0.0),
                                                                    ),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      fadeInDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      fadeOutDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      imageUrl:
                                                                          valueOrDefault<
                                                                              String>(
                                                                        containerVarItem
                                                                            .albumImg,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                      ),
                                                                      height:
                                                                          80.0,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      errorWidget: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/error_image.jpg',
                                                                        height:
                                                                            80.0,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          2.0),
                                                                      child:
                                                                          Text(
                                                                        containerVarItem
                                                                            .albumTitle,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.readexPro(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'vx0g32tk' /* FAVOURITES */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '4lasxjqt' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 2.0, 0.0, 20.0),
                                          child: Container(
                                            height: 125.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final playlists =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                (e != null) ==
                                                                FFAppState()
                                                                    .MyPlaylist
                                                                    .contains(e
                                                                        .reference))
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          playlists.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          playlistsIndex) {
                                                        final playlistsItem =
                                                            playlists[
                                                                playlistsIndex];
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  FFAppState()
                                                                          .playlistA =
                                                                      playlistsIndex;
                                                                  safeSetState(
                                                                      () {});
                                                                  unawaited(
                                                                    () async {
                                                                      if (Navigator.of(
                                                                              context)
                                                                          .canPop()) {
                                                                        context
                                                                            .pop();
                                                                      }
                                                                      context
                                                                          .pushNamed(
                                                                        PlayerpageWidget
                                                                            .routeName,
                                                                        queryParameters:
                                                                            {
                                                                          'artistdetails':
                                                                              serializeParam(
                                                                            playlistsItem,
                                                                            ParamType.Document,
                                                                          ),
                                                                          'artistdoc':
                                                                              serializeParam(
                                                                            homePageArtistsRecordList.where((e) => (e.songViews.toString() != '0') && (e.filetype == 'VIDEO')).toList().sortedList(
                                                                                keyOf: (e) => e.songViews.toString(),
                                                                                desc: true),
                                                                            ParamType.Document,
                                                                            isList:
                                                                                true,
                                                                          ),
                                                                        }.withoutNulls,
                                                                        extra: <String,
                                                                            dynamic>{
                                                                          'artistdetails':
                                                                              playlistsItem,
                                                                          'artistdoc': homePageArtistsRecordList
                                                                              .where((e) => (e.songViews.toString() != '0') && (e.filetype == 'VIDEO'))
                                                                              .toList()
                                                                              .sortedList(keyOf: (e) => e.songViews.toString(), desc: true),
                                                                          kTransitionInfoKey:
                                                                              TransitionInfo(
                                                                            hasTransition:
                                                                                true,
                                                                            transitionType:
                                                                                PageTransitionType.scale,
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            duration:
                                                                                Duration(milliseconds: 100),
                                                                          ),
                                                                        },
                                                                      );
                                                                    }(),
                                                                  );
                                                                },
                                                                child: Stack(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          -1.0),
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(100.0),
                                                                          bottomRight:
                                                                              Radius.circular(100.0),
                                                                          topLeft:
                                                                              Radius.circular(100.0),
                                                                          topRight:
                                                                              Radius.circular(100.0),
                                                                        ),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Hero(
                                                                        tag: valueOrDefault<
                                                                            String>(
                                                                          playlistsItem
                                                                              .songIMG,
                                                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                              '$playlistsIndex',
                                                                        ),
                                                                        transitionOnUserGestures:
                                                                            true,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(100.0),
                                                                            bottomRight:
                                                                                Radius.circular(100.0),
                                                                            topLeft:
                                                                                Radius.circular(100.0),
                                                                            topRight:
                                                                                Radius.circular(100.0),
                                                                          ),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            fadeInDuration:
                                                                                Duration(milliseconds: 500),
                                                                            fadeOutDuration:
                                                                                Duration(milliseconds: 500),
                                                                            imageUrl:
                                                                                valueOrDefault<String>(
                                                                              playlistsItem.songIMG,
                                                                              'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                            ),
                                                                            width:
                                                                                100.0,
                                                                            height:
                                                                                110.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            errorWidget: (context, error, stackTrace) =>
                                                                                Image.asset(
                                                                              'assets/images/error_image.jpg',
                                                                              width: 100.0,
                                                                              height: 110.0,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          0.05,
                                                                          -0.85),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .slow_motion_video_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation4']!),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            10.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      playlistsItem
                                                                          .songTittle,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'ovg5cpe3' /* WORSHIP */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.libary = 'WORSHIP';
                                                    safeSetState(() {});
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'tyvekddq' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 150.0,
                                          child: Stack(
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final worships =
                                                      homePageArtistsRecordList
                                                          .where((e) =>
                                                              e.genre ==
                                                              'WORSHIP')
                                                          .toList()
                                                          .take(15)
                                                          .toList();

                                                  return ListView.separated(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: isWeb
                                                                ? 20.0
                                                                : 10.0),
                                                    primary: false,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: worships.length,
                                                    separatorBuilder: (_, __) =>
                                                        SizedBox(
                                                            width: isWeb
                                                                ? 20.0
                                                                : 10.0),
                                                    itemBuilder: (context,
                                                        worshipsIndex) {
                                                      final worshipsItem =
                                                          worships[
                                                              worshipsIndex];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .playlistA =
                                                                    worshipsIndex;
                                                                safeSetState(
                                                                    () {});
                                                                unawaited(
                                                                  () async {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      PlayerpageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'artistdetails':
                                                                            serializeParam(
                                                                          worshipsItem,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                        'artistdoc':
                                                                            serializeParam(
                                                                          homePageArtistsRecordList
                                                                              .where((e) => (e.songViews.toString() != '0') && (e.filetype == 'VIDEO'))
                                                                              .toList()
                                                                              .sortedList(keyOf: (e) => e.songViews.toString(), desc: true),
                                                                          ParamType
                                                                              .Document,
                                                                          isList:
                                                                              true,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'artistdetails':
                                                                            worshipsItem,
                                                                        'artistdoc': homePageArtistsRecordList
                                                                            .where((e) =>
                                                                                (e.songViews.toString() != '0') &&
                                                                                (e.filetype == 'VIDEO'))
                                                                            .toList()
                                                                            .sortedList(keyOf: (e) => e.songViews.toString(), desc: true),
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.scale,
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                      ),
                                                                    ),
                                                                    child: Hero(
                                                                      tag: valueOrDefault<
                                                                          String>(
                                                                        worshipsItem
                                                                            .songIMG,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                            '$worshipsIndex',
                                                                      ),
                                                                      transitionOnUserGestures:
                                                                          true,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(0.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fadeInDuration:
                                                                              Duration(milliseconds: 500),
                                                                          fadeOutDuration:
                                                                              Duration(milliseconds: 500),
                                                                          imageUrl:
                                                                              valueOrDefault<String>(
                                                                            worshipsItem.songIMG,
                                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                          ),
                                                                          width:
                                                                              100.0,
                                                                          height:
                                                                              80.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, error, stackTrace) =>
                                                                              Image.asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                100.0,
                                                                            height:
                                                                                80.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (worshipsItem
                                                                          .filetype ==
                                                                      'VIDEO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          0.05,
                                                                          -0.85),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .slow_motion_video_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation5']!),
                                                                    ),
                                                                  if (worshipsItem
                                                                          .filetype ==
                                                                      'AUDIO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -0.02,
                                                                          -0.75),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .graphic_eq_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation6']!),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  worshipsItem
                                                                      .songTittle,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'tox5mfea' /* PRAISE */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.libary = 'PRAISE';
                                                    safeSetState(() {});
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'gn6i1p6z' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child: Container(
                                            height: 100.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final praise =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                e.genre ==
                                                                'PRAISE')
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: praise.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          praiseIndex) {
                                                        final praiseItem =
                                                            praise[praiseIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .playlistA =
                                                                    praiseIndex;
                                                                safeSetState(
                                                                    () {});
                                                                unawaited(
                                                                  () async {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      PlayerpageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'artistdetails':
                                                                            serializeParam(
                                                                          praiseItem,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                        'artistdoc':
                                                                            serializeParam(
                                                                          homePageArtistsRecordList
                                                                              .where((e) => e.genre == 'PRAISE')
                                                                              .toList(),
                                                                          ParamType
                                                                              .Document,
                                                                          isList:
                                                                              true,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'artistdetails':
                                                                            praiseItem,
                                                                        'artistdoc': homePageArtistsRecordList
                                                                            .where((e) =>
                                                                                e.genre ==
                                                                                'PRAISE')
                                                                            .toList(),
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.scale,
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Hero(
                                                                      tag: valueOrDefault<
                                                                          String>(
                                                                        praiseItem
                                                                            .songIMG,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                            '$praiseIndex',
                                                                      ),
                                                                      transitionOnUserGestures:
                                                                          true,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fadeInDuration:
                                                                              Duration(milliseconds: 500),
                                                                          fadeOutDuration:
                                                                              Duration(milliseconds: 500),
                                                                          imageUrl:
                                                                              valueOrDefault<String>(
                                                                            praiseItem.songIMG,
                                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                          ),
                                                                          width:
                                                                              120.0,
                                                                          height:
                                                                              80.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, error, stackTrace) =>
                                                                              Image.asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                120.0,
                                                                            height:
                                                                                80.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (praiseItem
                                                                          .filetype ==
                                                                      'AUDIO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -0.02,
                                                                          -0.75),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .graphic_eq_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation7']!),
                                                                    ),
                                                                  if (praiseItem
                                                                          .filetype ==
                                                                      'VIDEO')
                                                                    Icon(
                                                                      Icons
                                                                          .videocam_outlined,
                                                                      color: Color(
                                                                          0xFFCB45C7),
                                                                      size:
                                                                          25.0,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                            'iconOnPageLoadAnimation8']!),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -0.22,
                                                                            1.11),
                                                                    child: Text(
                                                                      praiseItem
                                                                          .songTittle,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'q7ldxgiu' /* WARFARE */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.libary = 'WARFARE';
                                                    safeSetState(() {});
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'h6w7g9bg' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child: Container(
                                            height: 100.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final warfare =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                e.genre ==
                                                                'WARFARE')
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: warfare.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          warfareIndex) {
                                                        final warfareItem =
                                                            warfare[
                                                                warfareIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .playlistA =
                                                                    warfareIndex;
                                                                safeSetState(
                                                                    () {});
                                                                unawaited(
                                                                  () async {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      PlayerpageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'artistdetails':
                                                                            serializeParam(
                                                                          warfareItem,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                        'artistdoc':
                                                                            serializeParam(
                                                                          homePageArtistsRecordList
                                                                              .where((e) => e.genre == 'PRAISE')
                                                                              .toList(),
                                                                          ParamType
                                                                              .Document,
                                                                          isList:
                                                                              true,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'artistdetails':
                                                                            warfareItem,
                                                                        'artistdoc': homePageArtistsRecordList
                                                                            .where((e) =>
                                                                                e.genre ==
                                                                                'PRAISE')
                                                                            .toList(),
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.scale,
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Hero(
                                                                      tag: valueOrDefault<
                                                                          String>(
                                                                        warfareItem
                                                                            .songIMG,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                            '$warfareIndex',
                                                                      ),
                                                                      transitionOnUserGestures:
                                                                          true,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fadeInDuration:
                                                                              Duration(milliseconds: 500),
                                                                          fadeOutDuration:
                                                                              Duration(milliseconds: 500),
                                                                          imageUrl:
                                                                              valueOrDefault<String>(
                                                                            warfareItem.songIMG,
                                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                          ),
                                                                          width:
                                                                              120.0,
                                                                          height:
                                                                              80.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, error, stackTrace) =>
                                                                              Image.asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                120.0,
                                                                            height:
                                                                                80.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (warfareItem
                                                                          .filetype ==
                                                                      'AUDIO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -0.02,
                                                                          -0.75),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .graphic_eq_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation9']!),
                                                                    ),
                                                                  if (warfareItem
                                                                          .filetype ==
                                                                      'VIDEO')
                                                                    Icon(
                                                                      Icons
                                                                          .videocam_outlined,
                                                                      color: Color(
                                                                          0xFFCB45C7),
                                                                      size:
                                                                          25.0,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                            'iconOnPageLoadAnimation10']!),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -0.22,
                                                                            1.11),
                                                                    child: Text(
                                                                      warfareItem
                                                                          .songTittle,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'kgv9zmr3' /* INDIGENOUS */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.libary =
                                                        'INDIGENOUS';
                                                    safeSetState(() {});
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zmkcbf8e' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child: Container(
                                            height: 100.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final indigeneous =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                e.genre ==
                                                                'INDIGENOUS')
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          indigeneous.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          indigeneousIndex) {
                                                        final indigeneousItem =
                                                            indigeneous[
                                                                indigeneousIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .playlistA =
                                                                    indigeneousIndex;
                                                                safeSetState(
                                                                    () {});
                                                                unawaited(
                                                                  () async {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      PlayerpageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'artistdetails':
                                                                            serializeParam(
                                                                          indigeneousItem,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                        'artistdoc':
                                                                            serializeParam(
                                                                          homePageArtistsRecordList
                                                                              .where((e) => e.genre == 'PRAISE')
                                                                              .toList(),
                                                                          ParamType
                                                                              .Document,
                                                                          isList:
                                                                              true,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'artistdetails':
                                                                            indigeneousItem,
                                                                        'artistdoc': homePageArtistsRecordList
                                                                            .where((e) =>
                                                                                e.genre ==
                                                                                'PRAISE')
                                                                            .toList(),
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.scale,
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Hero(
                                                                      tag: valueOrDefault<
                                                                          String>(
                                                                        indigeneousItem
                                                                            .songIMG,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                            '$indigeneousIndex',
                                                                      ),
                                                                      transitionOnUserGestures:
                                                                          true,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fadeInDuration:
                                                                              Duration(milliseconds: 500),
                                                                          fadeOutDuration:
                                                                              Duration(milliseconds: 500),
                                                                          imageUrl:
                                                                              valueOrDefault<String>(
                                                                            indigeneousItem.songIMG,
                                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                          ),
                                                                          width:
                                                                              120.0,
                                                                          height:
                                                                              80.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, error, stackTrace) =>
                                                                              Image.asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                120.0,
                                                                            height:
                                                                                80.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (indigeneousItem
                                                                          .filetype ==
                                                                      'AUDIO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -0.02,
                                                                          -0.75),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .graphic_eq_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation11']!),
                                                                    ),
                                                                  if (indigeneousItem
                                                                          .filetype ==
                                                                      'VIDEO')
                                                                    Icon(
                                                                      Icons
                                                                          .videocam_outlined,
                                                                      color: Color(
                                                                          0xFFCB45C7),
                                                                      size:
                                                                          25.0,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                            'iconOnPageLoadAnimation12']!),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -0.22,
                                                                            1.11),
                                                                    child: Text(
                                                                      indigeneousItem
                                                                          .songTittle,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'u16wb58z' /* THANKSGIVING */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.libary =
                                                        'THANKSGIVING';
                                                    safeSetState(() {});
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'v8upeguu' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child: Container(
                                            height: 100.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final thanksgiving =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                e.genre ==
                                                                'THANKSGIVING')
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          thanksgiving.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          thanksgivingIndex) {
                                                        final thanksgivingItem =
                                                            thanksgiving[
                                                                thanksgivingIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .playlistA =
                                                                    thanksgivingIndex;
                                                                safeSetState(
                                                                    () {});
                                                                unawaited(
                                                                  () async {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      PlayerpageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'artistdetails':
                                                                            serializeParam(
                                                                          thanksgivingItem,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                        'artistdoc':
                                                                            serializeParam(
                                                                          homePageArtistsRecordList
                                                                              .where((e) => e.genre == 'PRAISE')
                                                                              .toList(),
                                                                          ParamType
                                                                              .Document,
                                                                          isList:
                                                                              true,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'artistdetails':
                                                                            thanksgivingItem,
                                                                        'artistdoc': homePageArtistsRecordList
                                                                            .where((e) =>
                                                                                e.genre ==
                                                                                'PRAISE')
                                                                            .toList(),
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.scale,
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Hero(
                                                                      tag: valueOrDefault<
                                                                          String>(
                                                                        thanksgivingItem
                                                                            .songIMG,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                            '$thanksgivingIndex',
                                                                      ),
                                                                      transitionOnUserGestures:
                                                                          true,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fadeInDuration:
                                                                              Duration(milliseconds: 500),
                                                                          fadeOutDuration:
                                                                              Duration(milliseconds: 500),
                                                                          imageUrl:
                                                                              valueOrDefault<String>(
                                                                            thanksgivingItem.songIMG,
                                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                          ),
                                                                          width:
                                                                              120.0,
                                                                          height:
                                                                              80.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, error, stackTrace) =>
                                                                              Image.asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                120.0,
                                                                            height:
                                                                                80.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (thanksgivingItem
                                                                          .filetype ==
                                                                      'AUDIO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -0.02,
                                                                          -0.75),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .graphic_eq_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation13']!),
                                                                    ),
                                                                  if (thanksgivingItem
                                                                          .filetype ==
                                                                      'VIDEO')
                                                                    Icon(
                                                                      Icons
                                                                          .videocam_outlined,
                                                                      color: Color(
                                                                          0xFFCB45C7),
                                                                      size:
                                                                          25.0,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                            'iconOnPageLoadAnimation14']!),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -0.22,
                                                                            1.11),
                                                                    child: Text(
                                                                      thanksgivingItem
                                                                          .songTittle,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: AutoSizeText(
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'gtt61ovn' /* PRAYER/REQUEST */,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    _model.libary =
                                                        'PRAYER/REQUEST';
                                                    safeSetState(() {});
                                                    safeSetState(() {
                                                      _model.tabBarController!
                                                          .animateTo(
                                                        min(
                                                            _model.tabBarController!
                                                                    .length -
                                                                1,
                                                            _model.tabBarController!
                                                                    .index +
                                                                1),
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    });
                                                  },
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '1jl78n6r' /* More > */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 20.0),
                                          child: Container(
                                            height: 100.0,
                                            child: Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final prayerrequest =
                                                        homePageArtistsRecordList
                                                            .where((e) =>
                                                                e.genre ==
                                                                'PRAYER/REQUEST')
                                                            .toList()
                                                            .take(15)
                                                            .toList();

                                                    return ListView.separated(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          prayerrequest.length,
                                                      separatorBuilder:
                                                          (_, __) => SizedBox(
                                                              width: isWeb
                                                                  ? 20.0
                                                                  : 10.0),
                                                      itemBuilder: (context,
                                                          prayerrequestIndex) {
                                                        final prayerrequestItem =
                                                            prayerrequest[
                                                                prayerrequestIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .playlistA =
                                                                    prayerrequestIndex;
                                                                safeSetState(
                                                                    () {});
                                                                unawaited(
                                                                  () async {
                                                                    if (Navigator.of(
                                                                            context)
                                                                        .canPop()) {
                                                                      context
                                                                          .pop();
                                                                    }
                                                                    context
                                                                        .pushNamed(
                                                                      PlayerpageWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'artistdetails':
                                                                            serializeParam(
                                                                          prayerrequestItem,
                                                                          ParamType
                                                                              .Document,
                                                                        ),
                                                                        'artistdoc':
                                                                            serializeParam(
                                                                          homePageArtistsRecordList
                                                                              .where((e) => e.genre == 'PRAISE')
                                                                              .toList(),
                                                                          ParamType
                                                                              .Document,
                                                                          isList:
                                                                              true,
                                                                        ),
                                                                      }.withoutNulls,
                                                                      extra: <String,
                                                                          dynamic>{
                                                                        'artistdetails':
                                                                            prayerrequestItem,
                                                                        'artistdoc': homePageArtistsRecordList
                                                                            .where((e) =>
                                                                                e.genre ==
                                                                                'PRAISE')
                                                                            .toList(),
                                                                        kTransitionInfoKey:
                                                                            TransitionInfo(
                                                                          hasTransition:
                                                                              true,
                                                                          transitionType:
                                                                              PageTransitionType.scale,
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          duration:
                                                                              Duration(milliseconds: 100),
                                                                        ),
                                                                      },
                                                                    );
                                                                  }(),
                                                                );
                                                              },
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Hero(
                                                                      tag: valueOrDefault<
                                                                          String>(
                                                                        prayerrequestItem
                                                                            .songIMG,
                                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png' +
                                                                            '$prayerrequestIndex',
                                                                      ),
                                                                      transitionOnUserGestures:
                                                                          true,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fadeInDuration:
                                                                              Duration(milliseconds: 500),
                                                                          fadeOutDuration:
                                                                              Duration(milliseconds: 500),
                                                                          imageUrl:
                                                                              valueOrDefault<String>(
                                                                            prayerrequestItem.songIMG,
                                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                          ),
                                                                          width:
                                                                              120.0,
                                                                          height:
                                                                              80.0,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          errorWidget: (context, error, stackTrace) =>
                                                                              Image.asset(
                                                                            'assets/images/error_image.jpg',
                                                                            width:
                                                                                120.0,
                                                                            height:
                                                                                80.0,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (prayerrequestItem
                                                                          .filetype ==
                                                                      'AUDIO')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -0.02,
                                                                          -0.75),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .graphic_eq_sharp,
                                                                        color: Color(
                                                                            0xFFCB45C7),
                                                                        size:
                                                                            25.0,
                                                                      ).animateOnPageLoad(
                                                                              animationsMap['iconOnPageLoadAnimation15']!),
                                                                    ),
                                                                  if (prayerrequestItem
                                                                          .filetype ==
                                                                      'VIDEO')
                                                                    Icon(
                                                                      Icons
                                                                          .videocam_outlined,
                                                                      color: Color(
                                                                          0xFFCB45C7),
                                                                      size:
                                                                          25.0,
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                            'iconOnPageLoadAnimation16']!),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -0.22,
                                                                            1.11),
                                                                    child: Text(
                                                                      prayerrequestItem
                                                                          .songTittle,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.readexPro(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                KeepAliveWidgetWrapper(
                                  builder: (context) => Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 35.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              _model.libary,
                                              'ALL',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight: FontWeight.w800,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: FlutterFlowChoiceChips(
                                                options: [
                                                  ChipData(FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    'bhqjin43' /* VIDEO */,
                                                  )),
                                                  ChipData(FFLocalizations.of(
                                                          context)
                                                      .getText(
                                                    '9ss8dotq' /* AUDIO */,
                                                  ))
                                                ],
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .choiceChipsValue =
                                                        val?.firstOrNull),
                                                selectedChipStyle: ChipStyle(
                                                  backgroundColor:
                                                      Color(0xFFCB45C7),
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  iconColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  iconSize: 18.0,
                                                  labelPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(50.0, 0.0,
                                                              50.0, 0.0),
                                                  elevation: 10.0,
                                                  borderColor:
                                                      Color(0xFF020001),
                                                  borderWidth: 1.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                unselectedChipStyle: ChipStyle(
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .readexPro(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  iconColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                  iconSize: 18.0,
                                                  labelPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(50.0, 0.0,
                                                              50.0, 0.0),
                                                  elevation: 0.0,
                                                  borderColor:
                                                      Color(0xFFCB45C7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                chipSpacing: 0.0,
                                                rowSpacing: 12.0,
                                                multiselect: false,
                                                initialized:
                                                    _model.choiceChipsValue !=
                                                        null,
                                                alignment: WrapAlignment.start,
                                                controller: _model
                                                        .choiceChipsValueController ??=
                                                    FormFieldController<
                                                        List<String>>(
                                                  [
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'b1slwmtv' /* VIDEO */,
                                                    )
                                                  ],
                                                ),
                                                wrapped: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: Builder(
                                              builder: (context) {
                                                final artistscollection =
                                                    homePageArtistsRecordList
                                                        .where((e) =>
                                                            (e.filetype ==
                                                                _model
                                                                    .choiceChipsValue) &&
                                                            (_model.libary !=
                                                                        null &&
                                                                    _model.libary !=
                                                                        ''
                                                                ? (e.genre ==
                                                                    _model
                                                                        .libary)
                                                                : false))
                                                        .toList();

                                                return GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 20.0,
                                                    mainAxisSpacing: 55.0,
                                                    childAspectRatio: 1.0,
                                                  ),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      artistscollection.length,
                                                  itemBuilder: (context,
                                                      artistscollectionIndex) {
                                                    final artistscollectionItem =
                                                        artistscollection[
                                                            artistscollectionIndex];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          FFAppState()
                                                                  .playlistA =
                                                              artistscollectionIndex;
                                                          safeSetState(() {});
                                                          unawaited(
                                                            () async {
                                                              context.pushNamed(
                                                                PlayerpageWidget
                                                                    .routeName,
                                                                queryParameters:
                                                                    {
                                                                  'artistdetails':
                                                                      serializeParam(
                                                                    artistscollectionItem,
                                                                    ParamType
                                                                        .Document,
                                                                  ),
                                                                  'artistdoc':
                                                                      serializeParam(
                                                                    homePageArtistsRecordList
                                                                        .where((e) =>
                                                                            e.artistID ==
                                                                            artistscollectionItem.artistID)
                                                                        .toList(),
                                                                    ParamType
                                                                        .Document,
                                                                    isList:
                                                                        true,
                                                                  ),
                                                                }.withoutNulls,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  'artistdetails':
                                                                      artistscollectionItem,
                                                                  'artistdoc': homePageArtistsRecordList
                                                                      .where((e) =>
                                                                          e.artistID ==
                                                                          artistscollectionItem
                                                                              .artistID)
                                                                      .toList(),
                                                                },
                                                              );
                                                            }(),
                                                          );
                                                        },
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  fadeInDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  fadeOutDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  imageUrl:
                                                                      valueOrDefault<
                                                                          String>(
                                                                    artistscollectionItem
                                                                        .songIMG,
                                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  alignment:
                                                                      Alignment(
                                                                          0.0,
                                                                          0.0),
                                                                  errorWidget: (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/error_image.jpg',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  artistscollectionItem
                                                                      .artistName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .readexPro(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            10.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          0.0,
                                                                          -1.0),
                                                                  child: Text(
                                                                    artistscollectionItem
                                                                        .songTittle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.readexPro(
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w800,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.0, 0),
                            child: FlutterFlowButtonTabBar(
                              useToggleButtonStyle: false,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                              unselectedLabelStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                              labelColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                              unselectedBackgroundColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              borderColor: FlutterFlowTheme.of(context).primary,
                              unselectedBorderColor:
                                  FlutterFlowTheme.of(context).primary,
                              borderWidth: 2.0,
                              borderRadius: 8.0,
                              elevation: 0.0,
                              buttonMargin: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              tabs: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home_sharp,
                                      size: _model.tabBarCurrentIndex == 0
                                          ? 35.0
                                          : 25.0,
                                    ),
                                    Tab(
                                      text: FFLocalizations.of(context).getText(
                                        'ypjgmfi3' /*  */,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.manage_search_sharp,
                                      size: _model.tabBarCurrentIndex == 1
                                          ? 35.0
                                          : 25.0,
                                    ),
                                    Tab(
                                      text: FFLocalizations.of(context).getText(
                                        'k1ki906b' /*  */,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) async {
                                [() async {}, () async {}][i]();
                              },
                            ),
                          ),
                        ],
                      ),
                      if (isWeb)
                        Align(
                          alignment: AlignmentDirectional(0.88, 0.87),
                          child: StreamBuilder<List<PricesRecord>>(
                            stream: queryPricesRecord(
                              queryBuilder: (pricesRecord) =>
                                  pricesRecord.where(
                                'voteSTAT',
                                isEqualTo: true,
                              ),
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
                              List<PricesRecord> containerPricesRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final containerPricesRecord =
                                  containerPricesRecordList.isNotEmpty
                                      ? containerPricesRecordList.first
                                      : null;

                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    VotingWidget.routeName,
                                    queryParameters: {
                                      'pricecheck': serializeParam(
                                        containerPricesRecord,
                                        ParamType.Document,
                                      ),
                                      'artistdoc': serializeParam(
                                        homePageArtistsRecordList,
                                        ParamType.Document,
                                        isList: true,
                                      ),
                                    }.withoutNulls,
                                    extra: <String, dynamic>{
                                      'pricecheck': containerPricesRecord,
                                      'artistdoc': homePageArtistsRecordList,
                                    },
                                  );
                                },
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Icon(
                                          Icons.how_to_vote,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 20.0,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          FFLocalizations.of(context).getText(
                                            'w8lt283y' /* VOTE
NOW */
                                            ,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                fontSize: 12.0,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation']!);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
