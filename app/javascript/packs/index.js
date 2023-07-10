$(document).on('turbolinks:load', function() {
  var memberAmountInput = $('#order_amount_member');
  var tourCostInput = $('#order_tour_cost');
  var totalCostDiv = $('#order_total_cost');
  var tourGuideCheckbox = $('#order_tour_guide');
  var tourGuideCostInput = $('#order_tour_guide_cost');
  var amountMemberDiv = $('#apply_for_amount_member');

  memberAmountInput.on('input', updateTotalCost);
  tourGuideCheckbox.on('change', updateTotalCost);

  function updateTotalCost(){
    var memberAmount = parseInt(memberAmountInput.val());
    var tourCost = parseInt(tourCostInput.val());
    var tourGuideCost = parseInt(tourGuideCostInput.val());

    if(memberAmount > 0){
      var totalCost = memberAmount * tourCost;
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
})
