function simRappor(n, p) {

	for (var i = 0; i < n; i++) {
	
		r = new window.Rappor();

		if (Math.random() < p)
			bool = true;
		else
			bool = false;

		r.send(bool);
	}
}

console.log("rappor-sim.js loaded")