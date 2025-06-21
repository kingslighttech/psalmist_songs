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
import 'playerpage_widget.dart' show PlayerpageWidget;
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

class PlayerpageModel extends FlutterFlowModel<PlayerpageWidget> {
  ///  Local state fields for this page.

  List<ArtistsRecord> autoplaylist = [];
  void addToAutoplaylist(ArtistsRecord item) => autoplaylist.add(item);
  void removeFromAutoplaylist(ArtistsRecord item) => autoplaylist.remove(item);
  void removeAtIndexFromAutoplaylist(int index) => autoplaylist.removeAt(index);
  void insertAtIndexInAutoplaylist(int index, ArtistsRecord item) =>
      autoplaylist.insert(index, item);
  void updateAutoplaylistAtIndex(int index, Function(ArtistsRecord) updateFn) =>
      autoplaylist[index] = updateFn(autoplaylist[index]);

  int repeat = 0;

  /// any
  ArtistsRecord? nowPLAYING;

  String? songurl;

  bool isAlbum = false;

  int? mytab;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - audioUrl] action in playerpage widget.
  String? ur;
  // Stores action output result for [Custom Action - videoUrl] action in playerpage widget.
  String? url;
  // Stores action output result for [Custom Action - getVideoDuration] action in playerpage widget.
  int? time;
  InstantTimer? instantTimer;
  // Model for comment_tab component.
  late CommentTabModel commentTabModel;
  // Model for RELATEDSONGS component.
  late RelatedsongsModel relatedsongsModel;
  // State field(s) for Timer2 widget.
  final timer2InitialTimeMs = 120000;
  int timer2Milliseconds = 120000;
  String timer2Value = StopWatchTimer.getDisplayTime(
    120000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timer2Controller =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {
    commentTabModel = createModel(context, () => CommentTabModel());
    relatedsongsModel = createModel(context, () => RelatedsongsModel());
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    commentTabModel.dispose();
    relatedsongsModel.dispose();
    timer2Controller.dispose();
  }
}
