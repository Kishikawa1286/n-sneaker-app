import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../utils/view_model_change_notifier.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';

final glbFileSelectorModalBottomSheetViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<
        GlbFileSelectorModalBottomSheetViewModel, String>(
  (ref, productId) => GlbFileSelectorModalBottomSheetViewModel(
    productId,
    ref.read(productGlbFileRepositoryProvider),
  ),
);

class GlbFileSelectorModalBottomSheetViewModel extends ViewModelChangeNotifier {
  GlbFileSelectorModalBottomSheetViewModel(
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
          .fetchProductsGlbFilesForViewer(_productId);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
