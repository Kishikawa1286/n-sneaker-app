class AddCollectionProductParameters {
  const AddCollectionProductParameters({
    required this.productId,
    required this.paymentMethod,
    required this.receipt,
  });

  final String productId;
  final String paymentMethod;
  final String receipt;

  Map<String, String> toMap() => {
        'product_id': productId,
        'payment_method': paymentMethod,
        'receipt': receipt,
      };
}
