import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';

final glbFileViewerPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<GlbFileViewerPageViewModel, String>(
  (ref, idsAsString) {
    // ids is '$productId, $productGlbFileId'
    final ids = idsAsString.split(', ').toList();
    return GlbFileViewerPageViewModel(
      ids[0],
      ids[1],
      ref.read(productGlbFileRepositoryProvider),
    );
  },
);

class GlbFileViewerPageViewModel extends ViewModelChangeNotifier {
  GlbFileViewerPageViewModel(
    this._productId,
    this._productGlbFileId,
    this._productGlbFileRepository,
  ) {
    _init();
  }

  final String _productId;
  final String _productGlbFileId;
  final ProductGlbFileRepository _productGlbFileRepository;

  bool _initialized = false;
  late ProductGlbFileModel _glbFileModel;
  late bool _fileExists;
  double _downloadProgress = 0;

  bool get initialized => _initialized;
  ProductGlbFileModel get glbFileModel => _glbFileModel;
  bool get fileExists => _fileExists;
  double get downloadProgress => _downloadProgress;

  bool _downloading = false;
  final List<List<int>> _chunks = [];
  int _downloaded = 0;

  Future<void> _init() async {
    try {
      await _fetchProductGlbFile();
      _initialized = true;
      notifyListeners();

      if (!_fileExists) {
        await _download();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> _fetchProductGlbFile() async {
    _glbFileModel = await _productGlbFileRepository.fetchProductsGlbFileById(
      productId: _productId,
      productGlbFileId: _productGlbFileId,
    );
    _fileExists = _glbFileModel.fileExists;
  }

  Future<void> _download() async {
    // if already downloading, return
    if (_downloading) {
      return;
    }

    try {
      _downloading = true;

      final url = await _productGlbFileRepository.generateGlbFileDownloadUrl(
        productId: _productId,
        productGlbFileId: _productGlbFileId,
      );

      _productGlbFileRepository.requestDownload(url).asStream().listen((r) {
        final contentLength = r.contentLength ?? 0;
        r.stream.listen(
          (chunk) {
            _chunks.add(chunk);
            _downloaded += chunk.length;
            // prevent zero division
            _downloadProgress =
                contentLength != 0 ? _downloaded / contentLength : 0;
            notifyListeners();
          },
          onDone: () async {
            await _productGlbFileRepository.writeDownloadedFile(
              productId: _productId,
              productGlbFileId: _glbFileModel.id,
              contentLength: contentLength,
              chunks: _chunks,
            );
            _fileExists = true;
            _downloading = false;
            notifyListeners();
          },
        );
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
