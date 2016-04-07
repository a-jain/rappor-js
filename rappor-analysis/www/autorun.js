function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)", "i"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

console.log("autorun.js loaded")

function click() {
	if (getParameterByName("key") != null) {
		$("#run").click();
	}
}

$(function() {
	window.setTimeout(click, 10);
});



