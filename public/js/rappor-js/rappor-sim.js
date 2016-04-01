function simRappor(n, p, pK, s) {

	r = new window.Rappor({
		publicKey: pK
	});

	r._print();

	for (var i = 0; i < n; i++) {
	
		if (s === undefined || s == "") {
			if (Math.random() < p)
				bool = true;
			else
				bool = false;

			r.send(bool);
		}
		else {
			r.send(s);
		}
		
	}
}

console.log("rappor-sim.js loaded")