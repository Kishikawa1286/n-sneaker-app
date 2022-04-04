// ignore_for_file: do_not_use_environment

/* アプリ内 */

/// コレクションページの背景画像パス
const String _collectionPageBackgroundImageDirectory =
    'assets/collection_background';
const List<String> collectionPageBackgroundImagePaths = [
  '$_collectionPageBackgroundImageDirectory/bg1.jpg',
  '$_collectionPageBackgroundImageDirectory/bg2.jpg',
  '$_collectionPageBackgroundImageDirectory/bg3.jpg',
];

/* Firestore */

/// Firestoreの'accounts'コレクションのバージョン
const String firestoreAccountsCollectionVersion = 'v1';

/// Firestoreの'products'コレクションのバージョン
const String firestoreProductsCollectionVersion = 'v1';

/// Firestoreの'products/{doc}/product_glb_files'コレクションのバージョン
const String firestoreProductGlbFilesVersion = 'v1';

/// Firestoreの'collection_products'コレクションのバージョン
const String firestoreCollectionProductsVersion = 'v1';

/// Firestoreの'market_page_tabs'コレクションのバージョン
const String firestoreMarketPageTabsVersion = 'v1';

/// Firestoreの'launch_configs'コレクションのバージョン
const String firestoreLaunchConfigsVersion = 'v1';

/* Algolia */

/// AlgoliaのApplication ID
const String algoliaApplicationId = 'EHWBNFTR66';

/// AlgoliaのAPIキー
const String algoliaApikey = '1b42b72bcb9325502450036567af273d';

/* dart-define */

/// String.fromEnvironment('env') の値
const String flavor = String.fromEnvironment('FLAVOR');

/// Firebase Analyticsを停止
const isEnabledAnalytics = !(String.fromEnvironment('ANALYTICS') == 'false' ||
    String.fromEnvironment('ANALYTICS') == 'no' ||
    String.fromEnvironment('ANALYTICS') == 'disable');

/* 外部リンク */

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

/// App Store
const appStoreUrl = '';

/// Play Store
const playStoreUrl = '';
