import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _MyPlaylist = (await secureStorage.getStringList('ff_MyPlaylist'))
              ?.map((path) => path.ref)
              .toList() ??
          _MyPlaylist;
    });
    await _safeInitAsync(() async {
      _monthlyPLN =
          await secureStorage.getString('ff_monthlyPLN') ?? _monthlyPLN;
    });
    await _safeInitAsync(() async {
      _yearlyPLN = await secureStorage.getString('ff_yearlyPLN') ?? _yearlyPLN;
    });
    await _safeInitAsync(() async {
      _IMG1 = await secureStorage.getString('ff_IMG1') ?? _IMG1;
    });
    await _safeInitAsync(() async {
      _IMG2 = await secureStorage.getString('ff_IMG2') ?? _IMG2;
    });
    await _safeInitAsync(() async {
      _like = (await secureStorage.getStringList('ff_like'))
              ?.map((path) => path.ref)
              .toList() ??
          _like;
    });
    await _safeInitAsync(() async {
      _CURRENCY = await secureStorage.getBool('ff_CURRENCY') ?? _CURRENCY;
    });
    await _safeInitAsync(() async {
      _appVER = await secureStorage.getString('ff_appVER') ?? _appVER;
    });
    await _safeInitAsync(() async {
      _shuffle = await secureStorage.getBool('ff_shuffle') ?? _shuffle;
    });
    await _safeInitAsync(() async {
      _nowPlaying =
          (await secureStorage.getString('ff_nowPlaying'))?.ref ?? _nowPlaying;
    });
    await _safeInitAsync(() async {
      _dailyViewCtrl = (await secureStorage.getStringList('ff_dailyViewCtrl'))
              ?.map((path) => path.ref)
              .toList() ??
          _dailyViewCtrl;
    });
    await _safeInitAsync(() async {
      _songviewCount =
          await secureStorage.getInt('ff_songviewCount') ?? _songviewCount;
    });
    await _safeInitAsync(() async {
      _todaysdate = await secureStorage.read(key: 'ff_todaysdate') != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (await secureStorage.getInt('ff_todaysdate'))!)
          : _todaysdate;
    });
    await _safeInitAsync(() async {
      _repeat1 = await secureStorage.getBool('ff_repeat1') ?? _repeat1;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  bool _search = true;
  bool get search => _search;
  set search(bool value) {
    _search = value;
  }

  bool _commentfeild = true;
  bool get commentfeild => _commentfeild;
  set commentfeild(bool value) {
    _commentfeild = value;
  }

  List<DocumentReference> _MyPlaylist = [];
  List<DocumentReference> get MyPlaylist => _MyPlaylist;
  set MyPlaylist(List<DocumentReference> value) {
    _MyPlaylist = value;
    secureStorage.setStringList(
        'ff_MyPlaylist', value.map((x) => x.path).toList());
  }

  void deleteMyPlaylist() {
    secureStorage.delete(key: 'ff_MyPlaylist');
  }

  void addToMyPlaylist(DocumentReference value) {
    MyPlaylist.add(value);
    secureStorage.setStringList(
        'ff_MyPlaylist', _MyPlaylist.map((x) => x.path).toList());
  }

  void removeFromMyPlaylist(DocumentReference value) {
    MyPlaylist.remove(value);
    secureStorage.setStringList(
        'ff_MyPlaylist', _MyPlaylist.map((x) => x.path).toList());
  }

  void removeAtIndexFromMyPlaylist(int index) {
    MyPlaylist.removeAt(index);
    secureStorage.setStringList(
        'ff_MyPlaylist', _MyPlaylist.map((x) => x.path).toList());
  }

  void updateMyPlaylistAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    MyPlaylist[index] = updateFn(_MyPlaylist[index]);
    secureStorage.setStringList(
        'ff_MyPlaylist', _MyPlaylist.map((x) => x.path).toList());
  }

  void insertAtIndexInMyPlaylist(int index, DocumentReference value) {
    MyPlaylist.insert(index, value);
    secureStorage.setStringList(
        'ff_MyPlaylist', _MyPlaylist.map((x) => x.path).toList());
  }

  String _monthlyPLN = 'PLN_wnbtalk0gkohc22';
  String get monthlyPLN => _monthlyPLN;
  set monthlyPLN(String value) {
    _monthlyPLN = value;
    secureStorage.setString('ff_monthlyPLN', value);
  }

  void deleteMonthlyPLN() {
    secureStorage.delete(key: 'ff_monthlyPLN');
  }

  String _yearlyPLN = 'PLN_ca9gcm51brbsut6';
  String get yearlyPLN => _yearlyPLN;
  set yearlyPLN(String value) {
    _yearlyPLN = value;
    secureStorage.setString('ff_yearlyPLN', value);
  }

  void deleteYearlyPLN() {
    secureStorage.delete(key: 'ff_yearlyPLN');
  }

  String _IMG1 = 'https://picsum.photos/seed/211/600';
  String get IMG1 => _IMG1;
  set IMG1(String value) {
    _IMG1 = value;
    secureStorage.setString('ff_IMG1', value);
  }

  void deleteIMG1() {
    secureStorage.delete(key: 'ff_IMG1');
  }

  String _IMG2 = 'https://picsum.photos/seed/218/600';
  String get IMG2 => _IMG2;
  set IMG2(String value) {
    _IMG2 = value;
    secureStorage.setString('ff_IMG2', value);
  }

  void deleteIMG2() {
    secureStorage.delete(key: 'ff_IMG2');
  }

  List<DocumentReference> _like = [];
  List<DocumentReference> get like => _like;
  set like(List<DocumentReference> value) {
    _like = value;
    secureStorage.setStringList('ff_like', value.map((x) => x.path).toList());
  }

  void deleteLike() {
    secureStorage.delete(key: 'ff_like');
  }

  void addToLike(DocumentReference value) {
    like.add(value);
    secureStorage.setStringList('ff_like', _like.map((x) => x.path).toList());
  }

  void removeFromLike(DocumentReference value) {
    like.remove(value);
    secureStorage.setStringList('ff_like', _like.map((x) => x.path).toList());
  }

  void removeAtIndexFromLike(int index) {
    like.removeAt(index);
    secureStorage.setStringList('ff_like', _like.map((x) => x.path).toList());
  }

  void updateLikeAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    like[index] = updateFn(_like[index]);
    secureStorage.setStringList('ff_like', _like.map((x) => x.path).toList());
  }

  void insertAtIndexInLike(int index, DocumentReference value) {
    like.insert(index, value);
    secureStorage.setStringList('ff_like', _like.map((x) => x.path).toList());
  }

  String _ref = '';
  String get ref => _ref;
  set ref(String value) {
    _ref = value;
  }

  bool _CURRENCY = false;
  bool get CURRENCY => _CURRENCY;
  set CURRENCY(bool value) {
    _CURRENCY = value;
    secureStorage.setBool('ff_CURRENCY', value);
  }

  void deleteCURRENCY() {
    secureStorage.delete(key: 'ff_CURRENCY');
  }

  String _appVER = 'V1.0';
  String get appVER => _appVER;
  set appVER(String value) {
    _appVER = value;
    secureStorage.setString('ff_appVER', value);
  }

  void deleteAppVER() {
    secureStorage.delete(key: 'ff_appVER');
  }

  int _playlistA = 0;
  int get playlistA => _playlistA;
  set playlistA(int value) {
    _playlistA = value;
  }

  String _url = '';
  String get url => _url;
  set url(String value) {
    _url = value;
  }

  bool _shuffle = false;
  bool get shuffle => _shuffle;
  set shuffle(bool value) {
    _shuffle = value;
    secureStorage.setBool('ff_shuffle', value);
  }

  void deleteShuffle() {
    secureStorage.delete(key: 'ff_shuffle');
  }

  int _set = 0;
  int get set => _set;
  set set(int value) {
    _set = value;
  }

  int _videoProgress = 0;
  int get videoProgress => _videoProgress;
  set videoProgress(int value) {
    _videoProgress = value;
  }

  bool _isVideoPlaying = false;
  bool get isVideoPlaying => _isVideoPlaying;
  set isVideoPlaying(bool value) {
    _isVideoPlaying = value;
  }

  DocumentReference? _nowPlaying =
      FirebaseFirestore.instance.doc('/ARTISTS/dfghjkl;');
  DocumentReference? get nowPlaying => _nowPlaying;
  set nowPlaying(DocumentReference? value) {
    _nowPlaying = value;
    value != null
        ? secureStorage.setString('ff_nowPlaying', value.path)
        : secureStorage.remove('ff_nowPlaying');
  }

  void deleteNowPlaying() {
    secureStorage.delete(key: 'ff_nowPlaying');
  }

  List<DocumentReference> _dailyViewCtrl = [];
  List<DocumentReference> get dailyViewCtrl => _dailyViewCtrl;
  set dailyViewCtrl(List<DocumentReference> value) {
    _dailyViewCtrl = value;
    secureStorage.setStringList(
        'ff_dailyViewCtrl', value.map((x) => x.path).toList());
  }

  void deleteDailyViewCtrl() {
    secureStorage.delete(key: 'ff_dailyViewCtrl');
  }

  void addToDailyViewCtrl(DocumentReference value) {
    dailyViewCtrl.add(value);
    secureStorage.setStringList(
        'ff_dailyViewCtrl', _dailyViewCtrl.map((x) => x.path).toList());
  }

  void removeFromDailyViewCtrl(DocumentReference value) {
    dailyViewCtrl.remove(value);
    secureStorage.setStringList(
        'ff_dailyViewCtrl', _dailyViewCtrl.map((x) => x.path).toList());
  }

  void removeAtIndexFromDailyViewCtrl(int index) {
    dailyViewCtrl.removeAt(index);
    secureStorage.setStringList(
        'ff_dailyViewCtrl', _dailyViewCtrl.map((x) => x.path).toList());
  }

  void updateDailyViewCtrlAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    dailyViewCtrl[index] = updateFn(_dailyViewCtrl[index]);
    secureStorage.setStringList(
        'ff_dailyViewCtrl', _dailyViewCtrl.map((x) => x.path).toList());
  }

  void insertAtIndexInDailyViewCtrl(int index, DocumentReference value) {
    dailyViewCtrl.insert(index, value);
    secureStorage.setStringList(
        'ff_dailyViewCtrl', _dailyViewCtrl.map((x) => x.path).toList());
  }

  int _songviewCount = 0;
  int get songviewCount => _songviewCount;
  set songviewCount(int value) {
    _songviewCount = value;
    secureStorage.setInt('ff_songviewCount', value);
  }

  void deleteSongviewCount() {
    secureStorage.delete(key: 'ff_songviewCount');
  }

  DateTime? _todaysdate = DateTime.fromMillisecondsSinceEpoch(1742410080000);
  DateTime? get todaysdate => _todaysdate;
  set todaysdate(DateTime? value) {
    _todaysdate = value;
    value != null
        ? secureStorage.setInt('ff_todaysdate', value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_todaysdate');
  }

  void deleteTodaysdate() {
    secureStorage.delete(key: 'ff_todaysdate');
  }

  bool _admin = false;
  bool get admin => _admin;
  set admin(bool value) {
    _admin = value;
  }

  bool _repeat1 = false;
  bool get repeat1 => _repeat1;
  set repeat1(bool value) {
    _repeat1 = value;
    secureStorage.setBool('ff_repeat1', value);
  }

  void deleteRepeat1() {
    secureStorage.delete(key: 'ff_repeat1');
  }

  final _allManager = StreamRequestManager<List<ArtistsRecord>>();
  Stream<List<ArtistsRecord>> all({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<ArtistsRecord>> Function() requestFn,
  }) =>
      _allManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAllCache() => _allManager.clear();
  void clearAllCacheKey(String? uniqueKey) =>
      _allManager.clearRequest(uniqueKey);

  final _recentManager = StreamRequestManager<List<ArtistsRecord>>();
  Stream<List<ArtistsRecord>> recent({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<ArtistsRecord>> Function() requestFn,
  }) =>
      _recentManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearRecentCache() => _recentManager.clear();
  void clearRecentCacheKey(String? uniqueKey) =>
      _recentManager.clearRequest(uniqueKey);

  final _priceManager = StreamRequestManager<List<PricesRecord>>();
  Stream<List<PricesRecord>> price({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<PricesRecord>> Function() requestFn,
  }) =>
      _priceManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearPriceCache() => _priceManager.clear();
  void clearPriceCacheKey(String? uniqueKey) =>
      _priceManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
