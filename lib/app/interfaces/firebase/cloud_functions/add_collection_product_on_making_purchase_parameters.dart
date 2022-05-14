class AddCollectionProductOnMakingPurchaseParameters {
  const AddCollectionProductOnMakingPurchaseParameters({
    required this.productId,
    required this.vendorTransactionId,
  });

  final String productId;
  final String vendorTransactionId;

  Map<String, String> toMap() => {
        'product_id': productId,
        'vendor_transaction_id': vendorTransactionId,
      };
}
