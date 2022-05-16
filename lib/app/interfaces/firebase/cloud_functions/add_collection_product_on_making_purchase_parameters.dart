class AddCollectionProductOnMakingPurchaseParameters {
  const AddCollectionProductOnMakingPurchaseParameters({
    required this.productId,
    required this.revenuecatTransactionId,
  });

  final String productId;
  final String revenuecatTransactionId;

  Map<String, String> toMap() => {
        'product_id': productId,
        'revenuecat_transaction_id': revenuecatTransactionId,
      };
}
