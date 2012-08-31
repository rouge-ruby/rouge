Blag = {};
jQuery.noConflict();

Blag.ReadMore = (function($) {
  function getFold(button) {
    return $(button).siblings('.fold');
  }

  function expand(e) {
    e.preventDefault();

    var self = $(this);

    getFold(self).show();
    self.html('&laquo; less');
  }

  function contract(e) {
    e.preventDefault();

    var self = $(this);

    getFold(self).hide();
    self.html('more &raquo;')
  }

  function init() {
    $('a.read-more').toggle(expand, contract);
  }

  $(document).ready(init);
})(jQuery);
