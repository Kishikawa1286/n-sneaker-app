import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../utils/view_model_change_notifier.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';

final arGlbFileSelectorModalBottomSheetViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<
        ArGlbFileSelectorModalBottomSheetViewModel, String>(
  (ref, productId) => ArGlbFileSelectorModalBottomSheetViewModel(
    productId,
    ref.read(productGlbFileRepositoryProvider),
  ),
);

class ArGlbFileSelectorModalBottomSheetViewModel
    extends ViewModelChangeNotifier {
  ArGlbFileSelectorModalBottomSheetViewModel(
    this._productId,
    this._productGlbFileRepository,
  ) {
    _fetchProductGlbFiles();
  }

  final String _productId;
  final ProductGlbFileRepository _productGlbFileRepository;

  List<ProductGlbFileModel>? _glbFileModels;

  List<ProductGlbFileModel>? get glbFileModels => _glbFileModels;

  Future<void> _fetchProductGlbFiles() async {
    try {
      _glbFileModels = await _productGlbFileRepository
          .fetchProductsGlbFilesForAr(_productId);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
