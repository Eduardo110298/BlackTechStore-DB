if (location.pathname == "/checkout/"){
  //Removing checkout form.
  var checkoutNode = document.getElementsByClassName("woocommerce")[1].children[2]
  document.getElementsByClassName("woocommerce")[1].removeChild(checkoutNode)

  //Making up the container with info.
  var checkoutInfo = document.createElement('DIV')
  checkoutInfo.className = "woocommerce-info"

  //The toggle switch
  var checkoutInfoLInk = document.createElement('A')
  checkoutInfoLink.href = "#"
  checkoutInfoLink.id = "checkoutInfoLink"
  checkoutInfoLink.innerText = "Or you can click here to continue and register"

  //Putting the switch into container.
  checkoutInfo.appendChild(checkoutInfoLink)

  //Putting the new container into the woocommerce page.
  document.getElementsByClassName("woocommerce")[1].appendChild(checkoutInfo)

  //Preparing the checkout form.
  checkoutNode.id = "checkoutNode"
  checkoutNode.style.display = "none"

  //Putting it into the woocommerce page.
  document.getElementsByClassName("woocommerce")[1].appendChild(checkoutNode)

  //The slideToggle logic:
  jQuery("#checkoutInfoLink").click(function(){
    jQuery("#checkoutNode").slideToggle(700);
  })
}
