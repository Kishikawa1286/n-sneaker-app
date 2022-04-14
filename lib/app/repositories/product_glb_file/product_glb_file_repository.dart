import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/cloud_functions/cloud_functions_interface.dart';
import '../../interfaces/firebase/cloud_functions/generate_glb_file_download_url_parameters.dart';
import '../../interfaces/local_storage/local_storage_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_interface.dart';
import '../../interfaces/shared_preferences/shared_preferences_key.dart';
import 'product_glb_file.dart';

final productGlbFileRepositoryProvider = Provider<ProductGlbFileRepository>(
  (ref) => ProductGlbFileRepository(
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(cloudFunctionsInterfaceProvider),
    ref.read(localStorageInterfaceProvider),
    ref.read(sharedPreferencesInterfaceProvider),
  ),
);

class ProductGlbFileRepository {
  const ProductGlbFileRepository(
    this._cloudFirestoreInterface,
    this._cloudFunctionsInterface,
    this._localStorageInterface,
    this._sharedPreferencesInterface,
  );

  final CloudFirestoreInterface _cloudFirestoreInterface;
  final CloudFunctionsInterface _cloudFunctionsInterface;
  final LocalStorageInterface _localStorageInterface;
  final SharedPreferencesInterface _sharedPreferencesInterface;

  Future<String> _filePath({
    required String productId,
    required String productGlbFileId,
  }) async {
    if (Platform.isIOS) {
      final directory = await _localStorageInterface.getLibraryDirectory();
      return '${directory.path}/${productId}_$productGlbFileId.glb';
    }
    final directory =
        await _localStorageInterface.getApplicationDocumentsDirectory();
    return '${directory.path}/${productId}_$productGlbFileId.glb';
  }

  Future<ProductGlbFileModel> _convertDocumentSnapshotToProductGlbFileModel(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    final id = data['id'] as String?;
    final productId = data['product_id'] as String?;
    if (id == null || productId == null) {
      throw Exception(
        'DocumentSnapshot does not have required id data.',
      );
    }
    final filePath = await _filePath(
      productId: productId,
      productGlbFileId: id,
    );
    final fileExists = _localStorageInterface.fileExists(filePath);
    return ProductGlbFileModel.fromDocumentSnapshotAndFileData(
      snapshot: doc,
      filePath: filePath,
      fileExists: fileExists,
    );
  }

  Future<List<ProductGlbFileModel>>
      _convertDocumentSnapshotListToProductGlbFileModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) async =>
          (await Future.wait(
            docs.map((documentSnapshot) async {
              try {
                final productGlbFileModel =
                    await _convertDocumentSnapshotToProductGlbFileModel(
                  documentSnapshot,
                );
                return productGlbFileModel;
              } on Exception catch (e) {
                print(e);
                return null;
              }
            }).toList(),
          ))
              .whereType<ProductGlbFileModel>()
              .toList();

  Future<ProductGlbFileModel> fetchProductsGlbFileById({
    required String productId,
    required String productGlbFileId,
  }) async {
    final snapshot = await _cloudFirestoreInterface.fetchDocumentSnapshot(
      documentPath: productGlbFileDocumentPath(productId, productGlbFileId),
    );
    return _convertDocumentSnapshotToProductGlbFileModel(snapshot);
  }

  Future<List<ProductGlbFileModel>> fetchProductsGlbFilesForViewer(
    String productId, {
    int limit = 16,
    ProductGlbFileModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: productGlbFilesCollectionPath(productId),
        queryBuilder: (query) => query
            .where('available_for_viewer', isEqualTo: true)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToProductGlbFileModelList(
        snapshot.docs,
      );
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: productGlbFilesCollectionPath(productId),
      queryBuilder: (query) => query
          .where('available_for_viewer', isEqualTo: true)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToProductGlbFileModelList(snapshot.docs);
  }

  Future<List<ProductGlbFileModel>> fetchProductsGlbFilesForAr(
    String productId, {
    int limit = 16,
    ProductGlbFileModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: productGlbFilesCollectionPath(productId),
        queryBuilder: (query) => query
            .where('available_for_ar', isEqualTo: true)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToProductGlbFileModelList(
        snapshot.docs,
      );
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: productGlbFilesCollectionPath(productId),
      queryBuilder: (query) => query
          .where('available_for_ar', isEqualTo: true)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToProductGlbFileModelList(snapshot.docs);
  }

  Future<http.StreamedResponse> requestDownload(String url) {
    final httpClient = http.Client();
    final request = http.Request('GET', Uri.parse(url));
    final response = httpClient.send(request);
    return response;
  }

  Future<void> writeDownloadedFile({
    required String productId,
    required String productGlbFileId,
    required int contentLength,
    required List<List<int>> chunks,
  }) async {
    final file = File(
      await _filePath(
        productId: productId,
        productGlbFileId: productGlbFileId,
      ),
    );
    final bytes = Uint8List(contentLength);
    var offset = 0;
    chunks.forEach((chunk) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    });
    await file.writeAsBytes(bytes);
  }

  Future<String> generateGlbFileDownloadUrl({
    required String productId,
    required String productGlbFileId,
  }) async {
    final params = GenerateGlbFileDownloadUrlParameters(
      productId: productId,
      productGlbFileId: productGlbFileId,
    );
    final result =
        await _cloudFunctionsInterface.generateGlbFileDownloadUrl(params);
    final url = result.data as String;
    if (url == 'failed') {
      throw Exception('failed to generate signed url.');
    }
    return url;
  }

  // if not already set, return empty list
  Future<List<String>> getLastUsedGlbFileId() async {
    final ids = await _sharedPreferencesInterface
        .getString(SharedPreferencesKey.lastUsedGlbFileId);
    if (ids == null) {
      return [];
    }
    return ids.split(',');
  }

  Future<void> setLastUsedGlbFileId({
    required String productId,
    required String productGlbFileId,
  }) async {
    final ids = '$productId,$productGlbFileId';
    await _sharedPreferencesInterface.setString(
      key: SharedPreferencesKey.lastUsedGlbFileId,
      value: ids,
    );
  }

  Future<void> removeLastUsedGlbFileId() => _sharedPreferencesInterface
      .remove(SharedPreferencesKey.lastUsedGlbFileId);
}
