function simRappor(n, pK, s) {

	r = new window.Rappor({
		publicKey: pK
	});

	r._print();

	for (var i = 0; i < n; i++) {
	
		r.send(s);
		
	}
}

console.log("rappor-sim.js loaded")