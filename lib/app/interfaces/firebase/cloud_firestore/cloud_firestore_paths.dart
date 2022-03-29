import '../../../../utils/environment_variables.dart';

const String _accountsCollectionVersion = firestoreAccountsCollectionVersion;

const String _productsCollectionVersion = firestoreProductsCollectionVersion;

const String _productGlbFilesCollectionVersion =
    firestoreProductGlbFilesVersion;

const String _collectionProductsCollectionVersion =
    firestoreCollectionProductsVersion;

const String _accountDomain = 'accounts';

const String _accountsCollectionPath =
    '${_accountDomain}_$_accountsCollectionVersion';

String accountDocumentPath(String accountId) =>
    '$_accountsCollectionPath/$accountId/';

// products
const String _productDomain = 'products';

const String productsCollectionPath =
    '${_productDomain}_$_productsCollectionVersion';

String productDocumentPath(String productId) =>
    '$productsCollectionPath/$productId';

const String _productGlbFileDomain = 'product_glb_files';

String productGlbFilesCollectionPath(String productId) =>
    '${productDocumentPath(productId)}/${_productGlbFileDomain}_$_productGlbFilesCollectionVersion';

String productGlbFileDocumentPath(String productId, String glbFileId) =>
    '${productGlbFilesCollectionPath(productId)}/$glbFileId';

const String _collectionProductDomain = 'collection_products';

String collectionProductsCollectionPath =
    '${_collectionProductDomain}_$_collectionProductsCollectionVersion';

String collectionProductDocumentPath(String productCollectionId) =>
    '$collectionProductsCollectionPath/$productCollectionId';
