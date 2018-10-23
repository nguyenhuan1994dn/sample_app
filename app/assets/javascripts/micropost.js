var to_MB = function (file) {
  return file.size / 1024 / 1024
}

$("#micropost_picture").bind("change", function () {
  var size_in_megabytes = to_MB(this.files[0]);
  if (size_in_megabytes > 5) {
    alert(I18n.t("shared.micropost_form.max_file_size"));
  }
});
