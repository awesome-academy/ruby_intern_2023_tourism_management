$(document).on('turbolinks:load', function() {
  var memberAmountInput = $('#order_amount_member');
  var tourCostInput = $('#order_tour_cost');
  var totalCostDiv = $('#order_total_cost');
  var tourGuideCheckbox = $('#order_tour_guide');
  var tourGuideCostInput = $('#order_tour_guide_cost');
  var amountMemberDiv = $('#apply_for_amount_member');
  var serviceOptionRadio = $('input[name="order[service_option]"]');

  memberAmountInput.on('input', updateTotalCost);
  tourGuideCheckbox.on('change', updateTotalCost);
  serviceOptionRadio.on('change', updateTotalCost);

  function updateTotalCost(){
    var memberAmount = parseInt(memberAmountInput.val());
    var serviceCost = parseInt(serviceOptionRadio.filter(':checked')[0].dataset.optionCost);
    if(serviceCost > 0){
      unit_cost = serviceCost
    } else {
      unit_cost = parseInt(tourCostInput.val());
    }
    var tourGuideCost = parseInt(tourGuideCostInput.val());

    if(memberAmount > 0){
      var totalCost = memberAmount * unit_cost;
      if (tourGuideCheckbox.is(':checked')) {
        totalCost += tourGuideCost;
      }
      totalCostDiv.text(I18n.t("orders.new.total_cost", {total_cost: numberToCurrency(totalCost)}));
      amountMemberDiv.text(I18n.t("orders.new.amount_member", {amount_member: memberAmount}))
    }
  }

  function numberToCurrency(number) {
    return number.toLocaleString('vi-VN', { style: 'currency', currencyDisplay: 'symbol', currency: 'VND' }).replace('₫', 'VNĐ');
  }

  $('#tour_is_create_category').change(function() {
    if ($(this).is(':checked')) {
      $('#new_category_content').show();
    } else {
      $('#new_category_content').hide();
    }
  });

  if ($('#tour_is_create_category').is(':checked')) {
    $('#new_category_content').show();
  } else {
    $('#new_category_content').hide();
  }

  setTimeout(function() {
    $('.alert').hide();
  }, 4999);

  $('.form-check-input').change(function() {
    $('#btn_filter_by').click();
  });

  $('#select_cost_range').change(function() {
    let arr = $('#select_cost_range').val().split("-")
    $('#cost_gteq').val(parseInt(arr[0]))
    $('#cost_lteq').val(parseInt(arr[1]))
    $('#btn_filter_by').click();
  });

  $(document).on("click", ".tour-link", function (e) {
    e.preventDefault();
    const tourId = $(this).data("tour-id");
    $.ajax({
      url: `/admin/tours/${tourId}`,
      method: "GET",
      dataType: "json",
      success: function (data) {
        $("#tour_details_popup .popup-title").text(data.name)
        $("#tour_category_name").text(data.category.name)
        $("#tour_cost").text(numberToCurrency(data.cost))
        $("#tour_description").text(data.description)
        $("#tour_start_date").text(formatDate(data.start_date))
        $("#tour_end_date").text(formatDate(data.end_date))
        $("#tour_visit_location").text(data.visit_location)
        $("#tour_start_location").text(data.start_location)
        $("#tour_guide_cost").text(numberToCurrency(data.tour_guide_cost))
        $("#tour_details_popup").show();
      },
      error: function (xhr, status, error) {
        console.error(error);
      }
    });
  });

  $(document).on("click", "#tour_details_popup .close-btn", function () {
    $("#tour_details_popup").hide();
  });

  $(document).on("click", "#closePopupError", function () {
    $("#error_explanation").hide();
  });

  $(document).on("click", ".order-link", function (e) {
    e.preventDefault();
    const orderId = $(this).data("order-id");
    $.ajax({
      url: `/admin/orders/${orderId}`,
      method: "GET",
      dataType: "json",
      success: function (data) {
        $("#order_id").text(data.id)
        $("#order_tour_name").text(data.tour.name)
        $("#order_unit_cost").text(numberToCurrency(data.total_cost/data.amount_member))
        $("#order_member").text(data.amount_member)
        $("#order_user").text(data.user.name)
        $("#order_contact_name").text(data.contact_name)
        $("#order_contact_phone").text(data.contact_phone)
        $("#order_contact_address").text(data.contact_address)
        if(data.tour_guide == 1){
          $("#order_tour_guide").text(I18n.t("admin.orders.order_detail.regis_tour_guide"))
        } else {
          $("#order_tour_guide").text(I18n.t("admin.orders.order_detail.unregis_tour_guide"))
        }
        if(data.status == "pending"){
          $("#order_status").text(I18n.t("orders.status.pending"))
        }
        else if(data.status == "approved"){
          $("#order_status").text(I18n.t("orders.status.approved"))
        }
        else if(data.status == "cancelled"){
          $("#order_status").text(I18n.t("orders.status.cancelled"))
        }
        else{
          $("#order_status").text(I18n.t("orders.status.done"))
        }
        $("#order_details_popup").show();
      },
      error: function (xhr, status, error) {
        console.error(error);
      }
    });
  });

  $(document).on("click", "#order_details_popup .close-btn", function () {
    $("#order_details_popup").hide();
  });

  function formatDate(formatDate) {
    let _formatDate = new Date(formatDate);
    if (formatDate && _formatDate instanceof Date && !isNaN(_formatDate.valueOf())){
      let _date = _formatDate.getDate();
      let _month = _formatDate.getMonth() + 1;
      let _year = _formatDate.getFullYear();

      if (_month <= 9) {
        if (_date <= 9) {
          _formatDate = `0${_date}-0${_month}-${_year}`;
        } else {
          _formatDate = `${_date}-0${_month}-${_year}`;
        }
      } else {
        _formatDate = `${_date}/${_month}/${_year}`;
      }
      return _formatDate;
    } else {
      return "";
    }
  }
})
