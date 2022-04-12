class AddCollectionProductOnMakingPurchaseParameters {
  const AddCollectionProductOnMakingPurchaseParameters({
    required this.productId,
    required this.paymentMethod,
    required this.purchasedAtAsIso8601,
    required this.vendorProductId,
  });

  final String productId;
  final String paymentMethod;
  final String purchasedAtAsIso8601;
  final String vendorProductId;

  Map<String, String> toMap() => {
        'product_id': productId,
        'payment_method': paymentMethod,
        'purchased_at': purchasedAtAsIso8601,
        'vendor_product_id': vendorProductId,
      };
}
