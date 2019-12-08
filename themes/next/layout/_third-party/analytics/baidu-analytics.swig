{%- if theme.baidu_analytics %}
  <script{{ pjax }}>
    var _hmt = _hmt || [];
    (function() {
      var hm = document.createElement("script");
      hm.src = "https://hm.baidu.com/hm.js?9d7a50997a9a455fe95cbc11d24b70fa";
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hm, s);
    })();
  </script>
{%- endif %}
