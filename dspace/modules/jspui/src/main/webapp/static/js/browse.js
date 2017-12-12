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

        $("#starts-date").datepicker({
            dateFormat: "yy-mm-dd" ,
            monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            dayNamesMin:["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        });
        $("#ends-date").datepicker({
            dateFormat: "yy-mm-dd",
            monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            dayNamesMin:["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        });
    });
})(jQuery);
