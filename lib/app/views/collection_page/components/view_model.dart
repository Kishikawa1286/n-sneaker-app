import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/view_model_change_notifier.dart';
import '../../../repositories/product_glb_file/product_glb_file.dart';
import '../../../repositories/product_glb_file/product_glb_file_repository.dart';

final collectionPageProductGridTileViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<
        CollectionPageProductGridTileViewModel, String>(
  (ref, productId) => CollectionPageProductGridTileViewModel(
    productId,
    ref.read(productGlbFileRepositoryProvider),
  ),
);

class CollectionPageProductGridTileViewModel extends ViewModelChangeNotifier {
  CollectionPageProductGridTileViewModel(
    this._productId,
    this._productGlbFileRepository,
  ) {
    _init();
  }

  final String _productId;

  final ProductGlbFileRepository _productGlbFileRepository;

  ProductGlbFileModel? _productGlbFile;

  ProductGlbFileModel? get productGlbFile => _productGlbFile;

  Future<void> _init() async {
    try {
      final fetched = await _productGlbFileRepository
          .fetchProductsGlbFilesForAr(_productId);
      if (fetched.isEmpty) {
        return;
      }
      _productGlbFile = fetched.first;
      await _productGlbFileRepository.setLastUsedGlbFileId(
        productId: fetched.first.productId,
        productGlbFileId: fetched.first.id,
      );
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
