// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SongFileStruct extends FFFirebaseStruct {
  SongFileStruct({
    String? songVID,
    String? songAUD,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _songVID = songVID,
        _songAUD = songAUD,
        super(firestoreUtilData);

  // "songVID" field.
  String? _songVID;
  String get songVID => _songVID ?? '';
  set songVID(String? val) => _songVID = val;

  bool hasSongVID() => _songVID != null;

  // "songAUD" field.
  String? _songAUD;
  String get songAUD => _songAUD ?? '';
  set songAUD(String? val) => _songAUD = val;

  bool hasSongAUD() => _songAUD != null;

  static SongFileStruct fromMap(Map<String, dynamic> data) => SongFileStruct(
        songVID: data['songVID'] as String?,
        songAUD: data['songAUD'] as String?,
      );

  static SongFileStruct? maybeFromMap(dynamic data) =>
      data is Map ? SongFileStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'songVID': _songVID,
        'songAUD': _songAUD,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'songVID': serializeParam(
          _songVID,
          ParamType.String,
        ),
        'songAUD': serializeParam(
          _songAUD,
          ParamType.String,
        ),
      }.withoutNulls;

  static SongFileStruct fromSerializableMap(Map<String, dynamic> data) =>
      SongFileStruct(
        songVID: deserializeParam(
          data['songVID'],
          ParamType.String,
          false,
        ),
        songAUD: deserializeParam(
          data['songAUD'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SongFileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SongFileStruct &&
        songVID == other.songVID &&
        songAUD == other.songAUD;
  }

  @override
  int get hashCode => const ListEquality().hash([songVID, songAUD]);
}

SongFileStruct createSongFileStruct({
  String? songVID,
  String? songAUD,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SongFileStruct(
      songVID: songVID,
      songAUD: songAUD,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SongFileStruct? updateSongFileStruct(
  SongFileStruct? songFile, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    songFile
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSongFileStructData(
  Map<String, dynamic> firestoreData,
  SongFileStruct? songFile,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (songFile == null) {
    return;
  }
  if (songFile.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && songFile.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final songFileData = getSongFileFirestoreData(songFile, forFieldValue);
  final nestedData = songFileData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = songFile.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSongFileFirestoreData(
  SongFileStruct? songFile, [
  bool forFieldValue = false,
]) {
  if (songFile == null) {
    return {};
  }
  final firestoreData = mapToFirestore(songFile.toMap());

  // Add any Firestore field values
  songFile.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSongFileListFirestoreData(
  List<SongFileStruct>? songFiles,
) =>
    songFiles?.map((e) => getSongFileFirestoreData(e, true)).toList() ?? [];
