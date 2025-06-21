import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/artist_bio/artist_bio_widget.dart';
import '/components/comment_tab/comment_tab_widget.dart';
import '/components/relatedsongs/relatedsongs_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'playerpage_model.dart';
export 'playerpage_model.dart';

/// share page feature
class PlayerpageWidget extends StatefulWidget {
  const PlayerpageWidget({
    super.key,
    this.artistdoc,
    this.artistdetails,
  });

  final List<ArtistsRecord>? artistdoc;
  final ArtistsRecord? artistdetails;

  static String routeName = 'playerpage';
  static String routePath = 'playerpage';

  @override
  State<PlayerpageWidget> createState() => _PlayerpageWidgetState();
}

class _PlayerpageWidgetState extends State<PlayerpageWidget>
    with TickerProviderStateMixin {
  late PlayerpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlayerpageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.autoplaylist = widget!.artistdoc!.toList().cast<ArtistsRecord>();
      _model.nowPLAYING = widget!.artistdetails;
      safeSetState(() {});
      if (widget!.artistdetails?.filetype == 'AUDIO') {
        _model.ur = await actions.audioUrl(
          widget!.artistdetails!.songFile.songAUD,
        );
        _model.songurl = _model.ur;
        safeSetState(() {});
      } else {
        _model.url = await actions.videoUrl(
          widget!.artistdetails!.songFile.songVID,
        );
        _model.songurl = _model.url;
        safeSetState(() {});
      }

      _model.time = await actions.getVideoDuration(
        _model.songurl!,
      );
      if (widget!.artistdetails?.reference == FFAppState().nowPlaying) {
        await Future.delayed(const Duration(milliseconds: 1000));
      } else {
        FFAppState().nowPlaying = widget!.artistdetails?.reference;
        FFAppState().songviewCount = 0;
        safeSetState(() {});
      }

      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          if ((FFAppState().isVideoPlaying == true) &&
              (_model.timer2Value != '00:00')) {
            _model.timer2Controller.onStartTimer();
          } else if ((FFAppState().isVideoPlaying == false) &&
              (_model.timer2Value != '00:00')) {
            _model.timer2Controller.onStopTimer();
          } else {
            await Future.delayed(const Duration(milliseconds: 1));
          }

          if ((FFAppState().videoProgress == _model.time) &&
              (_model.repeat != 1) &&
              (_model.autoplaylist.length.toString() !=
                  (FFAppState().playlistA + 1).toString())) {
            FFAppState().playlistA = FFAppState().playlistA + 1;
            safeSetState(() {});
            unawaited(
              () async {
                Navigator.pop(context);
              }(),
            );
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(
              PlayerpageWidget.routeName,
              queryParameters: {
                'artistdetails': serializeParam(
                  _model.autoplaylist.elementAtOrNull(FFAppState().playlistA),
                  ParamType.Document,
                ),
                'artistdoc': serializeParam(
                  _model.autoplaylist,
                  ParamType.Document,
                  isList: true,
                ),
              }.withoutNulls,
              extra: <String, dynamic>{
                'artistdetails':
                    _model.autoplaylist.elementAtOrNull(FFAppState().playlistA),
                'artistdoc': _model.autoplaylist,
              },
            );
          } else if ((FFAppState().videoProgress == _model.time) &&
              (_model.repeat == 2) &&
              (_model.autoplaylist.length.toString() ==
                  (FFAppState().playlistA + 1).toString())) {
            FFAppState().playlistA = 0;
            safeSetState(() {});
            unawaited(
              () async {
                Navigator.pop(context);
              }(),
            );
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(
              PlayerpageWidget.routeName,
              queryParameters: {
                'artistdetails': serializeParam(
                  _model.autoplaylist.elementAtOrNull(FFAppState().playlistA),
                  ParamType.Document,
                ),
                'artistdoc': serializeParam(
                  _model.autoplaylist,
                  ParamType.Document,
                  isList: true,
                ),
              }.withoutNulls,
              extra: <String, dynamic>{
                'artistdetails':
                    _model.autoplaylist.elementAtOrNull(FFAppState().playlistA),
                'artistdoc': _model.autoplaylist,
              },
            );
          } else {
            await Future.delayed(const Duration(milliseconds: 10));
          }

          if ((_model.repeat == 1) &&
              (_model.timer2Value == '00:00') &&
              (FFAppState().videoProgress == 0)) {
            _model.timer2Controller.onResetTimer();
          } else {
            await Future.delayed(const Duration(milliseconds: 10));
          }

          if (FFAppState().songviewCount == 20) {
            FFAppState().addToDailyViewCtrl(widget!.artistdetails!.reference);
          } else {
            await Future.delayed(const Duration(milliseconds: 10));
          }

          await Future.delayed(const Duration(milliseconds: 10));
        },
        startImmediately: true,
      );
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(3.0, -59.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pop();
                      },
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 30.0,
                      ),
                    ),
                    Builder(
                      builder: (context) => Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await showDialog(
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
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        child: ArtistBioWidget(
                                          artistinfo: widget!.artistdetails!,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent2,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Hero(
                                tag: valueOrDefault<String>(
                                  widget!.artistdetails?.artistArt,
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                ),
                                transitionOnUserGestures: true,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 0),
                                    fadeOutDuration: Duration(milliseconds: 0),
                                    imageUrl: valueOrDefault<String>(
                                      widget!.artistdetails?.artistArt,
                                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                    ),
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, error, stackTrace) =>
                                        Image.asset(
                                      'assets/images/error_image.jpg',
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation']!),
                      ),
                    ),
                    Icon(
                      Icons.share_outlined,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 25.0,
                    ),
                  ],
                ),
              ),
              StreamBuilder<ArtistsRecord>(
                stream:
                    ArtistsRecord.getDocument(widget!.artistdetails!.reference),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: SpinKitFadingCircle(
                          color: FlutterFlowTheme.of(context).secondary,
                          size: 50.0,
                        ),
                      ),
                    );
                  }

                  final columnArtistsRecord = snapshot.data!;

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondary,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  2.0, 0.0, 0.0, 0.0),
                                          child: AutoSizeText(
                                            'Now Playing: ${widget!.artistdetails?.artistName}',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontStyle,
                                                  ),
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  2.0, 2.0, 2.0, 2.0),
                                          child: AutoSizeText(
                                            widget!.artistdetails!.songTittle,
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ToggleIcon(
                                    onPressed: () async {
                                      safeSetState(
                                        () => FFAppState().MyPlaylist.contains(
                                                widget!
                                                    .artistdetails?.reference)
                                            ? FFAppState().removeFromMyPlaylist(
                                                widget!
                                                    .artistdetails!.reference)
                                            : FFAppState().addToMyPlaylist(
                                                widget!
                                                    .artistdetails!.reference),
                                      );
                                      if (FFAppState().MyPlaylist.contains(
                                          widget!.artistdetails?.reference)) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Added to favourite',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 2000),
                                            backgroundColor: Color(0xFF808080),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Removed from favourite',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 2000),
                                            backgroundColor: Color(0xFF808080),
                                          ),
                                        );
                                      }
                                    },
                                    value: FFAppState().MyPlaylist.contains(
                                        widget!.artistdetails?.reference),
                                    onIcon: FaIcon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    offIcon: FaIcon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 20.0),
                                  child: custom_widgets.CustomVideoPlayer(
                                    width: double.infinity,
                                    height: isWeb
                                        ? (MediaQuery.sizeOf(context).height *
                                            0.6)
                                        : 200.0,
                                    autoPlay: true,
                                    loop: _model.repeat.toString() == '1'
                                        ? true
                                        : false,
                                    videoUrl: _model.songurl!,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (widget!.artistdetails?.filetype ==
                                        'AUDIO')
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              fadeInDuration:
                                                  Duration(milliseconds: 500),
                                              fadeOutDuration:
                                                  Duration(milliseconds: 500),
                                              imageUrl: valueOrDefault<String>(
                                                widget!.artistdetails?.songIMG,
                                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                                              ),
                                              width: double.infinity,
                                              height: isWeb
                                                  ? (MediaQuery.sizeOf(context)
                                                          .height *
                                                      0.6)
                                                  : 200.0,
                                              fit: BoxFit.fill,
                                              alignment: Alignment(0.0, -1.0),
                                              errorWidget: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                'assets/images/error_image.jpg',
                                                width: double.infinity,
                                                height: isWeb
                                                    ? (MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.6)
                                                    : 200.0,
                                                fit: BoxFit.fill,
                                                alignment: Alignment(0.0, -1.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, 0.97),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 60.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ToggleIcon(
                                              onPressed: () async {
                                                safeSetState(() =>
                                                    FFAppState().shuffle =
                                                        !FFAppState().shuffle);

                                                safeSetState(() {});
                                              },
                                              value: FFAppState().shuffle,
                                              onIcon: Icon(
                                                Icons.shuffle_outlined,
                                                color: Color(0xFFCB45C7),
                                                size: 24.0,
                                              ),
                                              offIcon: Icon(
                                                Icons.shuffle_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderRadius: 8.0,
                                                    buttonSize: 40.0,
                                                    icon: Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 24.0,
                                                    ),
                                                    onPressed: true
                                                        ? null
                                                        : () {
                                                            print(
                                                                'IconButton pressed ...');
                                                          },
                                                  ),
                                                  Text(
                                                    formatNumber(
                                                      columnArtistsRecord
                                                          .songViews,
                                                      formatType:
                                                          FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displaySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 20.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (FFAppState().playlistA ==
                                                      0) {
                                                    FFAppState().playlistA = 0;
                                                    safeSetState(() {});
                                                  } else {
                                                    FFAppState().playlistA =
                                                        FFAppState().playlistA +
                                                            -1;
                                                    safeSetState(() {});
                                                  }

                                                  unawaited(
                                                    () async {
                                                      Navigator.pop(context);
                                                    }(),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    PlayerpageWidget.routeName,
                                                    queryParameters: {
                                                      'artistdetails':
                                                          serializeParam(
                                                        _model.autoplaylist
                                                            .elementAtOrNull(
                                                                FFAppState()
                                                                    .playlistA),
                                                        ParamType.Document,
                                                      ),
                                                      'artistdoc':
                                                          serializeParam(
                                                        _model.autoplaylist,
                                                        ParamType.Document,
                                                        isList: true,
                                                      ),
                                                    }.withoutNulls,
                                                    extra: <String, dynamic>{
                                                      'artistdetails': _model
                                                          .autoplaylist
                                                          .elementAtOrNull(
                                                              FFAppState()
                                                                  .playlistA),
                                                      'artistdoc':
                                                          _model.autoplaylist,
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.skip_previous_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      20.0, 0.0, 0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (_model.autoplaylist.length
                                                          .toString() ==
                                                      (FFAppState().playlistA +
                                                              1)
                                                          .toString()) {
                                                    FFAppState().playlistA = 0;
                                                    safeSetState(() {});
                                                  } else {
                                                    FFAppState().playlistA =
                                                        FFAppState().playlistA +
                                                            1;
                                                    safeSetState(() {});
                                                  }

                                                  unawaited(
                                                    () async {
                                                      Navigator.pop(context);
                                                    }(),
                                                  );
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    context.pop();
                                                  }
                                                  context.pushNamed(
                                                    PlayerpageWidget.routeName,
                                                    queryParameters: {
                                                      'artistdetails':
                                                          serializeParam(
                                                        _model.autoplaylist
                                                            .elementAtOrNull(
                                                                FFAppState()
                                                                    .playlistA),
                                                        ParamType.Document,
                                                      ),
                                                      'artistdoc':
                                                          serializeParam(
                                                        _model.autoplaylist,
                                                        ParamType.Document,
                                                        isList: true,
                                                      ),
                                                    }.withoutNulls,
                                                    extra: <String, dynamic>{
                                                      'artistdetails': _model
                                                          .autoplaylist
                                                          .elementAtOrNull(
                                                              FFAppState()
                                                                  .playlistA),
                                                      'artistdoc':
                                                          _model.autoplaylist,
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.skip_next_sharp,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ToggleIcon(
                                                        onPressed: () async {
                                                          final songLikesElement =
                                                              currentUserReference;
                                                          final songLikesUpdate =
                                                              columnArtistsRecord
                                                                      .songLikes
                                                                      .contains(
                                                                          songLikesElement)
                                                                  ? FieldValue
                                                                      .arrayRemove([
                                                                      songLikesElement
                                                                    ])
                                                                  : FieldValue
                                                                      .arrayUnion([
                                                                      songLikesElement
                                                                    ]);
                                                          await columnArtistsRecord
                                                              .reference
                                                              .update({
                                                            ...mapToFirestore(
                                                              {
                                                                'song_likes':
                                                                    songLikesUpdate,
                                                              },
                                                            ),
                                                          });
                                                        },
                                                        value: columnArtistsRecord
                                                            .songLikes
                                                            .contains(
                                                                currentUserReference),
                                                        onIcon: Icon(
                                                          Icons.thumb_up_alt,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 25.0,
                                                        ),
                                                        offIcon: Icon(
                                                          Icons
                                                              .thumb_up_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    formatNumber(
                                                      columnArtistsRecord
                                                          .songLikes.length,
                                                      formatType:
                                                          FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displaySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 8.0, 8.0, 8.0),
                                                  child: Stack(
                                                    children: [
                                                      if (_model.repeat
                                                              .toString() ==
                                                          '0')
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            _model.repeat = 2;
                                                            safeSetState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.repeat_sharp,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      if (_model.repeat
                                                              .toString() ==
                                                          '2')
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            _model.repeat = 1;
                                                            safeSetState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.repeat_sharp,
                                                            color: Color(
                                                                0xFFCB45C7),
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      if (_model.repeat
                                                              .toString() ==
                                                          '1')
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            _model.repeat = 0;
                                                            safeSetState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.repeat_one,
                                                            color: Color(
                                                                0xFFCB45C7),
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(width: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondary,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 0.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget!.artistdetails?.filetype == 'VIDEO')
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (_model.mytab != null) {
                                _model.mytab = null;
                                safeSetState(() {});
                              } else {
                                _model.mytab = 1;
                                safeSetState(() {});
                              }
                            },
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'nvpxgu4m' /* RELATED  SONGS */,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      if (widget!.artistdetails?.filetype == 'VIDEO')
                        FaIcon(
                          FontAwesomeIcons.gripLinesVertical,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                      FutureBuilder<int>(
                        future: queryCommentsRecordCount(
                          queryBuilder: (commentsRecord) =>
                              commentsRecord.where(
                            'comment_song',
                            isEqualTo: widget!.artistdetails?.reference,
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
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 50.0,
                                ),
                              ),
                            );
                          }
                          int textCount = snapshot.data!;

                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (_model.mytab != null) {
                                _model.mytab = null;
                                safeSetState(() {});
                              } else {
                                _model.mytab = 2;
                                safeSetState(() {});
                              }
                            },
                            child: Text(
                              valueOrDefault<String>(
                                '${formatNumber(
                                  textCount,
                                  formatType: FormatType.compact,
                                )} COMMENTS',
                                'Comments: 0',
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.roboto(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                            ),
                          );
                        },
                      ),
                    ].divide(SizedBox(width: 9.0)),
                  ),
                ),
              ),
              if (_model.mytab == 2)
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: wrapWithModel(
                      model: _model.commentTabModel,
                      updateCallback: () => safeSetState(() {}),
                      child: CommentTabWidget(
                        details: widget!.artistdetails!.reference,
                      ),
                    ),
                  ),
                ),
              if (_model.mytab == 1)
                wrapWithModel(
                  model: _model.relatedsongsModel,
                  updateCallback: () => safeSetState(() {}),
                  child: RelatedsongsWidget(
                    parameter1: widget!.artistdoc,
                    parameter2: widget!.artistdetails?.filetype,
                    parameter3: _model.autoplaylist,
                  ),
                ),
              if (false)
                Opacity(
                  opacity: 0.9,
                  child: FlutterFlowTimer(
                    initialTime: _model.timer2InitialTimeMs,
                    getDisplayTime: (value) => StopWatchTimer.getDisplayTime(
                      value,
                      hours: false,
                      milliSecond: false,
                    ),
                    controller: _model.timer2Controller,
                    updateStateInterval: Duration(milliseconds: 1000),
                    onChanged: (value, displayTime, shouldUpdate) {
                      _model.timer2Milliseconds = value;
                      _model.timer2Value = displayTime;
                      if (shouldUpdate) safeSetState(() {});
                    },
                    onEnded: () async {
                      if (FFAppState()
                              .dailyViewCtrl
                              .contains(widget!.artistdetails?.reference) ==
                          true) {
                        return;
                      }

                      unawaited(
                        () async {
                          await widget!.artistdetails!.reference.update({
                            ...mapToFirestore(
                              {
                                'song_views': FieldValue.increment(1),
                              },
                            ),
                          });
                        }(),
                      );
                      if (_model.repeat == 1) {
                        FFAppState().songviewCount =
                            FFAppState().songviewCount + 1;
                        return;
                      } else {
                        return;
                      }
                    },
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          font: GoogleFonts.outfit(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .fontStyle,
                          ),
                          fontSize: 1.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
