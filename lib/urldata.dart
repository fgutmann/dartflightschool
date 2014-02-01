library urldata;

class UrlData {
  String protocol;
  String server;
  String path;
  
  UrlData(this.protocol, this.server, this.path);
  
  UrlData.fromString(String url) {
    var regex = new RegExp('([^:]+)://([^/]*)/(.*)');
    var match = regex.matchAsPrefix(url);
    if(match == null) {
      throw new Exception("Not a valid url");
    }
    
    protocol = match.group(1);
    server = match.group(2);
    path = '/' + match.group(3);
  }
}
