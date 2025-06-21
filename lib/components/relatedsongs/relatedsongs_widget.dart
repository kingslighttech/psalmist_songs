import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'relatedsongs_model.dart';
export 'relatedsongs_model.dart';

class RelatedsongsWidget extends StatefulWidget {
  const RelatedsongsWidget({
    super.key,
    this.parameter1,
    this.parameter2,
    this.parameter3,
  });

  final List<ArtistsRecord>? parameter1;
  final String? parameter2;
  final List<ArtistsRecord>? parameter3;

  @override
  State<RelatedsongsWidget> createState() => _RelatedsongsWidgetState();
}

class _RelatedsongsWidgetState extends State<RelatedsongsWidget>
    with TickerProviderStateMixin {
  late RelatedsongsModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RelatedsongsModel());

    animationsMap.addAll({
      'iconOnPageLoadAnimation1': AnimationInfo(
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
      'iconOnPageLoadAnimation2': AnimationInfo(
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
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 326.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Visibility(
        visible: widget!.parameter2 == 'VIDEO',
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Builder(
            builder: (context) {
              final allvid = widget!.parameter3?.toList() ?? [];

              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: allvid.length,
                itemBuilder: (context, allvidIndex) {
                  final allvidItem = allvid[allvidIndex];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        unawaited(
                          () async {
                            if (Navigator.of(context).canPop()) {
                              context.pop();
                            }
                            context.pushNamed(
                              PlayerpageWidget.routeName,
                              queryParameters: {
                                'artistdetails': serializeParam(
                                  allvidItem,
                                  ParamType.Document,
                                ),
                                'artistdoc': serializeParam(
                                  widget!.parameter1,
                                  ParamType.Document,
                                  isList: true,
                                ),
                              }.withoutNulls,
                              extra: <String, dynamic>{
                                'artistdetails': allvidItem,
                                'artistdoc': widget!.parameter1,
                              },
                            );
                          }(),
                        );
                        FFAppState().playlistA = allvidIndex;
                        safeSetState(() {});
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 500),
                              fadeOutDuration: Duration(milliseconds: 500),
                              imageUrl: valueOrDefault<String>(
                                allvidItem.songIMG,
                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/music-template-mkrjdo/assets/heoaqiq96hii/No-Image-Placeholder.png',
                              ),
                              width: 100.0,
                              height: 79.0,
                              fit: BoxFit.fill,
                              errorWidget: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/error_image.jpg',
                                width: 100.0,
                                height: 79.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  5.0, 0.0, 5.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          allvidItem.songTittle,
                                          maxLines: 1,
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
                                                fontSize: 16.0,
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
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Text(
                                            allvidItem.artistName,
                                            maxLines: 1,
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (allvidItem.filetype == 'AUDIO')
                            Align(
                              alignment: AlignmentDirectional(-0.02, -0.75),
                              child: Icon(
                                Icons.graphic_eq_sharp,
                                color: Color(0xFFCB45C7),
                                size: 25.0,
                              ).animateOnPageLoad(
                                  animationsMap['iconOnPageLoadAnimation1']!),
                            ),
                          if (allvidItem.filetype == 'VIDEO')
                            Align(
                              alignment: AlignmentDirectional(0.05, -0.85),
                              child: Icon(
                                Icons.videocam_outlined,
                                color: Color(0xFFCB45C7),
                                size: 25.0,
                              ).animateOnPageLoad(
                                  animationsMap['iconOnPageLoadAnimation2']!),
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
    );
  }
}
