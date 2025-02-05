
class Screenshot {
  final String? aspect;
  final String? imagePath;
  final int? height;
  final int? width;
  final String? countryCode;
  final double? voteAverage;
  final int? voteCount;

  Screenshot({
    this.aspect,
    this.imagePath,
    this.height,
    this.width,
    this.countryCode,
    this.voteAverage,
    this.voteCount,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      aspect: json['aspect_ratio']?.toString(),
      imagePath: json['file_path'],
      height: json['height'],
      width: json['width'],
      countryCode: json['iso_639_1'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
    );
  }

  @override
  List<Object?> get props => [
        aspect,
        imagePath,
        height,
        width,
        countryCode,
        voteAverage,
        voteCount,
      ];
}

class MovieImageDetails {
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  const MovieImageDetails({
    this.backdrops = const [],
    this.posters = const [],
  });

  factory MovieImageDetails.fromJson(Map<String, dynamic> result) {
    return MovieImageDetails(
      backdrops: (result['backdrops'] as List<dynamic>?)
              ?.map((b) => Screenshot.fromJson(b))
              .toList() ??
          [],
      posters: (result['posters'] as List<dynamic>?)
              ?.map((p) => Screenshot.fromJson(p))
              .toList() ??
          [],
    );
  }

  @override
  List<Object> get props => [backdrops, posters];
}

const mockMovieImageDetailsJson = {
  "backdrops": [
    {
      "aspect_ratio": 1.78,
      "file_path": "/path/to/screenshot1.jpg",
      "height": 720,
      "width": 1280,
      "iso_639_1": "en",
      "vote_average": 8.5,
      "vote_count": 1000,
    },
    {
      "aspect_ratio": 1.78,
      "file_path": "/path/to/screenshot2.jpg",
      "height": 720,
      "width": 1280,
      "iso_639_1": "en",
      "vote_average": 9.0,
      "vote_count": 1500,
    }
  ],
  "posters": []
};