class Video {
  Video({
    required this.id,
    required this.author,
    required this.mid,
    required this.typeName,
    required this.url,
    required this.title,
    required this.description,
    required this.pic,
    required this.playCount,
    required this.pubDate,
    required this.duration,
    required this.uPic,
    required this.playLike,
    required this.playStar,
  });

  int id;
  String author;
  int mid;
  String typeName;
  String url;
  String title;
  String description;
  String pic;
  int playCount;
  int pubDate;
  String duration;
  String uPic;
  int playLike;
  int playStar;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        author: json["author"],
        mid: json["mid"],
        typeName: json["typename"] ?? '',
        url: json["arcurl"].toString().replaceAll('http', 'https'),
        title: json["title"]
            .toString()
            .replaceAll('<em class="keyword">', '')
            .replaceAll('&quot', '')
            .replaceAll('</em>', ''),
        description: json["description"],
        pic: 'https:' + json["pic"].toString(),
        playCount: json["play"],
        pubDate: json["pubdate"],
        duration: json["duration"],
        uPic: json["upic"],
        playLike: json["like"],
        playStar: json["favorites"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "mid": mid,
        "name": typeName,
        "arcurl": url,
        "title": title,
        "description": description,
        "pic": pic,
        "play": playCount,
        "pubdate": pubDate,
        "duration": duration,
        "upic": uPic,
        "like": playLike,
        "favourites": playStar,
      };
}

class UGCSection {
  UGCSection({
    required this.id,
    required this.author,
    required this.mid,
    required this.typeName,
    required this.url,
    required this.title,
    required this.description,
    required this.pic,
    required this.playCount,
    required this.pubDate,
    required this.duration,
    required this.uPic,
    required this.playLike,
    required this.playStar,
    required this.bvid,
  });

  int id;
  String author;
  int mid;
  String typeName;
  String url;
  String title;
  String description;
  String pic;
  int playCount;
  int pubDate;
  String duration;
  String uPic;
  int playLike;
  int playStar;
  String bvid;

  factory UGCSection.fromJson(Map<String, dynamic> json) => UGCSection(
        id: json["id"],
        author: json["author"],
        mid: json["mid"],
        typeName: json["typename"] ?? '',
        url: json["arcurl"].toString().replaceAll('http', 'https'),
        title: json["title"]
            .toString()
            .replaceAll('<em class="keyword">', '')
            .replaceAll('&quot', '')
            .replaceAll('</em>', ''),
        description: json["description"],
        pic: 'https:' + json["pic"].toString(),
        playCount: json["play"],
        pubDate: json["pubdate"],
        duration: json["duration"],
        uPic: json["upic"],
        playLike: json["like"],
        playStar: json["favorites"] ?? 0,
        bvid: json["bvid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "mid": mid,
        "name": typeName,
        "arcurl": url,
        "title": title,
        "description": description,
        "pic": pic,
        "play": playCount,
        "pubdate": pubDate,
        "duration": duration,
        "upic": uPic,
        "like": playLike,
        "favourites": playStar,
      };
}

class Episode {
  Episode({
    required this.id,
    required this.aid,
    required this.bvid,
    required this.cid,
    required this.title,
    required this.pic,
    required this.pubDate,
    required this.duration,
    required this.view,
    required this.danmaku,
    required this.reply,
    required this.fav,
    required this.coin,
    required this.share,
    required this.like,
  });

  int id;
  int aid;
  String bvid;
  int cid;
  String title;
  String pic;
  int pubDate;
  int duration;
  int view;
  int danmaku;
  int reply;
  int fav;
  int coin;
  int share;
  int like;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json["id"],
        aid: json["aid"],
        bvid: json["bvid"],
        cid: json["cid"],
        title: json["title"]
            .toString()
            .replaceAll('<em class="keyword">', '')
            .replaceAll('&quot', '')
            .replaceAll('</em>', ''),
        pic: json["arc"]["pic"].toString(),
        pubDate: json["arc"]["pubdate"],
        duration: json["arc"]["duration"],
        view: json["arc"]["stat"]["view"],
        danmaku: json["arc"]["stat"]["danmaku"],
        reply: json["arc"]["stat"]["reply"],
        fav: json["arc"]["stat"]["fav"],
        coin: json["arc"]["stat"]["coin"],
        share: json["arc"]["stat"]["share"],
        like: json["arc"]["stat"]["like"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": aid,
        "mid": cid,
        "name": title,
        "title": title,
        "pic": pic,
        "pubdate": pubDate,
        "duration": duration,
      };
}
