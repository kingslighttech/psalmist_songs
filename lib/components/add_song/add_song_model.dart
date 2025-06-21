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
import 'dart:ui';
import 'add_song_widget.dart' show AddSongWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddSongModel extends FlutterFlowModel<AddSongWidget> {
  ///  Local state fields for this component.

  bool? upload;

  ///  State fields for stateful widgets in this component.

  // State field(s) for ArtistID widget.
  FocusNode? artistIDFocusNode;
  TextEditingController? artistIDTextController;
  String? Function(BuildContext, String?)? artistIDTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in ArtistID widget.
  ArtistsRecord? artistID;
  // State field(s) for AlbumID widget.
  FocusNode? albumIDFocusNode;
  TextEditingController? albumIDTextController;
  String? Function(BuildContext, String?)? albumIDTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in AlbumID widget.
  AlbumsRecord? albumID;
  // State field(s) for ArtistName widget.
  FocusNode? artistNameFocusNode;
  TextEditingController? artistNameTextController;
  String? Function(BuildContext, String?)? artistNameTextControllerValidator;
  // State field(s) for Bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  // State field(s) for Songtitle widget.
  FocusNode? songtitleFocusNode;
  TextEditingController? songtitleTextController;
  String? Function(BuildContext, String?)? songtitleTextControllerValidator;
  // State field(s) for Albumtitle widget.
  FocusNode? albumtitleFocusNode;
  TextEditingController? albumtitleTextController;
  String? Function(BuildContext, String?)? albumtitleTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  bool isDataUploading_songIMG = false;
  FFUploadedFile uploadedLocalFile_songIMG =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_songIMG = '';

  bool isDataUploading_artistIMG = false;
  FFUploadedFile uploadedLocalFile_artistIMG =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_artistIMG = '';

  bool isDataUploading_albumIMG = false;
  FFUploadedFile uploadedLocalFile_albumIMG =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_albumIMG = '';

  bool isDataUploading_songFILE = false;
  FFUploadedFile uploadedLocalFile_songFILE =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading_songFileURL = false;
  FFUploadedFile uploadedLocalFile_songFileURL =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_songFileURL = '';

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  AlbumsRecord? albumref;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    artistIDFocusNode?.dispose();
    artistIDTextController?.dispose();

    albumIDFocusNode?.dispose();
    albumIDTextController?.dispose();

    artistNameFocusNode?.dispose();
    artistNameTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();

    songtitleFocusNode?.dispose();
    songtitleTextController?.dispose();

    albumtitleFocusNode?.dispose();
    albumtitleTextController?.dispose();
  }
}
