// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showPrice(element){
	var e = document.getElementById(element);
	var details = document.getElementById('payDetails');
	var options = document.getElementById('payOptions');
	var price = e.value * 99;
	details.innerHTML = "Your total will be <strong>$" + price + ".00</strong>.";
	options.style.visibility = 'visible';
	details.style.visibility = 'visible';	
}