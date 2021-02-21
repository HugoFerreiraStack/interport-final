class BannerPost {
  BannerPost({
    this.url,
    this.condominio,
  });

  final String url;
  final String condominio;

  factory BannerPost.fromJson(Map<String, dynamic> json) => BannerPost(
        url: json["url"],
        condominio: json["condominio"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "condominio": condominio,
      };
}
