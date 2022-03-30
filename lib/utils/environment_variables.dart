// ignore_for_file: do_not_use_environment

/// Firestoreの'accounts'コレクションのバージョン
const String firestoreAccountsCollectionVersion = 'v1';

/// Firestoreの'products'コレクションのバージョン
const String firestoreProductsCollectionVersion = 'v1';

/// Firestoreの'products/{doc}/product_glb_files'コレクションのバージョン
const String firestoreProductGlbFilesVersion = 'v1';

/// Firestoreの'collection_products'コレクションのバージョン
const String firestoreCollectionProductsVersion = 'v1';

/// AlgoliaのApplication ID
const String algoliaApplicationId = 'EHWBNFTR66';

/// AlgoliaのAPIキー
const String algoliaApikey = '1b42b72bcb9325502450036567af273d';

/// String.fromEnvironment('env') の値
const String flavor = String.fromEnvironment('FLAVOR');

const isEnabledAnalytics = !(String.fromEnvironment('ANALYTICS') == 'false' ||
    String.fromEnvironment('ANALYTICS') == 'no' ||
    String.fromEnvironment('ANALYTICS') == 'disable');

/// 特定商取引法
const notionBasedOnSpecifiedCommercialTransactionsActUrl = '';

/// プライバシーポリシー
const privacyPolicyUrl = '';

/// 利用規約
const termsOfServiceUrl = '';

/// コンタクト
const contactUrl = '';

/// コンタクト
const accountDeletionRequestUrl = '';
