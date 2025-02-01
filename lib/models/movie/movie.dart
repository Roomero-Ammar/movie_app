class Movie {
  Dates? dates;
  int? page;
  int? totalPages;
  int? totalResults;

  // خصائص الفيلم الأساسية
  bool? adult;
  String? backdropPath;
 // List<Genre>? genres;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  // خصائص إضافية
  YoutubeVideo? trailer; // معرف الفيديو من اليوتيوب
  MovieImage? movieImage; // صورة الفيلم
  List<Cast>? cast; // قائمة الممثلين

  Movie({
    this.dates,
    this.page,
    this.totalPages,
    this.totalResults,
    this.adult,
    this.backdropPath,
   // this.genres,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.trailer,
    this.movieImage,
    this.cast,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      dates: json['dates'] != null ? Dates.fromJson(json['dates']) : null,
      page: json['page'],
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
    //  genres: (json['genres'] as List?)?.map((g) => Genre.fromJson(g)).toList(),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      video: json['video'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      trailer: json['trailer'] != null ? YoutubeVideo.fromJson(json['trailer']) : null,
      movieImage: json['movie_image'] != null ? MovieImage.fromJson(json['movie_image']) : null,
      cast: (json['cast'] as List?)?.map((c) => Cast.fromJson(c)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dates': dates?.toJson(),
      'page': page,
      'total_pages': totalPages,
      'total_results': totalResults,
      'adult': adult,
      'backdrop_path': backdropPath,
     // 'genres': genres?.map((g) => g.toJson()).toList(),
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'trailer': trailer?.toJson(),
      'movie_image': movieImage?.toJson(),
      'cast': cast?.map((c) => c.toJson()).toList(),
    };
  }
}


//
class Dates {
  String? maximum;
  String? minimum;

  Dates({this.maximum, this.minimum});

  Dates.fromJson(Map<String, dynamic> json) {
    maximum = json['maximum'];
    minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    return {
      'maximum': maximum,
      'minimum': minimum,
    };
  }
}

//
class Genre {
  int? id;
  String? name;

  Genre({this.id, this.name});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
//
class Person {
  int? id;
  String? name;

  Person({this.id, this.name});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
//
class Results {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  
  // خصائص إضافية
  String? trailerId; // لإضافة معرف الفيديو
  String? movieImage; // لإضافة صورة الفيلم

  Results({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.trailerId,
    this.movieImage,
  });

  Results.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = List<int>.from(json['genre_ids']);
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'trailer_id': trailerId, // إضافة معرف الفيديو
      'movie_image': movieImage, // إضافة صورة الفيلم
    };
  }
}

// new 3 models

class YoutubeVideo {
  final String key;
  final String name;
  
  YoutubeVideo({required this.key, required this.name});
  
  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    return YoutubeVideo(
      key: json['key'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
    };
  }
}
//
class MovieImage {
  final String filePath;

  MovieImage({required this.filePath});

  factory MovieImage.fromJson(Map<String, dynamic> json) {
    return MovieImage(
      filePath: json['file_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_path': filePath,
    };
  }
}
//
class Cast {
  final int id;
  final String name;
  final String profilePath;

  Cast({required this.id, required this.name, required this.profilePath});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
    };
  }
}

