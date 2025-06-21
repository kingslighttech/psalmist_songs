import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommentsRecord extends FirestoreRecord {
  CommentsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "comment_time" field.
  DateTime? _commentTime;
  DateTime? get commentTime => _commentTime;
  bool hasCommentTime() => _commentTime != null;

  // "comment_by" field.
  DocumentReference? _commentBy;
  DocumentReference? get commentBy => _commentBy;
  bool hasCommentBy() => _commentBy != null;

  // "comment_song" field.
  DocumentReference? _commentSong;
  DocumentReference? get commentSong => _commentSong;
  bool hasCommentSong() => _commentSong != null;

  // "userIMG" field.
  String? _userIMG;
  String get userIMG => _userIMG ?? '';
  bool hasUserIMG() => _userIMG != null;

  // "userNAME" field.
  String? _userNAME;
  String get userNAME => _userNAME ?? '';
  bool hasUserNAME() => _userNAME != null;

  // "reported" field.
  bool? _reported;
  bool get reported => _reported ?? false;
  bool hasReported() => _reported != null;

  void _initializeFields() {
    _comment = snapshotData['comment'] as String?;
    _commentTime = snapshotData['comment_time'] as DateTime?;
    _commentBy = snapshotData['comment_by'] as DocumentReference?;
    _commentSong = snapshotData['comment_song'] as DocumentReference?;
    _userIMG = snapshotData['userIMG'] as String?;
    _userNAME = snapshotData['userNAME'] as String?;
    _reported = snapshotData['reported'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('comments');

  static Stream<CommentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CommentsRecord.fromSnapshot(s));

  static Future<CommentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CommentsRecord.fromSnapshot(s));

  static CommentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CommentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CommentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CommentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CommentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CommentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCommentsRecordData({
  String? comment,
  DateTime? commentTime,
  DocumentReference? commentBy,
  DocumentReference? commentSong,
  String? userIMG,
  String? userNAME,
  bool? reported,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'comment': comment,
      'comment_time': commentTime,
      'comment_by': commentBy,
      'comment_song': commentSong,
      'userIMG': userIMG,
      'userNAME': userNAME,
      'reported': reported,
    }.withoutNulls,
  );

  return firestoreData;
}

class CommentsRecordDocumentEquality implements Equality<CommentsRecord> {
  const CommentsRecordDocumentEquality();

  @override
  bool equals(CommentsRecord? e1, CommentsRecord? e2) {
    return e1?.comment == e2?.comment &&
        e1?.commentTime == e2?.commentTime &&
        e1?.commentBy == e2?.commentBy &&
        e1?.commentSong == e2?.commentSong &&
        e1?.userIMG == e2?.userIMG &&
        e1?.userNAME == e2?.userNAME &&
        e1?.reported == e2?.reported;
  }

  @override
  int hash(CommentsRecord? e) => const ListEquality().hash([
        e?.comment,
        e?.commentTime,
        e?.commentBy,
        e?.commentSong,
        e?.userIMG,
        e?.userNAME,
        e?.reported
      ]);

  @override
  bool isValidKey(Object? o) => o is CommentsRecord;
}
