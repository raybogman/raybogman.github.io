$(function() {

    $('.menus h3').on('click', function(e) {
        $(this).next('ul').toggleClass('open');
        updateHeight();
        e.preventDefault(); return false;
    });

});
