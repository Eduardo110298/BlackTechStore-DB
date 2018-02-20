var checkoutNode = document.getElementsByClassName("woocommerce")[1].children[2]
document.getElementsByClassName("woocommerce")[1].removeChild(checkoutNode)
var checkoutInfo = document.createElement('DIV')
checkoutInfo.className = "woocommerce-info"
checkoutInfo.innerText = "Or you can"
var checkoutInfoLInk = document.createElement('A')
checkoutInfoLink.href = "#"
checkoutInfoLink.id = "checkoutInfoLink"