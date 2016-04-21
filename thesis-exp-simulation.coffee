Rappor = require "./rappor"

simTest = () ->
	# strs = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8", "test9", "test10", "test11", "test12", "test13", "test14", "test15", "test16", "test17", "test18", "test19", "test20"]
	# freq = [391, 401, 411, 421, 432, 443, 454, 465, 477, 489, 502, 514, 527, 541, 554, 568, 583, 598, 613, 628]

	strs = ["2test1", "2test2", "2test3", "2test4", "2test5", "2test6", "2test7", "2test8", "2test9", "2test10"]
	freq = [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000]

	# strs = ["3test1", "3test2", "3test3", "3test4", "3test5"]
	# freq = [1621, 1792, 1980, 2189, 2419]

	# strs = ["true", "false"]
	# freq = [5000, 5000]

	params = []

	# scenario 1, k=16
	# params.push({k:16, m:8,   p:0, q:1, f:0.87, h:2})
	# params.push({k:16, m:16,  p:0, q:1, f:0.87, h:2})
	# params.push({k:16, m:32,  p:0, q:1, f:0.87, h:2})
	# params.push({k:16, m:64,  p:0, q:1, f:0.87, h:2})
	# params.push({k:16, m:128, p:0, q:1, f:0.87, h:2})

	# scenario 1, k=32
	# params.push({k:32, m:8,   p:0, q:1, f:0.87, h:2})
	# params.push({k:32, m:16,  p:0, q:1, f:0.87, h:2})
	# params.push({k:32, m:32,  p:0, q:1, f:0.87, h:2})
	# params.push({k:32, m:64,  p:0, q:1, f:0.87, h:2})
	# params.push({k:32, m:128, p:0, q:1, f:0.87, h:2})

	# scenario 2, m=16
	# params.push({k:32, m:16, p:0.1, q:0.5, f:0.81, h:3})
	# params.push({k:32, m:16, p:0.1, q:0.8, f:0.81, h:2})
	# params.push({k:32, m:16, p:0.1, q:0.9, f:0.83, h:2})
	# params.push({k:32, m:16, p:0.1, q:0.9, f:0.89, h:3})
	# params.push({k:32, m:16, p:0.4, q:0.9, f:0.84, h:3})

	# scenario 2, m=32
	# params.push({k:32, m:32, p:0.1, q:0.5, f:0.81, h:3})
	# params.push({k:32, m:32, p:0.1, q:0.8, f:0.81, h:2})
	# params.push({k:32, m:32, p:0.1, q:0.9, f:0.83, h:2})
	# params.push({k:32, m:32, p:0.1, q:0.9, f:0.89, h:3})
	# params.push({k:32, m:32, p:0.4, q:0.9, f:0.84, h:3})

	# scenario 2, m=64
	# params.push({k:32, m:64, p:0.1, q:0.5, f:0.81, h:3})
	# params.push({k:32, m:64, p:0.1, q:0.8, f:0.81, h:2})
	# params.push({k:32, m:64, p:0.1, q:0.9, f:0.83, h:2})
	# params.push({k:32, m:64, p:0.1, q:0.9, f:0.89, h:3})
	# params.push({k:32, m:64, p:0.4, q:0.9, f:0.84, h:3})

	# scenario 2, m=128
	params.push({k:32, m:128, p:0.1, q:0.5, f:0.81, h:3})
	params.push({k:32, m:128, p:0.1, q:0.8, f:0.81, h:2})
	params.push({k:32, m:128, p:0.1, q:0.9, f:0.83, h:2})
	params.push({k:32, m:128, p:0.1, q:0.9, f:0.89, h:3})
	params.push({k:32, m:128, p:0.4, q:0.9, f:0.84, h:3})

	publicKeys  = []
	privateKeys = []

	# scenario 1, k=16
	# publicKeys.push("1e6b5b7745a1")
	# privateKeys.push("d33cd8be6e6a")
	# publicKeys.push("c34f45f82e4f")
	# privateKeys.push("0c7561c3d4e1")
	# publicKeys.push("bf3258b0d7a7")
	# privateKeys.push("eb387343987a")
	# publicKeys.push("0d386035a31d")
	# privateKeys.push("d80d1d5c05c3")
	# publicKeys.push("65b0c71c547f")
	# privateKeys.push("62562f621cfb")

	# scenario 1, k=32
	# publicKeys.push("372f7c3b2631")
	# privateKeys.push("f4d4a5b8d530")
	# publicKeys.push("7fec53cdb682")
	# privateKeys.push("b91f7ae8293e")
	# publicKeys.push("e279900ca0e1")
	# privateKeys.push("e7b064e80328")
	# publicKeys.push("dbe918cabe9e")
	# privateKeys.push("72a7bb49c87b")
	# publicKeys.push("de5382619eb4")
	# privateKeys.push("c5b1147d7423")

	# scenario 2, m=16
	# publicKeys.push("6cd1db034ec7")
	# privateKeys.push("4fb2597c36cb")
	# publicKeys.push("9f0befcfed82")
	# privateKeys.push("fcf0ee1ac4cc")
	# publicKeys.push("ea3d03536e04")
	# privateKeys.push("b247df90bfcf")
	# publicKeys.push("d51027f01d6a")
	# privateKeys.push("419d6bbe4562")
	# publicKeys.push("5c78dd47d7ea")
	# privateKeys.push("f28851177a45")

	# scenario 2, m=32
	# publicKeys.push("3fa2d8cf50f9")
	# privateKeys.push("0e0abe194afa")
	# publicKeys.push("0b7ac13d4c20")
	# privateKeys.push("16f643329940")
	# publicKeys.push("1542387d3e94")
	# privateKeys.push("178343c6df5c")
	# publicKeys.push("7974b6b82667")
	# privateKeys.push("54a76155f67d")
	# publicKeys.push("4428bec347d6")
	# privateKeys.push("41b511337569")

	# scenario 2, m=64
	# publicKeys.push("dd85953ffbc7")
	# privateKeys.push("d54ee709fbf1")
	# publicKeys.push("d907b1595800")
	# privateKeys.push("a85da425a549")
	# publicKeys.push("2ae16f7bd702")
	# privateKeys.push("9761f5549318")
	# publicKeys.push("c174a5804af8")
	# privateKeys.push("d2cbc025b2c3")
	# publicKeys.push("bdb8d4bc8347")
	# privateKeys.push("35084505fa63")

	# scenario 2, m=128
	publicKeys.push("494cb1289b6c")
	privateKeys.push("ecc7a74c9020")
	publicKeys.push("6b6a1203f7ec")
	privateKeys.push("dd8d39dd8f1a")
	publicKeys.push("6ac45a21d2e7")
	privateKeys.push("31573930e745")
	publicKeys.push("376f781c73d0")
	privateKeys.push("1eeaeaa45665")
	publicKeys.push("b771411019ed")
	privateKeys.push("1e611e0a1119")

	# scenario 3, m=16
	# publicKeys.push("fbca7a1c9770")
	# privateKeys.push("89b3b93c25ed")
	# publicKeys.push("895d99eec0b9")
	# privateKeys.push("52425d76c235")
	# publicKeys.push("acd3a664eeae")
	# privateKeys.push("8c1455f8c721")
	# publicKeys.push("816113e3d826")
	# privateKeys.push("de20079f1196")
	# publicKeys.push("48f60aa15285")
	# privateKeys.push("6b1b325b000c")

	# scenario 3, m=32
	# publicKeys.push("7757ecd9461a")
	# privateKeys.push("46faecf077ec")
	# publicKeys.push("7837e66e7e91")
	# privateKeys.push("6a65d82c7759")
	# publicKeys.push("006f755c89bf")
	# privateKeys.push("c96cecd7da53")
	# publicKeys.push("c11857a0e142")
	# privateKeys.push("f2dc7b2d5f8d")
	# publicKeys.push("a43bf9a7f463")
	# privateKeys.push("af5a135176d4")

	# scenario 3, m=64
	# publicKeys.push("916e403e2b4d")
	# privateKeys.push("fdd7acb42508")
	# publicKeys.push("d2d70596d415")
	# privateKeys.push("dc7818a942e2")
	# publicKeys.push("03fba1faf6e0")
	# privateKeys.push("348d83dfe06d")
	# publicKeys.push("d520ca1014df")
	# privateKeys.push("cf1f3d1772fc")
	# publicKeys.push("29952be98a97")
	# privateKeys.push("fbffa0a3db30")

	# scenario 4, m=16
	# publicKeys.push("f868719c1ffb")
	# privateKeys.push("c3cbe7f7c7e9")
	# publicKeys.push("4d6f58153dbb")
	# privateKeys.push("39d2b644812a")
	# publicKeys.push("86c55a12f869")
	# privateKeys.push("ecc61f50d70b")
	# publicKeys.push("e3b2c2fb0638")
	# privateKeys.push("81d3dadd47a6")
	# publicKeys.push("907d66151a33")
	# privateKeys.push("d4a71058287a")

	# scenario 4, m=32
	# publicKeys.push("ff6e8774092f")
	# privateKeys.push("423940018967")
	# publicKeys.push("29cc2a686aaa")
	# privateKeys.push("3c64790eab18")
	# publicKeys.push("923a2742b0e9")
	# privateKeys.push("0adb9e420a9c")
	# publicKeys.push("1987789a458f")
	# privateKeys.push("f7b50c2523b7")
	# publicKeys.push("1f0421d810dd")
	# privateKeys.push("e835a35ae306")

	# scenario 4, m=64
	# publicKeys.push("d2d71aef4a5d")
	# privateKeys.push("cb6fcb08a23b")
	# publicKeys.push("5040b87de939")
	# privateKeys.push("bd8666762493")
	# publicKeys.push("07a6836549e9")
	# privateKeys.push("c2fcad32d1a4")
	# publicKeys.push("615e8eff961d")
	# privateKeys.push("8541b9409f16")
	# publicKeys.push("b19021a62fc8")
	# privateKeys.push("9038614ea819")

	# scenario 4, m=128
	# publicKeys.push("1459857604b1")
	# privateKeys.push("e045e3505817")
	# publicKeys.push("c86ba58c5059")
	# privateKeys.push("9dcca1143841")
	# publicKeys.push("3ac719ac6f14")
	# privateKeys.push("1c9da10cfc3c")
	# publicKeys.push("fb517c82bd55")
	# privateKeys.push("eba609020953")
	# publicKeys.push("43b82b72210e")
	# privateKeys.push("ec67516db87f")


	# for i in [0..15-1]
	i=4
	r = new Rappor({ params: params[i], publicKey: publicKeys[i] })
	console.log "params is #{params[i]} and public key is #{publicKeys[i]}"

	for j in [0..strs.length-1]
		console.log "string is #{strs[j]} and freq is #{freq[j]}"
		setTimeout(r.send(strs[j], {n: freq[j], callback: () -> console.log "#{i} test and string #{j} is done." }), 5000)

	r._print()

console.log "thesis-exp-simulation.js loaded"
simTest()

# true
# false

# 2test1
# 2test2
# 2test3
# 2test4
# 2test5
# 2test6
# 2test7
# 2test8
# 2test9
# 2test10

# 3test1
# 3test2
# 3test3
# 3test4
# 3test5
# fake1
# fake2
# fake3
# fake4
# fake5
