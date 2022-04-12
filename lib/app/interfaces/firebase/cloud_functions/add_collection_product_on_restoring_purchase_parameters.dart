class AddCollectionProductOnRestoringPurchaseParameters {
  const AddCollectionProductOnRestoringPurchaseParameters({
    required this.productId,
  });

  final String productId;

  Map<String, String> toMap() => {'product_id': productId};
}
