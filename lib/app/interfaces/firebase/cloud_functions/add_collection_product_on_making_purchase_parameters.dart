class AddCollectionProductOnMakingPurchaseParameters {
  const AddCollectionProductOnMakingPurchaseParameters({
    required this.productId,
    required this.purchaseId,
  });

  final String productId;
  final String purchaseId;

  Map<String, String> toMap() => {
        'product_id': productId,
        'purchase_id': purchaseId,
      };
}
