String galleryPostImagesFolderPath(String accountId, String galleryPostId) =>
    'gallery_post_images/$accountId/$galleryPostId';

String galleryPostImagePath(
  String accountId,
  String galleryPostId,
  String fileName,
) =>
    '${galleryPostImagesFolderPath(accountId, galleryPostId)}/$fileName';
