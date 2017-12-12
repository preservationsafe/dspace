function setSelected (selectElement) {
    if(selectElement) {
        var option = selectElement.getAttribute('data-selected');
        var i;
        if(option) {
            for (i = 0; i < selectElement.options.length; i++) {
                if (selectElement.options[i].innerHTML == option) {
                    selectElement.options[i].selected = true;
                    return;
                }
            }
        }
    }
}

$.noConflict();
(function ($) {
    $(document).ready(function () {
        setSelected(document.getElementById("issue_year"));
        setSelected(document.getElementById("issue_month"));
    });
})(jQuery);
