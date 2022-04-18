import '../models/posttime.dart';
import '../models/posttype.dart';
import '../models/dimensions.dart';

class InstaPost {
  final PostType? postType;
  final Dimensions? dimensions;
  final String? displayURL;
  final String? postUrl;
  final String? thumbnailUrl;
  final Dimensions? thumbnailDimensions;
  final PostTime videoDuration;

  InstaPost(
      {this.postType,
      this.postUrl,
      this.dimensions,
      this.displayURL,
      required this.videoDuration,
      this.thumbnailDimensions,
      this.thumbnailUrl});
}
