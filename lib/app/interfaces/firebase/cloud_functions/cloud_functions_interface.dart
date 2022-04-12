import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'add_collection_product_on_making_purchase_parameters.dart';
import 'add_collection_product_on_restoring_purchase_parameters.dart';
import 'cloud_functions_names.dart';
import 'generate_glb_file_download_url_parameters.dart';

final cloudFunctionsInterfaceProvider =
    Provider<CloudFunctionsInterface>((ref) => CloudFunctionsInterface());

class CloudFunctionsInterface {
  CloudFunctionsInterface();

  final _firebaseFunctions =
      FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  Future<dynamic> _call(
    String functionName, {
    HttpsCallableOptions? options,
    Map<String, dynamic>? parameters,
  }) =>
      _firebaseFunctions
          .httpsCallable(functionName, options: options)
          .call<dynamic>(parameters);

  Future<dynamic> createAccount() => _call(CloudFunctionsNames.createAccount);

  Future<HttpsCallableResult<dynamic>> addCollectionProductOnMakingPurchase(
    AddCollectionProductOnMakingPurchaseParameters params,
  ) =>
      _call(
        CloudFunctionsNames.addCollectionProductOnMakingPurchase,
        parameters: params.toMap(),
      ) as Future<HttpsCallableResult<dynamic>>;

  Future<HttpsCallableResult<dynamic>> addCollectionProductOnRestoringPurchase(
    AddCollectionProductOnRestoringPurchaseParameters params,
  ) =>
      _call(
        CloudFunctionsNames.addCollectionProductOnRestoringPurchase,
        parameters: params.toMap(),
      ) as Future<HttpsCallableResult<dynamic>>;

  Future<HttpsCallableResult<dynamic>> generateGlbFileDownloadUrl(
    GenerateGlbFileDownloadUrlParameters params,
  ) =>
      _call(
        CloudFunctionsNames.gemerateGlbFileDownloadUrl,
        parameters: params.toMap(),
      ) as Future<HttpsCallableResult<dynamic>>;
}
