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
        const html = `
          <h2>${data.name}</h2>
          <p>Category: ${data.category.name}</p>
          <p>Cost: ${data.cost}</p>
          <p>Visit Location: ${data.visit_location}</p>
          <div class="close-btn">Đóng</div>
        `;
        $("#tour-details-popup .popup-content").html(html);
        $("#tour-details-popup").show();
      },
      error: function (xhr, status, error) {
        console.error(error);
      }
    });
  });

  $(document).on("click", "#tour-details-popup .close-btn", function () {
    $("#tour-details-popup").hide();
  });

  $(document).on("click", "#closePopupError", function () {
    $("#error_explanation").hide();
  });
})
