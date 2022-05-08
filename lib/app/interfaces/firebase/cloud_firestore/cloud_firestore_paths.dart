import '../../../../utils/environment_variables.dart';

const String _accountDomain = 'accounts';

const String _accountsCollectionPath =
    '${_accountDomain}_$firestoreAccountsCollectionVersion';

String accountDocumentPath(String accountId) =>
    '$_accountsCollectionPath/$accountId/';

// products
const String _productDomain = 'products';

const String productsCollectionPath =
    '${_productDomain}_$firestoreProductsCollectionVersion';

String productDocumentPath(String productId) =>
    '$productsCollectionPath/$productId';

const String _productGlbFileDomain = 'product_glb_files';

String productGlbFilesCollectionPath(String productId) =>
    '${productDocumentPath(productId)}/${_productGlbFileDomain}_$firestoreProductGlbFilesVersion';

String productGlbFileDocumentPath(String productId, String glbFileId) =>
    '${productGlbFilesCollectionPath(productId)}/$glbFileId';

const String _collectionProductDomain = 'collection_products';

String collectionProductsCollectionPath =
    '${_collectionProductDomain}_$firestoreCollectionProductsVersion';

String collectionProductDocumentPath(String productCollectionId) =>
    '$collectionProductsCollectionPath/$productCollectionId';

const String _marketPageTabsDomain = 'market_page_tabs';

const String marketPageTabsCollectionPath =
    '${_marketPageTabsDomain}_$firestoreMarketPageTabsVersion';

const String _launchConfigsDomain = 'launch_configs';

const String launchConfigsCollectionPath =
    '${_launchConfigsDomain}_$firestoreLaunchConfigsVersion';

const String _signInRewardsDomain = 'sign_in_rewards';

const String signInRewardsCollectionPath =
    '${_signInRewardsDomain}_$firestoreSignInRewardsVersion';

const String _galleryPostsDomain = 'gallery_posts';

const String galleryPostsCollectionPath =
    '${_galleryPostsDomain}_$firestoreGalleryPostsVersion';

String galleryPostDocumentPath(String galleryPostId) =>
    '$galleryPostsCollectionPath/$galleryPostId';
