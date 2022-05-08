// ignore_for_file: do_not_use_environment

/* アプリ内 */

/// コレクションページの背景画像パス
const String _collectionPageBackgroundImageDirectory =
    'assets/collection_background';
const List<String> collectionPageBackgroundImagePaths = [
  '$_collectionPageBackgroundImageDirectory/bg1.jpg',
  '$_collectionPageBackgroundImageDirectory/bg2.jpg',
  '$_collectionPageBackgroundImageDirectory/bg3.jpg',
  '$_collectionPageBackgroundImageDirectory/bg4.jpg',
  '$_collectionPageBackgroundImageDirectory/bg5.jpg',
  '$_collectionPageBackgroundImageDirectory/bg6.jpg',
  '$_collectionPageBackgroundImageDirectory/bg7.jpg',
  '$_collectionPageBackgroundImageDirectory/bg8.jpg',
  '$_collectionPageBackgroundImageDirectory/bg9.jpg',
  '$_collectionPageBackgroundImageDirectory/bg10.jpg',
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

/// Firestoreの'launch_configs'コレクションのバージョン
const String firestoreSignInRewardsVersion = 'v1';

/// Firestoreの'launch_configs'コレクションのバージョン
const String firestoreGalleryPostsVersion = 'v1';

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
const notionBasedOnSpecifiedCommercialTransactionsActUrl =
    'https://successful-whistle-5b2.notion.site/5d789bc257d74ef8a8fe112c57011443';

/// プライバシーポリシー
const privacyPolicyUrl =
    'https://successful-whistle-5b2.notion.site/6527df805f454002add1786d3ea78f4e';

/// 利用規約
const termsOfServiceUrl =
    'https://successful-whistle-5b2.notion.site/N-Sneaker-45038a37fc6d4aca808623255260c6a1';

/// コンタクト
const contactUrl = 'https://notionforms.io/forms/n-sneaker';

/// アカウント削除
const accountDeletionRequestUrl = 'https://notionforms.io/forms/n-sneaker-1';

/// App Store
const appStoreUrl = '';

/// Play Store
const playStoreUrl = '';
