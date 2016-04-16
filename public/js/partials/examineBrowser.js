$("#keyInfo").hide();

$("#browserLabel").append(" (e.g. this browser returns \"" + RapporExamine.getBrowser() + "\")");
RapporExamine.getAdBlock(adBlockSuccess, adBlockFailure);
$("#pluginsLabel").append(" (e.g. this browser returns \"[" + RapporExamine.getPlugins() + "]\")");
$("#languageLabel").append(" (e.g. this browser returns \"" + RapporExamine.getLanguage() + "\")");
$("#touchLabel").append(" (e.g. this browser returns \"" + RapporExamine.getTouchSupport() + "\")");

function adBlockSuccess() {
	$("#adBlockerLabel").append(" (e.g. this browser returns \"true\")");
};

function adBlockFailure() {
	$("#adBlockerLabel").append(" (e.g. this browser returns \"true\")");
};

$('input[name=radioF]').change(function(){
	if ($('input[name=radios]:checked').val()) {
		$("#keysButton").removeAttr("disabled");
    	$("#keysButton").focus();
	}
});

$('input[name=radios]').change(function(){
	if ($('input[name=radioF]:checked').val()) {
		$("#keysButton").removeAttr("disabled");
    	$("#keysButton").focus();
	}
});

function getKeys() {
	$("#keysButton").attr("disabled", "disabled");

	$.post( "/api/v1/credentials", function( data ) {
		console.log(data);

		var craftedURL1 = window.location.origin + "/generate/" + data.privateKey;
		var craftedURL2 = window.location.origin + "/send/" + data.publicKey;

		$("#privateKey").text(craftedURL1);
		$("#privateKey").attr("href", craftedURL1);

		$("#publicKey").text(craftedURL2);
		$("#publicKey").attr("href", craftedURL2);

		$("#keyInfo").show();
		genCode();
	});
};

function genCode() {
	templateString = getOperationString();
	$("#finalCode").text(templateString);
};

function getOperationString() {
	console.log($('input[name=radios]:checked').attr("id"));
	console.log($('input[name=radioF]:checked').attr("id"));

	var checked = $('input[name=radios]:checked').attr("id");
	var freqStr = $('input[name=radioF]:checked').attr("id");


	var finalStr = `<script src="http://cdn.rapporjs.com/rappor.min.js">`

	if (checked != "otherRadio")
		finalStr += `\n<script src="http://cdn.rapporjs.com/rappor-examine.min.js">`;

	finalStr += `\n\n<script>\n`

	finalStr += `\tr = new window.Rappor({ publicKey: "` + $("#privateKey").text() + `" });\n`		

	switch(checked) {
		case "browserRadio":
			finalStr += `\tr.send(RapporExamine.getBrowser(), {freq: "` + freqStr + `"});\n`;
			break;
		case "adBlockerRadio":
			finalStr += `\tRapporExamine.getAdBlock(r.sendTrue({freq: "` + freqStr + `"}), r.sendFalse({freq: "` + freqStr + `"})));\n`;
			break;
		case "pluginsRadio":
			finalStr += `\tr.send(RapporExamine.getPlugins(), {freq: "` + freqStr + `"});\n`;
			break;
		case "languageRadio":
			finalStr += `\tr.send(RapporExamine.getLanguage(), {freq: "` + freqStr + `"});\n`;
			break;
		case "touchRadio":
			finalStr += `\tr.send(RapporExamine.getTouchSupport(), {freq: "` + freqStr + `"});\n`;
			break;
		case "otherRadio":
			finalStr += `\tr.send("anything!", {freq: "` + freqStr + `"});\n`;
			break;
		default:
			break;
	}

	finalStr += `</script>\n`

	return finalStr;
};