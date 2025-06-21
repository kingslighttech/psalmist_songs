import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:async';
import 'dart:ui';
import 'manage_song_widget.dart' show ManageSongWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ManageSongModel extends FlutterFlowModel<ManageSongWidget> {
  ///  Local state fields for this component.

  bool? fileUDATEwidget;

  bool saveCHANGES = false;

  bool artistUPDATEwidget = false;

  bool albumUPDATEwidget = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in manage_song widget.
  AlbumsRecord? albumdoc;
  bool isDataUploading_updateSONGimg = false;
  FFUploadedFile uploadedLocalFile_updateSONGimg =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_updateSONGimg = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool isDataUploading_fILEupdate = false;
  FFUploadedFile uploadedLocalFile_fILEupdate =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  bool isDataUploading_uPDATEsongfile = false;
  FFUploadedFile uploadedLocalFile_uPDATEsongfile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uPDATEsongfile = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  bool isDataUploading_updateARTISTimg = false;
  FFUploadedFile uploadedLocalFile_updateARTISTimg =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_updateARTISTimg = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  bool isDataUploading_updateALBUMimg = false;
  FFUploadedFile uploadedLocalFile_updateALBUMimg =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_updateALBUMimg = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();
  }
}
