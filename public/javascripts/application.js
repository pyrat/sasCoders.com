// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showPrice(element){
	var e = document.getElementById(element);
	var div = document.getElementById('showPrice');
	var price = e.value * 99;
	div.innerHTML = "Your total price will be <strong>$" + price + ".00</strong>.";
	div.style.visibility = 'visible'	
}