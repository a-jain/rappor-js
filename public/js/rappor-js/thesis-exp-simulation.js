(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var simTest;

simTest = function() {
  var freq, i, j, k, params, privateKeys, publicKeys, r, results, strs;
  strs = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8", "test9", "test10", "test11", "test12", "test13", "test14", "test15", "test16", "test17", "test18", "test19", "test20"];
  freq = [299, 314, 330, 347, 365, 383, 403, 424, 445, 468, 492, 517, 544, 572, 601, 632, 664, 699, 734, 772];
  params = [];
  params.push({
    k: 32,
    m: 16,
    p: 0.1,
    q: 0.5,
    f: 0.81,
    h: 3
  });
  params.push({
    k: 32,
    m: 16,
    p: 0.1,
    q: 0.8,
    f: 0.81,
    h: 2
  });
  params.push({
    k: 32,
    m: 16,
    p: 0.1,
    q: 0.9,
    f: 0.83,
    h: 2
  });
  params.push({
    k: 32,
    m: 16,
    p: 0.1,
    q: 0.9,
    f: 0.89,
    h: 3
  });
  params.push({
    k: 32,
    m: 16,
    p: 0.4,
    q: 0.9,
    f: 0.84,
    h: 3
  });
  params.push({
    k: 32,
    m: 32,
    p: 0.1,
    q: 0.5,
    f: 0.81,
    h: 3
  });
  params.push({
    k: 32,
    m: 32,
    p: 0.1,
    q: 0.8,
    f: 0.81,
    h: 2
  });
  params.push({
    k: 32,
    m: 32,
    p: 0.1,
    q: 0.9,
    f: 0.83,
    h: 2
  });
  params.push({
    k: 32,
    m: 32,
    p: 0.1,
    q: 0.9,
    f: 0.89,
    h: 3
  });
  params.push({
    k: 32,
    m: 32,
    p: 0.4,
    q: 0.9,
    f: 0.84,
    h: 3
  });
  params.push({
    k: 32,
    m: 64,
    p: 0.1,
    q: 0.5,
    f: 0.81,
    h: 3
  });
  params.push({
    k: 32,
    m: 64,
    p: 0.1,
    q: 0.8,
    f: 0.81,
    h: 2
  });
  params.push({
    k: 32,
    m: 64,
    p: 0.1,
    q: 0.9,
    f: 0.83,
    h: 2
  });
  params.push({
    k: 32,
    m: 64,
    p: 0.1,
    q: 0.9,
    f: 0.89,
    h: 3
  });
  params.push({
    k: 32,
    m: 64,
    p: 0.4,
    q: 0.9,
    f: 0.84,
    h: 3
  });
  publicKeys = [];
  privateKeys = [];
  publicKeys.push("6cd1db034ec7");
  privateKeys.push("4fb2597c36cb");
  publicKeys.push("9f0befcfed82");
  privateKeys.push("fcf0ee1ac4cc");
  publicKeys.push("ea3d03536e04");
  privateKeys.push("b247df90bfcf");
  publicKeys.push("d51027f01d6a");
  privateKeys.push("419d6bbe4562");
  publicKeys.push("5c78dd47d7ea");
  privateKeys.push("f28851177a45");
  publicKeys.push("3fa2d8cf50f9");
  privateKeys.push("0e0abe194afa");
  publicKeys.push("0b7ac13d4c20");
  privateKeys.push("16f643329940");
  publicKeys.push("1542387d3e94");
  privateKeys.push("178343c6df5c");
  publicKeys.push("7974b6b82667");
  privateKeys.push("54a76155f67d");
  publicKeys.push("4428bec347d6");
  privateKeys.push("41b511337569");
  publicKeys.push("dd85953ffbc7");
  privateKeys.push("d54ee709fbf1");
  publicKeys.push("d907b1595800");
  privateKeys.push("a85da425a549");
  publicKeys.push("2ae16f7bd702");
  privateKeys.push("9761f5549318");
  publicKeys.push("c174a5804af8");
  privateKeys.push("d2cbc025b2c3");
  publicKeys.push("bdb8d4bc8347");
  privateKeys.push("35084505fa63");
  results = [];
  for (i = k = 1; k <= 15; i = ++k) {
    r = new window.Rappor({
      params: params[i],
      publicKey: publicKeys[i]
    });
    results.push((function() {
      var l, results1;
      results1 = [];
      for (j = l = 1; l <= 20; j = ++l) {
        results1.push(setTimeout(r.send(strs[j], {
          n: freq[j],
          callback: function() {
            return console.log(i + " test and string " + j + " is done.");
          }
        }), 5000));
      }
      return results1;
    })());
  }
  return results;
};

console.log("thesis-exp-simulation.js loaded");

simTest();


},{}]},{},[1]);
