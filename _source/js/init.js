(function(){
  function initGoogleAdSense() {
    if (!window.adsbygoogle) window.adsbygoogle = [];
    var i = document.getElementsByClassName('adsbygoogle').length;
    while (i-- > 0) {
      window.adsbygoogle.push({});
    }
  }

  window.addEventListener('load', function(){
    initGoogleAdSense();
  }, false);
})();
