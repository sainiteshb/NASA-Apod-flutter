class Apod {
  final String imageUrl;
  final String imageInfo;
  final String imageTitle;
  final String mediaType;

  Apod.fromMap(Map<String, dynamic> apodDetails)
      : this.imageInfo = apodDetails['explanation'] == null
            ? "Data is not yet available , select another date "
            : apodDetails["explanation"],
        this.imageTitle = apodDetails['title'] == null
            ? "Data is not available"
            : apodDetails['title'],
        this.mediaType = apodDetails['media_type'],
        this.imageUrl = (apodDetails['media_type'] == "image")
            ? apodDetails['hdurl']
            : null;
}
