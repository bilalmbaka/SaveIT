import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/dimensions.dart';
import '../../models/instapost.dart';
import '../../models/posttime.dart';
import '../../models/posttype.dart';

Future<List<InstaPost>> getPost({required String url}) async {
  PostTime secToMin(double time) {
    ///if time is 0 return value is 0.0s
    if (time == 0 || time == null) {
      return PostTime(duration: "0.0", unit: "S");
    }
    if (time < 60) {
      return PostTime(duration: time.toStringAsFixed(2), unit: "S");
    } else if (time >= 3600) {
      double sanp = time / 3600;
      return PostTime(duration: sanp.toStringAsFixed(2), unit: "H");
    } else if (time >= 60) {
      double sanp = time / 60;
      return PostTime(duration: sanp.toStringAsFixed(2), unit: "M");
    }

    ///return[videoDuration]
    return PostTime(duration: "0.0", unit: "S");
  }

  List<InstaPost> instaPost = [];
  List listUrl = url.split("/");

  //split and rejoin the url, if not it gives an error
  String postUrl = listUrl[0] +
      "//" +
      listUrl[2] +
      "/" +
      listUrl[3] +
      "/" +
      listUrl[4] +
      "/" +
      listUrl[6];
  final res = await http.get(Uri.parse(postUrl));
  var body = res.body;

  if (body.startsWith('<!DOCTYPE html>')) {
    print(
        'HTML was returned instead of JSON\ni.e.You might have surpassed Instagram\'s no. of requests/hour limit');
    throw Exception(
        'HTML was returned instead of JSON\ni.e.You might have surpassed Instagram\'s no. of requests/hour limit');
  }

  var post = json.decode(body)["graphql"]
      ["shortcode_media"]; //holds info about the post that we can extract

  if (post["__typename"] == "GraphImage" ||
      post["__typename"] == "GraphVideo") {
    var postType = post["__typename"] == "GraphImage"
        ? PostType.GraphImage
        : PostType.GraphVideo;

    instaPost = [];
    instaPost.add(InstaPost(
      postUrl: postUrl,
      videoDuration: postType == PostType.GraphVideo
          ? secToMin(post["video_duration"])
          : secToMin(0.0),
      thumbnailDimensions: Dimensions(
        height: post["display_resources"][0]["config_height"],
        width: post["display_resources"][0]["config_width"],
      ),
      dimensions: Dimensions(
        height: post["dimensions"]["height"],
        width: post["dimensions"]["width"],
      ),
      thumbnailUrl: post["display_resources"][0]["src"],
      displayURL: postType == PostType.GraphVideo
          ? post["video_url"]
          : post["display_url"],
      postType: postType,
    ));
    // return instaPost;
  } else if (post["__typename"] == "GraphSidecar") {
    instaPost = [];
    final snap = post["edge_sidecar_to_children"]["edges"];
    for (int i = 0; i < snap.length.toInt(); i++) {
      final postType =
          snap[i]["node"]["__typename"].toString().contains("GraphImage")
              ? PostType.GraphImage
              : PostType.GraphVideo;
      print(postType);
      print("\n\n");
      instaPost.add(InstaPost(
        postUrl: postUrl,
        videoDuration: postType == PostType.GraphVideo
            ? secToMin(snap[i]["node"]["video_duration"])
            : secToMin(0.0),
        thumbnailDimensions: Dimensions(
          height: snap[i]["node"]["display_resources"][0]["config_height"],
          width: snap[i]["node"]["display_resources"][0]["config_width"],
        ),
        dimensions: Dimensions(
          height: snap[i]["node"]["dimensions"]["height"],
          width: snap[i]["node"]["dimensions"]["width"],
        ),
        thumbnailUrl: snap[i]["node"]["display_resources"][0]["src"],
        displayURL: postType == PostType.GraphImage
            ? snap[i]["node"]["display_url"]
            : snap[i]["node"]["video_url"],
        postType: postType,
      ));
    }
  }

  return instaPost;
}
